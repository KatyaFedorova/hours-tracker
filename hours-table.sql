-- Projects + hours for the simple time tracker.
-- Requires Supabase Auth. Each user only sees and edits their own rows.

-- 1) Projects you create
create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade default auth.uid(),
  name text not null,
  created_at timestamptz default now()
);
alter table public.projects add column if not exists
  user_id uuid references auth.users(id) on delete cascade default auth.uid();
alter table public.projects alter column user_id set default auth.uid();

-- 2) Hours table (created earlier). Link each hours row to a project.
create table if not exists public.hours (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade default auth.uid(),
  project text,
  hours numeric not null,
  created_at timestamptz default now()
);
alter table public.hours add column if not exists
  user_id uuid references auth.users(id) on delete cascade default auth.uid();
alter table public.hours alter column user_id set default auth.uid();
alter table public.hours add column if not exists
  project_id uuid references public.projects(id) on delete cascade;
alter table public.hours alter column project drop not null;

-- Existing rows from the no-login version will have user_id = null.
-- To keep them, set their user_id to your auth.users.id after creating your account.

-- 3) Account-scoped access on both tables
alter table public.projects enable row level security;
alter table public.hours    enable row level security;

drop policy if exists "open read"   on public.projects;
drop policy if exists "open insert" on public.projects;
drop policy if exists "open delete" on public.projects;
drop policy if exists "own projects read"   on public.projects;
drop policy if exists "own projects insert" on public.projects;
drop policy if exists "own projects delete" on public.projects;
create policy "own projects read"   on public.projects for select using (user_id = auth.uid());
create policy "own projects insert" on public.projects for insert with check (user_id = auth.uid());
create policy "own projects delete" on public.projects for delete using (user_id = auth.uid());

drop policy if exists "open read"   on public.hours;
drop policy if exists "open insert" on public.hours;
drop policy if exists "open delete" on public.hours;
drop policy if exists "own hours read"   on public.hours;
drop policy if exists "own hours insert" on public.hours;
drop policy if exists "own hours delete" on public.hours;
create policy "own hours read"   on public.hours for select using (user_id = auth.uid());
create policy "own hours insert" on public.hours for insert with check (
  user_id = auth.uid()
  and exists (
    select 1 from public.projects
    where projects.id = project_id
      and projects.user_id = auth.uid()
  )
);
create policy "own hours delete" on public.hours for delete using (user_id = auth.uid());
