# SariSari neighborhood store

A Flutter e-commerce demo for a Filipino sari-sari store. It includes a product catalog, search and categories, a shopping basket, Supabase Auth, Supabase product and order storage, and hosted Xendit invoice checkout.

## Run the preview

```powershell
flutter pub get
flutter run -d chrome --dart-define=SUPABASE_URL= --dart-define=SUPABASE_ANON_KEY=
```

The app defaults to the public Supabase URL and anon key that were already in the starter project. Use the empty defines above to open the local preview catalog instead. Checkout is disabled in preview mode. Product photos load from online image hosts and require internet access.

## Connect Supabase

1. Create the BMC / BMC-ecom1 project described in the project guidelines.
2. In Supabase SQL Editor, run [`supabase_schema.sql`](supabase_schema.sql) to create tables, policies, and 20 starter products.
3. The starter project's public URL and anon key are included as defaults. Override them at build/run time for a different project. Never put a service role key or Xendit secret in the Flutter app.

```powershell
flutter run -d chrome --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Enable email/password sign-in in Supabase Authentication. Sign-up may require email confirmation depending on the project's Auth settings.

## Configure Xendit test checkout

Add these Supabase Edge Function secrets in the dashboard: `XENDIT_SECRET_KEY`, `XENDIT_WEBHOOK_TOKEN`, and `SUPABASE_SERVICE_ROLE_KEY`. Use Xendit's **test mode** credentials. Deploy both functions:

```powershell
supabase functions deploy create-invoice
supabase functions deploy xendit-webhook --no-verify-jwt
```

Set Xendit's invoice paid webhook to `https://YOUR_PROJECT.supabase.co/functions/v1/xendit-webhook` and keep the callback verification token secret. The invoice function validates the signed-in user, reads live product prices from Supabase, creates the Xendit invoice, and writes the pending order. The webhook marks the matching order paid.

## Verify locally

```powershell
flutter analyze
flutter test
```

The attached demonstration guide asks for a release APK. Build it with the same public Supabase defines:

```powershell
flutter build apk --release --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

The APK is produced at `build/app/outputs/flutter-apk/app-release.apk`.
