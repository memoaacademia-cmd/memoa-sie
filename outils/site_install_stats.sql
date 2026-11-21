-- Memoa : chiffres d'installation (écran d'accueil) pour le tableau de bord admin.
-- À exécuter UNE fois dans Supabase > SQL Editor. Ne modifie ni site_stats ni la table site_events.
-- Hypothèse : site_events a une colonne de date nommée created_at (valeur par défaut now()).
-- Si elle s'appelle autrement, remplace created_at ci-dessous.

create or replace function public.site_install_stats(days int default 30)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  d int := greatest(1, least(coalesce(days, 30), 365));
  since timestamptz := now() - make_interval(days => d);
  res jsonb;
begin
  -- Même contrôle d'accès que le tableau de bord actuel : si site_stats refuse, celle-ci refuse aussi.
  perform public.site_stats(1);

  with inst as (               -- une ligne par app installée (identifiant propre à chaque installation)
    select visitor,
           min(created_at) as first_seen,
           max(created_at) as last_seen,
           (array_agg(props->>'platform' order by created_at))[1] as platform
    from site_events
    where name = 'app_standalone' and visitor is not null
    group by visitor
  ),
  ret as (                     -- visiteurs venus sur 2 jours différents ou plus
    select visitor
    from site_events
    where name = 'page_view' and visitor is not null and created_at >= since
    group by visitor
    having count(distinct (created_at at time zone 'Africa/Kinshasa')::date) >= 2
  ),
  hrs as (
    select extract(hour from created_at at time zone 'Africa/Kinshasa')::int as h, count(*) as n
    from site_events
    where name = 'page_view' and created_at >= since
    group by 1 order by 2 desc, 1 limit 6
  )
  select jsonb_build_object(
    'total_installed', (select count(*) from inst),
    'by_platform', coalesce((select jsonb_agg(jsonb_build_object('label', coalesce(platform,'autre'), 'n', n) order by n desc)
                             from (select platform, count(*) n from inst group by platform) x), '[]'::jsonb),
    'new_in_period', (select count(*) from inst where first_seen >= since),
    'active_7d', (select count(*) from inst where last_seen >= now() - interval '7 days'),
    'launches_period', (select count(*) from site_events where name = 'app_standalone' and created_at >= since),
    'returning_visitors', (select count(*) from ret),
    'peak_hours', coalesce((select jsonb_agg(jsonb_build_object('label', h::text, 'n', n) order by n desc, h) from hrs), '[]'::jsonb),
    'days', d,
    'generated_at', now()
  ) into res;

  return res;
end;
$$;

revoke all on function public.site_install_stats(int) from public, anon;
grant execute on function public.site_install_stats(int) to authenticated;
