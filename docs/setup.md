# Setup

## 1. Frontend

```bash
npm install
npm run dev
npm run lint
npm run typecheck
npm run test
npm run build
```

For GitHub Pages the default base path is `/DevXchange`.

## 2. Environment

Copy `.env.example` to `.env.local`:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`
- `SUPABASE_SERVICE_ROLE_KEY` only in the build environment when pre-rendering product pages; never in browser code.

## 3. Supabase

Apply the SQL migration under `supabase/migrations/`. Configure email verification, password reset and redirect URLs for:

`https://shalimoosavi.github.io/DevXchange/auth/callback/`

and

`https://shalimoosavi.github.io/DevXchange/auth/reset/`

Deploy Edge Functions from `supabase/functions/` with the service role key stored only as a Supabase secret.

## 4. GitHub Pages

Enable GitHub Pages using GitHub Actions. The deployment workflow builds the static export and uploads `apps/web/out`. The workflow must have Pages read/write deployment permissions.

## 5. Payments

Add provider secrets only after the Supabase database and webhook endpoints are ready. Supported adapter names are `stripe` and `razorpay`. Missing credentials intentionally produce `payments_not_configured` rather than a fake checkout success.

## 6. Production hardening

- Configure a custom domain only by adding a `CNAME` file and updating DNS.
- Configure Supabase SMTP for reliable verification and reset emails.
- Configure Storage limits appropriate to the archive types you accept.
- Add GitHub Actions secrets for real end-to-end tests.
- Run Lighthouse against the deployed URL and record the real results before publishing them.
