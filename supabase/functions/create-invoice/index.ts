import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
const cors = { "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type", "Access-Control-Allow-Methods": "POST, OPTIONS" };
Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  try {
    const auth = req.headers.get("Authorization");
    if (!auth) throw new Error("Sign in before checking out.");
    const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_ANON_KEY")!, { global: { headers: { Authorization: auth } } });
    const { data: { user }, error: authError } = await supabase.auth.getUser(auth.replace(/^Bearer\s+/i, ""));
    if (authError || !user) throw new Error("Your session expired. Sign in again.");
    const body = await req.json();
    const items = body.items;
    if (!Array.isArray(items) || items.length === 0 || items.length > 30) throw new Error("Your basket is empty or too large.");
    const quantities = new Map<string, number>();
    for (const item of items) {
      const id = String(item.product_id ?? ""); const qty = Number(item.quantity);
      if (!id || !Number.isInteger(qty) || qty < 1 || qty > 99) throw new Error("Invalid basket item.");
      quantities.set(id, (quantities.get(id) ?? 0) + qty);
    }
    const { data: products, error } = await supabase.from("products").select("id,name,price").in("id", [...quantities.keys()]);
    if (error || !products || products.length !== quantities.size) throw new Error("One or more products are unavailable.");
    const total = products.reduce((sum, p) => sum + Math.round(Number(p.price) * 100) * quantities.get(p.id)!, 0) / 100;
    if (!Number.isFinite(total) || total < 1 || total > 1000000) throw new Error("The basket total is outside the payment limit.");
    const externalId = `sari-${crypto.randomUUID()}`;
    const description = products.map(p => `${p.name} x${quantities.get(p.id)}`).join(", ").slice(0, 240);
    const secret = Deno.env.get("XENDIT_SECRET_KEY");
    if (!secret) throw new Error("Xendit is not configured on the server.");
    const response = await fetch("https://api.xendit.co/v2/invoices", { method: "POST", headers: { "Authorization": `Basic ${btoa(`${secret}:`)}`, "Content-Type": "application/json" }, body: JSON.stringify({ external_id: externalId, amount: total, currency: "PHP", description, invoice_duration: 86400, success_redirect_url: "https://checkout.xendit.co/", failure_redirect_url: "https://checkout.xendit.co/", customer: { email: user.email }, items: products.map(p => ({ name: p.name, quantity: quantities.get(p.id), price: Number(p.price) })) }) });
    const invoice = await response.json();
    if (!response.ok) throw new Error(invoice.message ?? "Xendit could not create the invoice.");
    const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
    const { error: insertError } = await admin.from("orders").insert({ user_id: user.id, product_name: description, amount: total, external_id: externalId, invoice_id: invoice.id, status: "PENDING" });
    if (insertError) throw new Error("The order could not be saved.");
    return new Response(JSON.stringify({ invoice_url: invoice.invoice_url, external_id: externalId }), { headers: { ...cors, "Content-Type": "application/json" } });
  } catch (e) { return new Response(JSON.stringify({ error: e instanceof Error ? e.message : "Unexpected checkout error" }), { status: 400, headers: { ...cors, "Content-Type": "application/json" } }); }
});
