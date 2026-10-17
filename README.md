# DevXchange

**The marketplace for production-ready software.**

DevXchange is a developer-first marketplace for source code, SaaS projects, web/mobile applications, websites, AI projects, APIs, templates and scripts. Its core promise is simple: **Don't just buy code. Know what you are buying.**

## v1.0.0

The v1 architecture separates the static public application from privileged marketplace operations:

- **Frontend:** Next.js + TypeScript + Tailwind CSS, exported as static HTML for GitHub Pages.
- **Backend:** Supabase Postgres, Auth, Storage, Row Level Security and Edge Functions.
- **Payments:** provider interface with Stripe and Razorpay adapters in Edge Functions. No payment is treated as successful without a provider webhook.
- **Verification:** recorded evidence only. A badge never means more than the checks actually completed.

GitHub Pages cannot execute a server, so secrets and privileged operations never belong in the frontend. Only the Supabase public publishable/anon key is exposed to the browser.

## Local setup

1. Install Node.js 20+ and npm.
2. Clone the repository.
3. Copy `.env.example` to `.env.local` and provide the Supabase URL and public key.
4. Run `npm install`.
5. Run `npm run dev`.
6. Open `http://localhost:3000/DevXchange/`.

The public application is deliberately usable with an empty database. Empty marketplace states say **No listings yet** rather than inventing catalog data.

## Supabase setup

1. Create a Supabase project.
2. Apply migrations in `supabase/migrations/` in filename order.
3. Create Storage buckets described in `supabase/README.md`.
4. Deploy the Edge Functions from `supabase/functions/`.
5. Configure Auth email templates and redirect URLs for the GitHub Pages base path.
6. Configure payment provider secrets only when payments are ready.

## GitHub Pages deployment

The workflow in `.github/workflows/deploy.yml` builds the static export and publishes `apps/web/out` through GitHub Pages. The app uses `/DevXchange` as its base path when deployed from this repository. `404.html` is copied from the static export so direct navigation to public routes can be recovered by the client router.

A `CNAME` file is intentionally absent until a custom domain is configured.

## Trust model

Verification levels are:

0. Unverified
1. Listing Verified
2. Build Verified
3. Deployment Verified
4. Security Reviewed
5. DevXchange Certified

The implementation records individual checks such as archive integrity, file hash fingerprint, secret-pattern scan, README presence, dependency manifest and declared license. Anything not actually checked is displayed as **Not yet checked**.

## Marketplace scope

v1 includes landing, marketplace discovery, categories and technology filters, product pages, seller onboarding and submission, versioning, admin review, structured reviews, buyer dashboard, favorites, support tickets, licensing, infringement reports, orders and signed-expiring download flows.

## Founder

DevXchange was founded by **Syed Ali Hasan Moosavi**, Founder and Managing Director of SAYANJALI NEXUS PRIVATE LIMITED, Hyderabad, India. His work spans AI products, blockchain infrastructure, enterprise SaaS, cybersecurity/OSINT, automation and open-source tooling.

GitHub: https://github.com/SHalimoosavi

## Research notes

The product direction is informed by recurring buyer and seller complaints around established source-code marketplaces: outdated dependencies, unclear scope of what is actually included, abandoned projects, opaque review/refund handling, weak support expectations and difficult seller economics. Recent community discussions also point to a trust problem made sharper by AI-assisted code volume. See `docs/market-research.md` for the evidence and the product decisions derived from it.

## Quality gate

CI runs install, lint, typecheck, build and tests. Browser tests are designed around real Supabase credentials supplied through GitHub Actions secrets; they do not fabricate successful authentication or payments. Lighthouse and Search Console verification are documented separately because their external environments cannot be truthfully claimed from a repository-only build.

## License

See `LICENSE`.
