# API contract

The browser talks directly to Supabase for public reads and authenticated row-level operations. Privileged workflows use Edge Functions.

## Auth

- Supabase Auth: sign-up, email verification, login, logout, password recovery and session persistence.
- Account deletion: `POST /functions/v1/delete-account` with an authenticated bearer token and password confirmation.

## Marketplace

- `listings`: public published reads; seller-owned draft/submission writes.
- `listing_versions`: seller/admin writes; published-version reads.
- `listing_licenses`: listing-specific license terms.
- `verification_checks`: public evidence, admin writes.

## Commerce

- `POST /functions/v1/create-order`: creates a pending order and returns a provider checkout reference only when the provider is configured.
- `POST /functions/v1/payment-webhook`: provider webhook endpoint; verifies the provider signature before changing an order to PAID.
- License creation is server-side and tied to the paid order.

A frontend response alone can never turn an order into a paid order.
