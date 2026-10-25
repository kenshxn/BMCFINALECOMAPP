-- SariSari store schema. Run in Supabase SQL Editor before deploying the functions.
create extension if not exists pgcrypto;
create table if not exists public.products (
  id text primary key, name text not null, category text not null, price numeric(10,2) not null check (price >= 0),
  image_url text not null, description text not null default '', is_popular boolean not null default false,
  created_at timestamptz not null default now()
);
create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
  product_name text not null, amount numeric(10,2) not null check (amount >= 0),
  external_id text not null unique, invoice_id text, status text not null default 'PENDING',
  created_at timestamptz not null default now()
);
alter table public.products enable row level security;
alter table public.orders enable row level security;
drop policy if exists "Anyone can read products" on public.products;
create policy "Anyone can read products" on public.products for select to anon, authenticated using (true);
drop policy if exists "Users can read own orders" on public.orders;
create policy "Users can read own orders" on public.orders for select to authenticated using (auth.uid() = user_id);
grant select on public.products to anon, authenticated;
grant select on public.orders to authenticated;
insert into public.products(id,name,category,price,image_url,description,is_popular) values
('1','Lucky Me! Pancit Canton','Pantry',17,'https://luckyme.ph/img/products/webp/2023_0418_LuckyMe_Kalamansi_80g_Mockup_1stPass.webp','Calamansi instant noodles',true),
('2','Coca-Cola 1.5 L','Drinks',89,'https://images.unsplash.com/photo-1554866585-cd94860890b7?auto=format&fit=crop&w=900&q=85','Share-size sparkling cola',false),
('3','Piattos Cheese','Snacks',20,'https://images.unsplash.com/photo-1566478989037-eec170784d0b?auto=format&fit=crop&w=900&q=85','Crunchy cheese potato crisps',true),
('4','Fresh eggs (per piece)','Pantry',10,'https://images.unsplash.com/photo-1506976785307-8732e854ad03?auto=format&fit=crop&w=900&q=85','Farm fresh brown egg',false),
('5','White rice (1 kg)','Pantry',58,'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=900&q=85','Everyday premium rice',false),
('6','Gardenia Classic White','Pantry',75,'https://ever.ph/cdn/shop/files/9000000119-Gardenia-White-Bread-Classic-Loaf-400g-240129.jpg?v=1707871690','Soft sliced white bread',false),
('7','Fresh milk 1 L','Drinks',99,'https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=900&q=85','Chilled creamy fresh milk',false),
('8','Mango juice 1 L','Drinks',78,'https://images.unsplash.com/photo-1600271886742-f049cd451bba?auto=format&fit=crop&w=900&q=85','Tropical mango fruit drink',false),
('9','Banana chips','Snacks',35,'https://images.unsplash.com/photo-1603833665858-e61d17a86224?auto=format&fit=crop&w=900&q=85','Crispy sweet banana chips',false),
('10','Potato chips','Snacks',25,'https://images.unsplash.com/photo-1566478989037-eec170784d0b?auto=format&fit=crop&w=900&q=85','Classic salted crunchy chips',false),
('11','Instant coffee sachet','Drinks',12,'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?auto=format&fit=crop&w=900&q=85','Rich instant coffee, single serve',false),
('12','Bottled water 1 L','Drinks',25,'https://images.unsplash.com/photo-1523362628745-0c100150b504?auto=format&fit=crop&w=900&q=85','Refreshing purified drinking water',false),
('13','Canned sardines','Pantry',28,'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=900&q=85','Tomato sauce sardines',false),
('14','Corned beef can','Pantry',48,'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=900&q=85','Savory beef, ready to eat',false),
('15','Bath soap bar','Personal care',35,'https://images.unsplash.com/photo-1600857544200-b2f666a9a2ec?auto=format&fit=crop&w=900&q=85','Gentle everyday cleansing bar',false),
('16','Shampoo sachet','Personal care',8,'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?auto=format&fit=crop&w=900&q=85','Fresh clean single-use sachet',false),
('17','Toothpaste','Personal care',42,'https://images.unsplash.com/photo-1609840114035-3c981b782dfe?auto=format&fit=crop&w=900&q=85','Family size mint toothpaste',false),
('18','Laundry detergent sachet','Home',12,'https://images.unsplash.com/photo-1585421514284-efb74c2b69ba?auto=format&fit=crop&w=900&q=85','Powerful fresh laundry clean',false),
('19','Dishwashing liquid','Home',45,'https://images.unsplash.com/photo-1600857544200-b2f666a9a2ec?auto=format&fit=crop&w=900&q=85','Citrus clean dish soap',false),
('20','White sugar (500 g)','Pantry',38,'https://images.unsplash.com/photo-1581441363689-1f3c3c414635?auto=format&fit=crop&w=900&q=85','Fine granulated white sugar',false)
on conflict (id) do update set name=excluded.name,category=excluded.category,price=excluded.price,image_url=excluded.image_url,description=excluded.description,is_popular=excluded.is_popular;

