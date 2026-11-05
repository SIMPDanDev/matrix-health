-- =====================================================================
--  Убираем из «Применения» текст «…Продаётся для научных и лабораторных
--  исследований» — на всех языках. Блок «Применение» у этих товаров исчезнет.
--  BAC Water (инструкция по разведению) и Lemon Bottle не меняются.
--
--  Запустите в Supabase → SQL Editor. Повторный запуск безопасен.
-- =====================================================================

update public.products set
  usage = null,
  translations = translations #- '{en,usage}' #- '{ro,usage}'
where usage ilike '%научных и лабораторных исследований%'
   or translations -> 'en' ->> 'usage' ilike '%scientific and laboratory research%'
   or translations -> 'ro' ->> 'usage' ilike '%cercetări științifice și de laborator%';

-- Проверка: должно быть 0
select count(*) as left_old
  from public.products
 where concat_ws(' ', usage, translations::text) ~* 'научных и лабораторных|scientific and laboratory|științifice și de laborator';
