-- =====================================================================
--  «Хранение» у лиофилизатов: «В сухом виде — … В жидком виде — …»
--  вместо «Сухой порошок — … Готовый раствор — …» (на трёх языках).
--  Жидкости (Lemon Bottle, Lipo-C, BAC Water) не меняются — у них свой текст.
--
--  Запустите в Supabase → SQL Editor. Повторный запуск безопасен.
-- =====================================================================

update public.products set
  specs = replace(replace(specs::text,
    'Сухой порошок — ', 'В сухом виде — '),
    'Готовый раствор — ', 'В жидком виде — ')::jsonb,
  translations = replace(replace(replace(replace(translations::text,
    'Dry powder — ', 'Dry form — '),
    'Reconstituted solution — ', 'Liquid form — '),
    'Pulberea uscată — ', 'În formă uscată — '),
    'Soluția preparată — ', 'În formă lichidă — ')::jsonb
where specs::text like '%Сухой порошок — %'
   or translations::text like '%Dry powder — %'
   or translations::text like '%Pulberea uscată — %';

-- Проверка: старого текста не осталось (должно быть 0)
select count(*) as left_old
  from public.products
 where specs::text || translations::text ~ 'Сухой порошок|Готовый раствор|Dry powder|Reconstituted solution|Pulberea uscată|Soluția preparată';
