-- =====================================================================
--  Защита базы (ноябрь 2026).
--  Запустите один раз в Supabase → SQL Editor. Повторный запуск безопасен.
--
--  1. Старая функция «запрос цены» (request_products) больше не нужна —
--     удаляем, чтобы через неё нельзя было засыпать «Заявки» в обход сайта.
--  2. Ограничение частоты заявок на консультацию и заказов — прямо в базе,
--     поэтому работает и при обращении к Supabase в обход сайта:
--       • с одного номера — не больше 3 за 10 минут;
--       • всего — не больше 30 за 10 минут.
--     Администратора ограничения не касаются.
--  3. Хранилище файлов: только PDF, JPG, PNG, WebP, GIF и не больше 15 МБ —
--     даже если кто-то обойдёт проверки сайта (SVG и HTML со скриптами не пройдут).
-- =====================================================================

-- 1 ———————————————————————————————————————————————————————————————
drop function if exists public.request_products(jsonb, jsonb);
drop function if exists public.request_product(uuid, jsonb);

-- 2 ———————————————————————————————————————————————————————————————
create or replace function public.throttle_inserts()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_digits text := regexp_replace(coalesce(new.phone, ''), '\D', '', 'g');
  v_same   int;
  v_total  int;
begin
  if public.is_admin() then
    return new;
  end if;

  if tg_table_name = 'orders' then
    select count(*) filter (where regexp_replace(phone, '\D', '', 'g') = v_digits), count(*)
      into v_same, v_total
      from public.orders
     where created_at > now() - interval '10 minutes';
  else
    select count(*) filter (where regexp_replace(phone, '\D', '', 'g') = v_digits), count(*)
      into v_same, v_total
      from public.service_requests
     where created_at > now() - interval '10 minutes';
  end if;

  -- Текст начинается со «Слишком много» — сайт показывает по нему понятное сообщение
  if v_same >= 3 then
    raise exception 'Слишком много запросов с этого номера, попробуйте позже';
  end if;
  if v_total >= 30 then
    raise exception 'Слишком много запросов, попробуйте позже';
  end if;

  return new;
end;
$$;

revoke all on function public.throttle_inserts() from public;

drop trigger if exists service_requests_throttle on public.service_requests;
create trigger service_requests_throttle before insert on public.service_requests
  for each row execute function public.throttle_inserts();

drop trigger if exists orders_throttle on public.orders;
create trigger orders_throttle before insert on public.orders
  for each row execute function public.throttle_inserts();

-- 3 ———————————————————————————————————————————————————————————————
update storage.buckets
   set file_size_limit = 15728640,  -- 15 МБ
       allowed_mime_types = array['application/pdf', 'image/png', 'image/jpeg', 'image/webp', 'image/gif']
 where id = 'media';

-- Проверка
select
  (select count(*) from pg_proc where proname in ('request_products', 'request_product')) as old_functions_left,  -- 0
  (select count(*) from pg_trigger where tgname in ('service_requests_throttle', 'orders_throttle')) as throttles,  -- 2
  (select file_size_limit from storage.buckets where id = 'media') as file_limit;                                -- 15728640
