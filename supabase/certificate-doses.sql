-- =====================================================================
--  Сертификат ↔ дозировки товара.
--  variant_ids — к каким дозировкам (product_variants.id) относится документ.
--  Пусто — документ для всех дозировок товара (и для товаров без дозировок).
--  Один сертификат может относиться сразу к нескольким дозировкам.
--
--  Запустите один раз в Supabase → SQL Editor. Повторный запуск безопасен.
-- =====================================================================

alter table public.certificates add column if not exists variant_ids uuid[] not null default '{}';

-- Проверка: поле есть
select count(*) as certificates, count(*) filter (where cardinality(variant_ids) > 0) as with_doses
  from public.certificates;
