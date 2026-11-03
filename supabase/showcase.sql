-- =====================================================================
--  Режим витрины: каталог без цен, корзины и оформления заказа.
--
--  После запуска сайт сразу переходит в режим витрины. Вернуть продажи —
--  Админка → Настройки → «Продажи на сайте».
--
--  Пока продажи выключены, база сама не примет заказ (даже в обход сайта),
--  а на странице товара вместо кнопки «В корзину» — форма «Сообщить о старте
--  продаж». Такие заявки попадают в Админку → «Заявки».
--
--  Запустите один раз в Supabase → SQL Editor ПОСЛЕ schema.sql и services.sql.
--  Повторный запуск безопасен: выбранный в админке режим не сбрасывается.
-- =====================================================================

alter table public.settings add column if not exists sales_enabled boolean not null default false;

-- ---------------------------------------------------------------------
--  Заказ не создаётся, пока продажи выключены
-- ---------------------------------------------------------------------

create or replace function public.check_sales_enabled()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not coalesce((select sales_enabled from public.settings where id = 1), false) then
    raise exception 'Продажи на сайте пока не открыты';
  end if;
  return new;
end;
$$;

drop trigger if exists orders_sales_enabled on public.orders;
create trigger orders_sales_enabled before insert on public.orders
  for each row execute function public.check_sales_enabled();

-- ---------------------------------------------------------------------
--  Заявка «Сообщить о старте продаж» со страницы товара.
--  Название товара берётся из базы, цена не сохраняется.
-- ---------------------------------------------------------------------

create or replace function public.request_product(p_product uuid, p_request jsonb)
returns bigint
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_product record;
  v_number  bigint;
  v_method  text := coalesce(p_request ->> 'contact_method', '');
begin
  if coalesce(trim(p_request ->> 'customer_name'), '') = '' then
    raise exception 'Укажите имя';
  end if;
  if length(regexp_replace(coalesce(p_request ->> 'phone', ''), '\D', '', 'g')) < 8 then
    raise exception 'Укажите телефон';
  end if;

  select id, name into v_product from public.products where id = p_product and is_published;

  if not found then
    raise exception 'Товар недоступен';
  end if;

  insert into public.service_requests (
    service_name, customer_name, phone, contact_method, comment
  ) values (
    'Старт продаж: ' || v_product.name,
    left(trim(p_request ->> 'customer_name'), 120),
    left(trim(p_request ->> 'phone'), 40),
    case when v_method in ('phone', 'telegram', 'viber', 'whatsapp') then v_method else 'phone' end,
    nullif(left(trim(coalesce(p_request ->> 'comment', '')), 2000), '')
  )
  returning number into v_number;

  return v_number;
end;
$$;

revoke all on function public.request_product(uuid, jsonb) from public;
grant execute on function public.request_product(uuid, jsonb) to anon, authenticated;

-- Проверка: false — сайт в режиме витрины
select sales_enabled from public.settings where id = 1;
