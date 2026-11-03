-- =====================================================================
--  Режим витрины: «Цена по запросу» вместо цен, запрос вместо заказа.
--
--  После запуска сайт сразу переходит в режим витрины. Вернуть продажи —
--  Админка → Настройки → «Продажи на сайте».
--
--  Пока продажи выключены, база сама не примет заказ (даже в обход сайта).
--  Вместо корзины — список «Запрос цены»: покупатель выбирает товары и
--  отправляет запрос, продавец перезванивает. Запросы — в Админке → «Заявки».
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
--  Запрос цены: покупатель собирает список товаров и отправляет его,
--  продавец перезванивает. Названия товаров берутся из базы, цены не сохраняются.
-- ---------------------------------------------------------------------

alter table public.service_requests add column if not exists items jsonb;   -- [{ name, variant, qty }]

-- Прежняя версия: заявка на один товар
drop function if exists public.request_product(uuid, jsonb);

create or replace function public.request_products(p_items jsonb, p_request jsonb)
returns bigint
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_item    jsonb;
  v_product record;
  v_variant text;
  v_lines   jsonb := '[]'::jsonb;
  v_number  bigint;
  v_method  text := coalesce(p_request ->> 'contact_method', '');
begin
  if coalesce(trim(p_request ->> 'customer_name'), '') = '' then
    raise exception 'Укажите имя';
  end if;
  if length(regexp_replace(coalesce(p_request ->> 'phone', ''), '\D', '', 'g')) < 8 then
    raise exception 'Укажите телефон';
  end if;
  if jsonb_typeof(p_items) <> 'array'
     or jsonb_array_length(p_items) = 0
     or jsonb_array_length(p_items) > 50 then
    raise exception 'Список пуст';
  end if;

  for v_item in select value from jsonb_array_elements(p_items) loop
    select id, name into v_product
      from public.products
     where id = (v_item ->> 'product_id')::uuid and is_published;

    if not found then
      raise exception 'Один из товаров больше недоступен';
    end if;

    v_variant := null;
    if coalesce(v_item ->> 'variant_id', '') <> '' then
      select label into v_variant
        from public.product_variants
       where id = (v_item ->> 'variant_id')::uuid and product_id = v_product.id;
    end if;

    v_lines := v_lines || jsonb_build_object(
      'name', v_product.name,
      'variant', v_variant,
      'qty', greatest(1, least(99, coalesce((v_item ->> 'qty')::int, 1)))
    );
  end loop;

  insert into public.service_requests (
    service_name, items, customer_name, phone, contact_method, comment
  ) values (
    'Запрос цены',
    v_lines,
    left(trim(p_request ->> 'customer_name'), 120),
    left(trim(p_request ->> 'phone'), 40),
    case when v_method in ('phone', 'telegram', 'viber', 'whatsapp') then v_method else 'phone' end,
    nullif(left(trim(coalesce(p_request ->> 'comment', '')), 2000), '')
  )
  returning number into v_number;

  return v_number;
end;
$$;

revoke all on function public.request_products(jsonb, jsonb) from public;
grant execute on function public.request_products(jsonb, jsonb) to anon, authenticated;

-- Проверка: false — сайт в режиме витрины
select sales_enabled from public.settings where id = 1;
