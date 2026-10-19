-- Parliamo: privé voortgang per ingelogde gebruiker
create table if not exists public.parliamo_progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  progress jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.parliamo_progress enable row level security;
revoke all on public.parliamo_progress from anon;
grant select, insert, update on public.parliamo_progress to authenticated;
drop policy if exists "Users can read own progress" on public.parliamo_progress;
create policy "Users can read own progress" on public.parliamo_progress for select to authenticated using ((select auth.uid()) = user_id);
drop policy if exists "Users can insert own progress" on public.parliamo_progress;
create policy "Users can insert own progress" on public.parliamo_progress for insert to authenticated with check ((select auth.uid()) = user_id);
drop policy if exists "Users can update own progress" on public.parliamo_progress;
create policy "Users can update own progress" on public.parliamo_progress for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
