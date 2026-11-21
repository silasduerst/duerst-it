-- DÜRST IT – Tabelle für Bewertungen
-- In Supabase: SQL Editor > New query > alles einfügen > Run

create table public.reviews (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  name        text not null check (char_length(name) between 2 and 40),
  ort         text check (ort is null or char_length(ort) <= 40),
  rating      smallint not null check (rating between 1 and 5),
  text        text not null check (char_length(text) between 10 and 800),
  approved    boolean not null default false
);

alter table public.reviews enable row level security;

-- Besucher dürfen nur freigegebene Bewertungen lesen
create policy "Freigegebene Bewertungen lesen"
  on public.reviews for select
  to anon
  using (approved = true);

-- Besucher dürfen neue Bewertungen erstellen – aber nie selbst freigeben
create policy "Bewertung einreichen"
  on public.reviews for insert
  to anon
  with check (approved = false);

-- Nur diese Spalten dürfen beim Einreichen gesetzt werden
revoke insert on public.reviews from anon;
grant insert (name, ort, rating, text) on public.reviews to anon;
grant select (name, ort, rating, text, created_at, approved) on public.reviews to anon;
