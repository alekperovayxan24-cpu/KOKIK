-- BUTSI Azerbaijan: shared product database + admin RLS
-- Run this entire script in Supabase SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  color text default '',
  sizes text default '',
  price numeric(10,2) not null default 0,
  old_price numeric(10,2),
  stock integer not null default 0,
  image_url text default '',
  category text default '',
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.products enable row level security;

-- Public visitors may only read active products.
drop policy if exists "Public can read active products" on public.products;
create policy "Public can read active products"
on public.products for select
using (is_active = true);

-- Logged-in Supabase users can manage the catalog.
drop policy if exists "Admins can read all products" on public.products;
create policy "Admins can read all products"
on public.products for select to authenticated
using (true);

drop policy if exists "Admins can insert products" on public.products;
create policy "Admins can insert products"
on public.products for insert to authenticated
with check (true);

drop policy if exists "Admins can update products" on public.products;
create policy "Admins can update products"
on public.products for update to authenticated
using (true) with check (true);

drop policy if exists "Admins can delete products" on public.products;
create policy "Admins can delete products"
on public.products for delete to authenticated
using (true);

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists products_updated_at on public.products;
create trigger products_updated_at before update on public.products
for each row execute function public.set_updated_at();

-- Optional starter products. Delete these INSERT rows if your catalog is already populated.
insert into public.products (name,color,sizes,price,old_price,stock,image_url,category)
select * from (values
  ('Футбольные бутсы 11140','Синий','42',99.00,150.00,1,'','Football'),
  ('Бутсы Phantom Luna','Светло-голубой','40',99.00,150.00,1,'','Football'),
  ('Бутсы AIR Zoom Mercurial Vapor','Желтый','41',115.00,null,1,'','Football'),
  ('Бутсы Future','Черный','41,42',90.00,null,1,'','Football')
) as v(name,color,sizes,price,old_price,stock,image_url,category)
where not exists (select 1 from public.products);

-- Create the administrator in Supabase Dashboard > Authentication > Users > Add user.
-- Use the email/password you want for the website's admin login.
