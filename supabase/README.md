# Supabase

Apply migrations in lexical order. Create/deploy the Edge Functions in this directory using the Supabase CLI or dashboard.

Required secrets for privileged functions are listed in `.env.example` and should be configured as Supabase project secrets, not committed.

Storage buckets created by the migration:

- `product-assets` — private source archives and release assets.
- `avatars` — public profile images.

Product archive validation should happen in an isolated worker before a verification result is recorded. Do not execute arbitrary uploaded programs in the Edge Function runtime.
