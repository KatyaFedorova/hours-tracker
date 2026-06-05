-- Projects + hours for the simple time tracker (no login — open access).

-- 1) Projects you create
create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz default now()
);

-- 2) Hours table (created earlier). Link each hours row to a project.
create table if not exists public.hours (
  id uuid primary key default gen_random_uuid(),
  project text,
  hours numeric not null,
  created_at timestamptz default now()
);
alter table public.hours add column if not exists
  project_id uuid references public.projects(id) on delete cascade;

-- 3) Open (no-login) access on both tables
alter table public.projects enable row level security;
alter table public.hours    enable row level security;

drop policy if exists "open read"   on public.projects;
drop policy if exists "open insert" on public.projects;
drop policy if exists "open delete" on public.projects;
create policy "open read"   on public.projects for select using (true);
create policy "open insert" on public.projects for insert with check (true);
create policy "open delete" on public.projects for delete using (true);

drop policy if exists "open read"   on public.hours;
drop policy if exists "open insert" on public.hours;
drop policy if exists "open delete" on public.hours;
create policy "open read"   on public.hours for select using (true);
create policy "open insert" on public.hours for insert with check (true);
create policy "open delete" on public.hours for delete using (true);
