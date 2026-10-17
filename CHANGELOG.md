# Changelog

## 1.0.0 — 2026-10-17

### Added
- Static Next.js GitHub Pages frontend with `/DevXchange` base path.
- Marketplace, categories, technology pages, product template, developer profile, about, trust, licensing, pricing and FAQ pages.
- Supabase Auth integration for registration, verification callback, login, logout, password recovery and account settings.
- Seller submission and admin moderation UI.
- Supabase schema with RLS, listings, versions, licenses, reviews, orders, downloads, support, infringement and verification evidence.
- Edge Function foundations for account deletion and provider-backed order creation/webhooks.
- SEO/AEO/GEO documentation and machine-readable discovery files.
- CI and GitHub Pages deployment workflows.

### Honest limitations
- The repository starts with no marketplace inventory and therefore no fabricated reviews, sales or user counts.
- Product pages are statically generated when a build has read-only server-side catalog credentials; GitHub Pages cannot generate new HTML at request time.
- Payment credentials and provider webhook configuration are external production settings.
- Lighthouse, Search Console and live payment results are not claimed until measured in the deployed environment.
