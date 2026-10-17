create extension if not exists pgcrypto;
create type public.user_role as enum ('buyer','seller','admin');
create type public.listing_status as enum ('DRAFT','PENDING_REVIEW','CHANGES_REQUESTED','REJECTED','PUBLISHED');
create type public.license_kind as enum ('PERSONAL','COMMERCIAL','EXTENDED','ENTERPRISE');
create type public.order_status as enum ('PENDING','PAID','FAILED','REFUNDED','CANCELED');

create table public.profiles(
 id uuid primary key references auth.users(id) on delete cascade,
 username text unique,
 display_name text not null default '',
 bio text not null default '',
 role public.user_role not null default 'buyer',
 website_url text,
 github_username text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table public.listings(
 id uuid primary key default gen_random_uuid(), seller_id uuid not null references public.profiles(id) on delete cascade,
 title text not null check(length(title) between 4 and 120), slug text unique not null check(slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
 description text not null check(length(description) between 40 and 5000), category text not null check(category in ('software','web','ai','developer','blockchain','design')),
 price_cents integer not null check(price_cents >= 0), license text, language text, framework text, database text,
 status public.listing_status not null default 'DRAFT', verification_level smallint not null default 0 check(verification_level between 0 and 5),
 current_version text, source_object_key text, demo_url text, support_terms text, published_at timestamptz, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table public.listing_versions(
 id uuid primary key default gen_random_uuid(), listing_id uuid not null references public.listings(id) on delete cascade,
 version text not null, changelog text not null, archive_sha256 text, archive_size bigint, created_at timestamptz not null default now(), unique(listing_id,version)
);
create table public.listing_licenses(
 id uuid primary key default gen_random_uuid(), listing_id uuid not null references public.listings(id) on delete cascade,
 kind public.license_kind not null, price_cents integer not null check(price_cents>=0), permitted text not null, forbidden text not null, unique(listing_id,kind)
);
create table public.favorites(user_id uuid references public.profiles(id) on delete cascade, listing_id uuid references public.listings(id) on delete cascade, created_at timestamptz default now(), primary key(user_id,listing_id));
create table public.reviews(
 id uuid primary key default gen_random_uuid(), listing_id uuid not null references public.listings(id) on delete cascade, buyer_id uuid not null references public.profiles(id) on delete cascade,
 order_id uuid, code_quality smallint not null check(code_quality between 1 and 5), documentation smallint not null check(documentation between 1 and 5), installation smallint not null check(installation between 1 and 5), support smallint not null check(support between 1 and 5), value smallint not null check(value between 1 and 5), would_recommend boolean not null, body text not null check(length(body)<=3000), created_at timestamptz not null default now(), unique(listing_id,buyer_id)
);
create table public.support_tickets(id uuid primary key default gen_random_uuid(), user_id uuid not null references public.profiles(id) on delete cascade, listing_id uuid references public.listings(id) on delete set null, subject text not null, body text not null, status text not null default 'OPEN' check(status in ('OPEN','RESOLVED')), created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create table public.infringement_reports(id uuid primary key default gen_random_uuid(), reporter_id uuid references public.profiles(id) on delete set null, listing_id uuid references public.listings(id) on delete set null, claim text not null, evidence_url text, contact_email text not null, status text not null default 'OPEN', created_at timestamptz not null default now());
create table public.orders(id uuid primary key default gen_random_uuid(), buyer_id uuid not null references public.profiles(id), listing_id uuid not null references public.listings(id), license_kind public.license_kind not null, amount_cents integer not null check(amount_cents>=0), provider text, provider_order_id text unique, provider_payment_id text unique, status public.order_status not null default 'PENDING', created_at timestamptz not null default now(), paid_at timestamptz);
create table public.licenses(id uuid primary key default gen_random_uuid(), order_id uuid unique not null references public.orders(id) on delete cascade, buyer_id uuid not null references public.profiles(id), listing_id uuid not null references public.listings(id), license_kind public.license_kind not null, license_key_hash text not null unique, download_object_key text, expires_at timestamptz, created_at timestamptz not null default now());
create table public.downloads(id uuid primary key default gen_random_uuid(), license_id uuid not null references public.licenses(id) on delete cascade, ip_hash text, created_at timestamptz not null default now());
create table public.verification_checks(id uuid primary key default gen_random_uuid(), listing_id uuid not null references public.listings(id) on delete cascade, version_id uuid references public.listing_versions(id) on delete set null, check_name text not null, result text not null check(result in ('PASS','FAIL','NOT_CHECKED')), evidence jsonb not null default '{}'::jsonb, checked_at timestamptz, unique(listing_id,version_id,check_name));
create table public.audit_logs(id bigint generated always as identity primary key, actor_id uuid references public.profiles(id) on delete set null, action text not null, entity_type text not null, entity_id uuid, metadata jsonb not null default '{}'::jsonb, created_at timestamptz not null default now());

create index listings_status_category_idx on public.listings(status,category);create index listings_seller_idx on public.listings(seller_id);create index reviews_listing_idx on public.reviews(listing_id);create index orders_buyer_idx on public.orders(buyer_id);create index licenses_buyer_idx on public.licenses(buyer_id);

create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$ begin insert into public.profiles(id,display_name,username,role) values(new.id,coalesce(new.raw_user_meta_data->>'name',''),null,'buyer'); return new; end; $$;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
create or replace function public.set_updated_at() returns trigger language plpgsql as $$ begin new.updated_at=now(); return new; end; $$;
create trigger profiles_updated before update on public.profiles for each row execute procedure public.set_updated_at();
create trigger listings_updated before update on public.listings for each row execute procedure public.set_updated_at();
create trigger tickets_updated before update on public.support_tickets for each row execute procedure public.set_updated_at();

alter table public.profiles enable row level security;alter table public.listings enable row level security;alter table public.listing_versions enable row level security;alter table public.listing_licenses enable row level security;alter table public.favorites enable row level security;alter table public.reviews enable row level security;alter table public.support_tickets enable row level security;alter table public.infringement_reports enable row level security;alter table public.orders enable row level security;alter table public.licenses enable row level security;alter table public.downloads enable row level security;alter table public.verification_checks enable row level security;alter table public.audit_logs enable row level security;
create policy profiles_public_read on public.profiles for select using(true);create policy profiles_self_update on public.profiles for update using(auth.uid()=id) with check(auth.uid()=id);
create policy listings_public_read on public.listings for select using(status='PUBLISHED' or seller_id=auth.uid() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));
create policy listings_seller_insert on public.listings for insert with check(seller_id=auth.uid());create policy listings_seller_update on public.listings for update using(seller_id=auth.uid() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));
create policy versions_public_read on public.listing_versions for select using(exists(select 1 from public.listings l where l.id=listing_id and (l.status='PUBLISHED' or l.seller_id=auth.uid())));create policy versions_seller_write on public.listing_versions for all using(exists(select 1 from public.listings l where l.id=listing_id and (l.seller_id=auth.uid() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin')))) with check(exists(select 1 from public.listings l where l.id=listing_id and (l.seller_id=auth.uid() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'))));
create policy license_public_read on public.listing_licenses for select using(exists(select 1 from public.listings l where l.id=listing_id and (l.status='PUBLISHED' or l.seller_id=auth.uid())));create policy license_seller_write on public.listing_licenses for all using(exists(select 1 from public.listings l where l.id=listing_id and l.seller_id=auth.uid())) with check(exists(select 1 from public.listings l where l.id=listing_id and l.seller_id=auth.uid()));
create policy favorites_self on public.favorites for all using(user_id=auth.uid()) with check(user_id=auth.uid());
create policy reviews_public_read on public.reviews for select using(true);create policy reviews_buyer_insert on public.reviews for insert with check(buyer_id=auth.uid());
create policy tickets_self on public.support_tickets for all using(user_id=auth.uid()) with check(user_id=auth.uid());
create policy infringement_insert on public.infringement_reports for insert with check(reporter_id=auth.uid() or reporter_id is null);create policy infringement_self_read on public.infringement_reports for select using(reporter_id=auth.uid() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));
create policy orders_buyer_read on public.orders for select using(buyer_id=auth.uid() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));create policy orders_insert_self on public.orders for insert with check(buyer_id=auth.uid());
create policy licenses_buyer_read on public.licenses for select using(buyer_id=auth.uid() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));
create policy downloads_buyer_insert on public.downloads for insert with check(exists(select 1 from public.licenses l where l.id=license_id and l.buyer_id=auth.uid()));
create policy verification_public_read on public.verification_checks for select using(true);create policy verification_admin_write on public.verification_checks for all using(exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin')) with check(exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));
create policy audit_admin_read on public.audit_logs for select using(exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));

insert into storage.buckets(id,name,public) values('product-assets','product-assets',false) on conflict(id) do nothing;
insert into storage.buckets(id,name,public) values('avatars','avatars',true) on conflict(id) do nothing;
create policy product_assets_owner on storage.objects for all using(bucket_id='product-assets' and (storage.foldername(name))[1]=auth.uid()::text) with check(bucket_id='product-assets' and (storage.foldername(name))[1]=auth.uid()::text);
create policy avatars_public_read on storage.objects for select using(bucket_id='avatars');
create policy avatars_owner_write on storage.objects for all using(bucket_id='avatars' and (storage.foldername(name))[1]=auth.uid()::text) with check(bucket_id='avatars' and (storage.foldername(name))[1]=auth.uid()::text);
