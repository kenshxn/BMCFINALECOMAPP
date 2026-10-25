import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
Deno.serve(async (req) => {
  if (req.method !== "POST") return new Response("Method not allowed", { status: 405 });
  const expected = Deno.env.get("XENDIT_WEBHOOK_TOKEN");
  const received = req.headers.get("x-callback-token");
  if (!expected || !received || received.length !== expected.length) return new Response("Unauthorized", { status: 401 });
  let difference = 0;
  for (let i = 0; i < expected.length; i++) difference |= expected.charCodeAt(i) ^ received.charCodeAt(i);
  if (difference !== 0) return new Response("Unauthorized", { status: 401 });
  try {
    const payload = await req.json();
    if (payload.status !== "PAID" || typeof payload.external_id !== "string") return new Response("Ignored", { status: 200 });
    const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
    const { error } = await supabase.from("orders").update({ status: "PAID" }).eq("external_id", payload.external_id).eq("amount", payload.paid_amount);
    if (error) throw error;
    return new Response("ok", { status: 200 });
  } catch (e) { console.error("Webhook processing failed", e); return new Response("Webhook processing failed", { status: 500 }); }
});
