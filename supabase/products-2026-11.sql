-- =====================================================================
--  Новая поставка пептидов (ноябрь 2026) + состав и характеристики.
--  Запустите в Supabase → SQL Editor ПОСЛЕ peptides.sql и peptides-i18n.sql.
--  Файл сгенерирован; повторный запуск безопасен.
--
--  • 16 позиций из списка поставки: артикул (SKU), фасовка «мг × 10 флаконов»,
--    состав с дозировкой, характеристики. Продажа поштучно: цена и остаток —
--    за флакон (остаток = коробки × 10). У существующих товаров цена и описание не меняются
--    (кроме SS-31 — добавлена регистрация FDA 2025 г.).
--  • 8 новых товаров: Семакс, ProstaMax, PT-141, Lemon Bottle, Кисспептин-10,
--    Cartalax, Lipo-C, BAC Water. Цена 0 — на сайте «Цена по запросу»;
--    перед включением продаж впишите цены в админке.
--  • Остальным пептидам добавлены формула и молекулярная масса.
--  • Новые категории: «Липолитики» (Lemon Bottle, Lipo-C) и «Растворители» (BAC Water).
--  Тексты — на русском, английском и румынском.
-- =====================================================================

insert into public.categories (slug, name, description, sort, translations) values
(
  'lipolytics', 'Липолитики', 'Липолитические и липотропные растворы', 2,
  '{"en":{"name":"Lipolytics","description":"Lipolytic and lipotropic solutions"},"ro":{"name":"Lipolitice","description":"Soluții lipolitice și lipotrope"}}'
),
(
  'solvents', 'Растворители', 'Вода и растворители для разведения лиофилизатов', 3,
  '{"en":{"name":"Solvents","description":"Water and solvents for reconstituting lyophilized powders"},"ro":{"name":"Solvenți","description":"Apă și solvenți pentru reconstituirea liofilizatelor"}}'
)
on conflict (slug) do nothing;

-- SK-10 · selank
update public.products set
  sku = $t$SK-10$t$,
  stock = 20,
  pack = $t$Флакон · 10 мг$t$,
  unit_label = $t$за флакон$t$,
  composition = $t$[{"name":"Селанк","amount":"10 мг / флакон"}]$t$::jsonb,
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Фасовка","value":"Флакон · 10 мг"},{"label":"Последовательность","value":"Thr-Lys-Pro-Arg-Pro-Gly-Pro"},{"label":"Молекулярная формула","value":"C33H57N11O9"},{"label":"Молекулярная масса","value":"≈ 751,9 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"pack":"Vial · 10 mg","unit_label":"per vial","composition":[{"name":"Selank","amount":"10 mg / vial"}],"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Pack","value":"Vial · 10 mg"},{"label":"Sequence","value":"Thr-Lys-Pro-Arg-Pro-Gly-Pro"},{"label":"Molecular formula","value":"C33H57N11O9"},{"label":"Molecular weight","value":"≈ 751.9 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"pack":"Flacon · 10 mg","unit_label":"per flacon","composition":[{"name":"Selank","amount":"10 mg / flacon"}],"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Ambalare","value":"Flacon · 10 mg"},{"label":"Secvență","value":"Thr-Lys-Pro-Arg-Pro-Gly-Pro"},{"label":"Formulă moleculară","value":"C33H57N11O9"},{"label":"Masă moleculară","value":"≈ 751,9 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$selank$t$;

-- SX-10 · semax (новый)
insert into public.products (
  slug, name, category_id, form, purposes, pack, unit_label, short_description, description, usage, warning,
  composition, specs, sku, price, stock, is_new, is_published, sort, translations
)
select $t$semax$t$, $t$Семакс$t$, c.id, 'vials', array[$t$energy-sleep$t$], $t$Флакон · 10 мг$t$, $t$за флакон$t$,
  $t$Гептапептид — синтетический аналог фрагмента АКТГ(4–10).$t$,
  $t$Семакс — синтетический гептапептид Met-Glu-His-Phe-Pro-Gly-Pro. Это фрагмент адренокортикотропного гормона АКТГ(4–10), к которому добавлен трипептид Pro-Gly-Pro: он защищает молекулу от быстрого разрушения ферментами. Гормональной активности АКТГ у семакса нет.

Разработан в Институте молекулярной генетики РАН совместно с МГУ. В России зарегистрирован как лекарственное средство в форме назальных капель; изучался в связи с нарушениями мозгового кровообращения. За пределами России и ряда стран СНГ как лекарство не зарегистрирован.$t$,
  $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований. Не является лекарственным средством; любое применение — только по рекомендации врача.$t$,
  $t$Не является лекарственным средством. Перед применением проконсультируйтесь со специалистом.$t$,
  $t$[{"name":"Семакс","amount":"10 мг / флакон"}]$t$::jsonb,
  $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Фасовка","value":"Флакон · 10 мг"},{"label":"Последовательность","value":"Met-Glu-His-Phe-Pro-Gly-Pro"},{"label":"Молекулярная формула","value":"C37H51N9O10S"},{"label":"Молекулярная масса","value":"≈ 813,9 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  $t$SX-10$t$, 0, 10, true, true, 16,
  $t${"en":{"pack":"Vial · 10 mg","unit_label":"per vial","composition":[{"name":"Semax","amount":"10 mg / vial"}],"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Pack","value":"Vial · 10 mg"},{"label":"Sequence","value":"Met-Glu-His-Phe-Pro-Gly-Pro"},{"label":"Molecular formula","value":"C37H51N9O10S"},{"label":"Molecular weight","value":"≈ 813.9 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}],"name":"Semax","short_description":"A heptapeptide — a synthetic analogue of the ACTH(4–10) fragment.","description":"Semax is the synthetic heptapeptide Met-Glu-His-Phe-Pro-Gly-Pro. It is a fragment of adrenocorticotropic hormone, ACTH(4–10), extended with the tripeptide Pro-Gly-Pro, which protects the molecule from rapid breakdown by enzymes. Semax has no ACTH hormonal activity.\n\nIt was developed at the Institute of Molecular Genetics of the Russian Academy of Sciences together with Moscow State University. In Russia it is registered as a medicine in the form of nasal drops and has been studied in connection with cerebral circulation disorders. Outside Russia and several CIS countries it is not registered as a medicine.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research. Not a medicinal product; any use only on a doctor’s recommendation.","warning":"Not a medicinal product. Consult a specialist before use."},"ro":{"pack":"Flacon · 10 mg","unit_label":"per flacon","composition":[{"name":"Semax","amount":"10 mg / flacon"}],"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Ambalare","value":"Flacon · 10 mg"},{"label":"Secvență","value":"Met-Glu-His-Phe-Pro-Gly-Pro"},{"label":"Formulă moleculară","value":"C37H51N9O10S"},{"label":"Masă moleculară","value":"≈ 813,9 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}],"name":"Semax","short_description":"Heptapeptidă — analog sintetic al fragmentului ACTH(4–10).","description":"Semax este heptapeptida sintetică Met-Glu-His-Phe-Pro-Gly-Pro. Este un fragment al hormonului adrenocorticotrop, ACTH(4–10), la care s-a adăugat tripeptida Pro-Gly-Pro, care protejează molecula de descompunerea rapidă de către enzime. Semax nu are activitatea hormonală a ACTH.\n\nA fost dezvoltat la Institutul de Genetică Moleculară al Academiei de Științe a Rusiei împreună cu Universitatea de Stat din Moscova. În Rusia este înregistrat ca medicament sub formă de picături nazale și a fost studiat în legătură cu tulburările circulației cerebrale. În afara Rusiei și a câtorva țări CSI nu este înregistrat ca medicament.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator. Nu este medicament; orice utilizare — doar la recomandarea medicului.","warning":"Nu este medicament. Consultați un specialist înainte de utilizare."}}$t$::jsonb
from public.categories c where c.slug = $t$peptides$t$
on conflict (slug) do update set
  name = excluded.name, category_id = excluded.category_id, purposes = excluded.purposes,
  pack = excluded.pack, unit_label = excluded.unit_label,
  short_description = excluded.short_description, description = excluded.description,
  usage = excluded.usage, warning = excluded.warning,
  composition = excluded.composition, specs = excluded.specs,
  sku = excluded.sku, stock = excluded.stock, translations = excluded.translations;

-- TR-50 · tirzepatide
update public.products set
  sku = $t$TR-50$t$,
  stock = 10,
  pack = $t$Флакон · 50 мг$t$,
  unit_label = $t$за флакон$t$,
  composition = $t$[{"name":"Тирзепатид","amount":"50 мг / флакон"}]$t$::jsonb,
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Фасовка","value":"Флакон · 50 мг"},{"label":"Молекулярная формула","value":"C225H348N48O68"},{"label":"Молекулярная масса","value":"≈ 4813,5 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"pack":"Vial · 50 mg","unit_label":"per vial","composition":[{"name":"Tirzepatide","amount":"50 mg / vial"}],"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Pack","value":"Vial · 50 mg"},{"label":"Molecular formula","value":"C225H348N48O68"},{"label":"Molecular weight","value":"≈ 4813.5 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"pack":"Flacon · 50 mg","unit_label":"per flacon","composition":[{"name":"Tirzepatidă","amount":"50 mg / flacon"}],"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Ambalare","value":"Flacon · 50 mg"},{"label":"Formulă moleculară","value":"C225H348N48O68"},{"label":"Masă moleculară","value":"≈ 4813,5 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$tirzepatide$t$;

-- MAX-10 · prostamax (новый)
insert into public.products (
  slug, name, category_id, form, purposes, pack, unit_label, short_description, description, usage, warning,
  composition, specs, sku, price, stock, is_new, is_published, sort, translations
)
select $t$prostamax$t$, $t$Простамакс (ProstaMax)$t$, c.id, 'vials', array[]::text[], $t$Флакон · 10 мг$t$, $t$за флакон$t$,
  $t$Тетрапептид Lys-Glu-Asp-Pro из группы коротких пептидов-биорегуляторов.$t$,
  $t$Простамакс — синтетический тетрапептид Lys-Glu-Asp-Pro (KEDP). Относится к коротким пептидам-биорегуляторам, которые разрабатывали в Санкт-Петербургском институте биорегуляции и геронтологии (В. Х. Хавинсон). Изучается в связи с тканью предстательной железы.

Опубликованных исследований немного, в основном это работы на культурах клеток. Клинических исследований, отвечающих современным требованиям, нет; как лекарственное средство не зарегистрирован.$t$,
  $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований. Не является лекарственным средством; любое применение — только по рекомендации врача.$t$,
  $t$Не является лекарственным средством. Перед применением проконсультируйтесь со специалистом.$t$,
  $t$[{"name":"Простамакс (Lys-Glu-Asp-Pro)","amount":"10 мг / флакон"}]$t$::jsonb,
  $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Фасовка","value":"Флакон · 10 мг"},{"label":"Последовательность","value":"Lys-Glu-Asp-Pro"},{"label":"Молекулярная формула","value":"C20H33N5O9"},{"label":"Молекулярная масса","value":"≈ 487,5 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  $t$MAX-10$t$, 0, 10, true, true, 17,
  $t${"en":{"pack":"Vial · 10 mg","unit_label":"per vial","composition":[{"name":"ProstaMax (Lys-Glu-Asp-Pro)","amount":"10 mg / vial"}],"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Pack","value":"Vial · 10 mg"},{"label":"Sequence","value":"Lys-Glu-Asp-Pro"},{"label":"Molecular formula","value":"C20H33N5O9"},{"label":"Molecular weight","value":"≈ 487.5 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}],"name":"ProstaMax","short_description":"The tetrapeptide Lys-Glu-Asp-Pro from the group of short bioregulator peptides.","description":"ProstaMax is the synthetic tetrapeptide Lys-Glu-Asp-Pro (KEDP). It belongs to the short bioregulator peptides developed at the St. Petersburg Institute of Bioregulation and Gerontology (V. Kh. Khavinson). It is studied in connection with prostate tissue.\n\nThere are few published studies, mostly in cell cultures. There are no clinical trials meeting modern standards; it is not registered as a medicine.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research. Not a medicinal product; any use only on a doctor’s recommendation.","warning":"Not a medicinal product. Consult a specialist before use."},"ro":{"pack":"Flacon · 10 mg","unit_label":"per flacon","composition":[{"name":"ProstaMax (Lys-Glu-Asp-Pro)","amount":"10 mg / flacon"}],"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Ambalare","value":"Flacon · 10 mg"},{"label":"Secvență","value":"Lys-Glu-Asp-Pro"},{"label":"Formulă moleculară","value":"C20H33N5O9"},{"label":"Masă moleculară","value":"≈ 487,5 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}],"name":"ProstaMax","short_description":"Tetrapeptida Lys-Glu-Asp-Pro din grupul peptidelor bioregulatoare scurte.","description":"ProstaMax este tetrapeptida sintetică Lys-Glu-Asp-Pro (KEDP). Face parte din peptidele bioregulatoare scurte dezvoltate la Institutul de Bioreglare și Gerontologie din Sankt Petersburg (V. H. Havinson). Este studiată în legătură cu țesutul prostatei.\n\nStudiile publicate sunt puține, în principal pe culturi de celule. Nu există studii clinice conforme cerințelor moderne; nu este înregistrată ca medicament.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator. Nu este medicament; orice utilizare — doar la recomandarea medicului.","warning":"Nu este medicament. Consultați un specialist înainte de utilizare."}}$t$::jsonb
from public.categories c where c.slug = $t$peptides$t$
on conflict (slug) do update set
  name = excluded.name, category_id = excluded.category_id, purposes = excluded.purposes,
  pack = excluded.pack, unit_label = excluded.unit_label,
  short_description = excluded.short_description, description = excluded.description,
  usage = excluded.usage, warning = excluded.warning,
  composition = excluded.composition, specs = excluded.specs,
  sku = excluded.sku, stock = excluded.stock, translations = excluded.translations;

-- PT-10 · pt-141 (новый)
insert into public.products (
  slug, name, category_id, form, purposes, pack, unit_label, short_description, description, usage, warning,
  composition, specs, sku, price, stock, is_new, is_published, sort, translations
)
select $t$pt-141$t$, $t$PT-141 (бремеланотид)$t$, c.id, 'vials', array[]::text[], $t$Флакон · 10 мг$t$, $t$за флакон$t$,
  $t$Циклический пептид — агонист меланокортиновых рецепторов. Действующее вещество рецептурного препарата Vyleesi.$t$,
  $t$PT-141 (международное название — бремеланотид) — синтетический циклический пептид, аналог α-меланоцитстимулирующего гормона. Получен на основе меланотана II; активирует меланокортиновые рецепторы MC3R и MC4R в центральной нервной системе.

В 2019 году FDA (США) зарегистрировало бремеланотид под названием Vyleesi как рецептурный препарат для лечения гипоактивного расстройства сексуального желания у женщин до менопаузы. Частые нежелательные эффекты — тошнота, приливы, головная боль; препарат может временно повышать артериальное давление.$t$,
  $t$Рецептурное лекарственное вещество. Порядок применения и дозировку определяет только лечащий врач.$t$,
  $t$Рецептурное лекарственное вещество. Применяется только по назначению и под наблюдением врача.$t$,
  $t$[{"name":"Бремеланотид (PT-141)","amount":"10 мг / флакон"}]$t$::jsonb,
  $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Фасовка","value":"Флакон · 10 мг"},{"label":"Молекулярная формула","value":"C50H68N14O10"},{"label":"Молекулярная масса","value":"≈ 1025,2 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  $t$PT-10$t$, 0, 10, true, true, 18,
  $t${"en":{"pack":"Vial · 10 mg","unit_label":"per vial","composition":[{"name":"Bremelanotide (PT-141)","amount":"10 mg / vial"}],"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Pack","value":"Vial · 10 mg"},{"label":"Molecular formula","value":"C50H68N14O10"},{"label":"Molecular weight","value":"≈ 1025.2 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}],"name":"PT-141 (bremelanotide)","short_description":"A cyclic peptide — a melanocortin receptor agonist. The active substance of the prescription drug Vyleesi.","description":"PT-141 (international name: bremelanotide) is a synthetic cyclic peptide, an analogue of α-melanocyte-stimulating hormone. It was derived from melanotan II and activates the melanocortin receptors MC3R and MC4R in the central nervous system.\n\nIn 2019 the US FDA approved bremelanotide under the name Vyleesi as a prescription drug for hypoactive sexual desire disorder in premenopausal women. Common side effects are nausea, flushing and headache; the drug can temporarily raise blood pressure.","usage":"Prescription medicinal substance. Use and dosage are determined only by the attending doctor.","warning":"Prescription medicinal substance. Use only as prescribed and supervised by a doctor."},"ro":{"pack":"Flacon · 10 mg","unit_label":"per flacon","composition":[{"name":"Bremelanotidă (PT-141)","amount":"10 mg / flacon"}],"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Ambalare","value":"Flacon · 10 mg"},{"label":"Formulă moleculară","value":"C50H68N14O10"},{"label":"Masă moleculară","value":"≈ 1025,2 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}],"name":"PT-141 (bremelanotidă)","short_description":"Peptidă ciclică — agonist al receptorilor melanocortinici. Substanța activă a medicamentului cu rețetă Vyleesi.","description":"PT-141 (denumire internațională — bremelanotidă) este o peptidă ciclică sintetică, analog al hormonului α-melanocitostimulant. A fost obținută pe baza melanotanului II și activează receptorii melanocortinici MC3R și MC4R din sistemul nervos central.\n\nÎn 2019, FDA (SUA) a aprobat bremelanotida sub denumirea Vyleesi ca medicament cu rețetă pentru tulburarea de dorință sexuală hipoactivă la femeile în premenopauză. Efectele adverse frecvente sunt greața, bufeurile și durerea de cap; medicamentul poate crește temporar tensiunea arterială.","usage":"Substanță medicamentoasă eliberată pe bază de rețetă. Modul de utilizare și doza le stabilește doar medicul curant.","warning":"Substanță medicamentoasă eliberată pe bază de rețetă. Se utilizează doar la indicația și sub supravegherea medicului."}}$t$::jsonb
from public.categories c where c.slug = $t$peptides$t$
on conflict (slug) do update set
  name = excluded.name, category_id = excluded.category_id, purposes = excluded.purposes,
  pack = excluded.pack, unit_label = excluded.unit_label,
  short_description = excluded.short_description, description = excluded.description,
  usage = excluded.usage, warning = excluded.warning,
  composition = excluded.composition, specs = excluded.specs,
  sku = excluded.sku, stock = excluded.stock, translations = excluded.translations;

-- MS-30 · mots-c
update public.products set
  sku = $t$MS-30$t$,
  stock = 10,
  pack = $t$Флакон · 30 мг$t$,
  unit_label = $t$за флакон$t$,
  composition = $t$[{"name":"MOTS-c","amount":"30 мг / флакон"}]$t$::jsonb,
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Фасовка","value":"Флакон · 30 мг"},{"label":"Молекулярная формула","value":"C101H152N28O22S2"},{"label":"Молекулярная масса","value":"≈ 2174,6 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"pack":"Vial · 30 mg","unit_label":"per vial","composition":[{"name":"MOTS-c","amount":"30 mg / vial"}],"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Pack","value":"Vial · 30 mg"},{"label":"Molecular formula","value":"C101H152N28O22S2"},{"label":"Molecular weight","value":"≈ 2174.6 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"pack":"Flacon · 30 mg","unit_label":"per flacon","composition":[{"name":"MOTS-c","amount":"30 mg / flacon"}],"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Ambalare","value":"Flacon · 30 mg"},{"label":"Formulă moleculară","value":"C101H152N28O22S2"},{"label":"Masă moleculară","value":"≈ 2174,6 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$mots-c$t$;

-- 2S-50 · ss-31
update public.products set
  sku = $t$2S-50$t$,
  stock = 10,
  pack = $t$Флакон · 50 мг$t$,
  unit_label = $t$за флакон$t$,
  composition = $t$[{"name":"SS-31 (эламипретид)","amount":"50 мг / флакон"}]$t$::jsonb,
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Фасовка","value":"Флакон · 50 мг"},{"label":"Последовательность","value":"D-Arg-Dmt-Lys-Phe-NH2"},{"label":"Молекулярная формула","value":"C32H49N9O5"},{"label":"Молекулярная масса","value":"≈ 639,8 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  description = $t$SS-31 (международное название — эламипретид) — синтетический тетрапептид D-Arg-Dmt-Lys-Phe-NH2, где Dmt — 2,6-диметилтирозин.

Пептид проникает в клетки и связывается с кардиолипином — липидом внутренней мембраны митохондрий.

В сентябре 2025 года FDA (США) в ускоренном порядке зарегистрировало эламипретид под названием Forzinity для лечения синдрома Барта — редкого наследственного митохондриального заболевания. Это первый зарегистрированный препарат, действующий на митохондрии. При других заболеваниях эламипретид продолжают изучать.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"pack":"Vial · 50 mg","unit_label":"per vial","composition":[{"name":"SS-31 (elamipretide)","amount":"50 mg / vial"}],"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Pack","value":"Vial · 50 mg"},{"label":"Sequence","value":"D-Arg-Dmt-Lys-Phe-NH2"},{"label":"Molecular formula","value":"C32H49N9O5"},{"label":"Molecular weight","value":"≈ 639.8 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}],"description":"SS-31 (international name: elamipretide) is the synthetic tetrapeptide D-Arg-Dmt-Lys-Phe-NH2, where Dmt is 2,6-dimethyltyrosine.\n\nThe peptide enters cells and binds to cardiolipin, a lipid of the inner mitochondrial membrane.\n\nIn September 2025 the US FDA granted accelerated approval to elamipretide under the name Forzinity for Barth syndrome, a rare inherited mitochondrial disease. It is the first approved drug that targets mitochondria. Elamipretide is still being studied in other diseases."}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"pack":"Flacon · 50 mg","unit_label":"per flacon","composition":[{"name":"SS-31 (elamipretidă)","amount":"50 mg / flacon"}],"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Ambalare","value":"Flacon · 50 mg"},{"label":"Secvență","value":"D-Arg-Dmt-Lys-Phe-NH2"},{"label":"Formulă moleculară","value":"C32H49N9O5"},{"label":"Masă moleculară","value":"≈ 639,8 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}],"description":"SS-31 (denumire internațională — elamipretidă) este tetrapeptida sintetică D-Arg-Dmt-Lys-Phe-NH2, unde Dmt este 2,6-dimetiltirozina.\n\nPeptida pătrunde în celule și se leagă de cardiolipină, un lipid al membranei mitocondriale interne.\n\nÎn septembrie 2025, FDA (SUA) a aprobat în regim accelerat elamipretida sub denumirea Forzinity pentru sindromul Barth, o boală mitocondrială ereditară rară. Este primul medicament aprobat care acționează asupra mitocondriilor. În alte boli elamipretida continuă să fie studiată."}$t$::jsonb)
where slug = $t$ss-31$t$;

-- LB-10 · lemon-bottle (новый)
insert into public.products (
  slug, name, category_id, form, purposes, pack, unit_label, short_description, description, usage, warning,
  composition, specs, sku, price, stock, is_new, is_published, sort, translations
)
select $t$lemon-bottle$t$, $t$Lemon Bottle$t$, c.id, 'vials', array[$t$metabolism$t$], $t$Флакон · 10 мл$t$, $t$за флакон$t$,
  $t$Корейский косметический раствор с рибофлавином, бромелайном и лецитином. Флаконы по 10 мл.$t$,
  $t$Lemon Bottle — косметический раствор по формуле, разработанной в Южной Корее. Продвигается как средство для коррекции локальных жировых отложений.

По данным продавцов, основу состава составляют рибофлавин (витамин B2), бромелайн — фермент из ананаса — и лецитин. Точные концентрации производитель публично не раскрывает.

Корейский дистрибьютор оригинальной формулы (SID Medicos) заявлял, что раствор предназначен только для наружного косметического применения, а не для инъекций. Лекарственным средством не является. Швейцарский регулятор Swissmedic предупреждал о рисках инъекционного применения: воспалении, гематомах и инфекциях. Независимых исследований эффективности и безопасности нет.$t$,
  $t$Косметическое средство. Применяйте согласно инструкции производителя на упаковке.$t$,
  $t$Не является лекарственным средством. Не предназначено для инъекций. Не применяйте при беременности, кормлении грудью и аллергии на ананас (бромелайн). Перед применением проконсультируйтесь со специалистом.$t$,
  $t$[{"name":"Рибофлавин (витамин B2)","amount":"концентрация не раскрыта"},{"name":"Бромелайн","amount":"концентрация не раскрыта"},{"name":"Лецитин","amount":"концентрация не раскрыта"}]$t$::jsonb,
  $t$[{"label":"Форма выпуска","value":"Раствор во флаконе"},{"label":"Фасовка","value":"Флакон · 10 мл"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"При +15…+25 °C, в защищённом от света месте."}]$t$::jsonb,
  $t$LB-10$t$, 0, 10, true, true, 19,
  $t${"en":{"pack":"Vial · 10 ml","unit_label":"per vial","composition":[{"name":"Riboflavin (vitamin B2)","amount":"concentration not disclosed"},{"name":"Bromelain","amount":"concentration not disclosed"},{"name":"Lecithin","amount":"concentration not disclosed"}],"specs":[{"label":"Form","value":"Solution in a vial"},{"label":"Pack","value":"Vial · 10 ml"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"At +15…+25 °C, protected from light."}],"name":"Lemon Bottle","short_description":"A Korean cosmetic solution with riboflavin, bromelain and lecithin. 10 ml vials.","description":"Lemon Bottle is a cosmetic solution based on a formula developed in South Korea. It is marketed for reducing localized fat deposits.\n\nAccording to sellers, the main ingredients are riboflavin (vitamin B2), bromelain — an enzyme from pineapple — and lecithin. The manufacturer does not publicly disclose exact concentrations.\n\nThe Korean distributor of the original formula (SID Medicos) has stated that the solution is intended only for external cosmetic use and not for injection. It is not a medicinal product. The Swiss regulator Swissmedic has warned about the risks of injecting it: inflammation, bruising and infection. There are no independent studies of its efficacy and safety.","usage":"A cosmetic product. Use according to the manufacturer’s instructions on the package.","warning":"Not a medicinal product. Not intended for injection. Do not use during pregnancy, breastfeeding or if allergic to pineapple (bromelain). Consult a specialist before use."},"ro":{"pack":"Flacon · 10 ml","unit_label":"per flacon","composition":[{"name":"Riboflavină (vitamina B2)","amount":"concentrație nedezvăluită"},{"name":"Bromelaină","amount":"concentrație nedezvăluită"},{"name":"Lecitină","amount":"concentrație nedezvăluită"}],"specs":[{"label":"Formă","value":"Soluție în flacon"},{"label":"Ambalare","value":"Flacon · 10 ml"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"La +15…+25 °C, ferit de lumină."}],"name":"Lemon Bottle","short_description":"Soluție cosmetică coreeană cu riboflavină, bromelaină și lecitină. Flacoane de 10 ml.","description":"Lemon Bottle este o soluție cosmetică după o formulă dezvoltată în Coreea de Sud. Este promovată pentru reducerea depozitelor locale de grăsime.\n\nPotrivit vânzătorilor, ingredientele de bază sunt riboflavina (vitamina B2), bromelaina — o enzimă din ananas — și lecitina. Producătorul nu dezvăluie public concentrațiile exacte.\n\nDistribuitorul coreean al formulei originale (SID Medicos) a declarat că soluția este destinată doar utilizării cosmetice externe, nu injectării. Nu este medicament. Autoritatea elvețiană Swissmedic a avertizat asupra riscurilor injectării: inflamații, hematoame și infecții. Nu există studii independente privind eficacitatea și siguranța.","usage":"Produs cosmetic. Utilizați conform instrucțiunilor producătorului de pe ambalaj.","warning":"Nu este medicament. Nu este destinat injectării. Nu utilizați în sarcină, în perioada de alăptare și în caz de alergie la ananas (bromelaină). Consultați un specialist înainte de utilizare."}}$t$::jsonb
from public.categories c where c.slug = $t$lipolytics$t$
on conflict (slug) do update set
  name = excluded.name, category_id = excluded.category_id, purposes = excluded.purposes,
  pack = excluded.pack, unit_label = excluded.unit_label,
  short_description = excluded.short_description, description = excluded.description,
  usage = excluded.usage, warning = excluded.warning,
  composition = excluded.composition, specs = excluded.specs,
  sku = excluded.sku, stock = excluded.stock, translations = excluded.translations;

-- CU-100 · ghk-cu
update public.products set
  sku = $t$CU-100$t$,
  stock = 10,
  pack = $t$Флакон · 100 мг$t$,
  unit_label = $t$за флакон$t$,
  composition = $t$[{"name":"GHK-Cu (медный трипептид)","amount":"100 мг / флакон"}]$t$::jsonb,
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Фасовка","value":"Флакон · 100 мг"},{"label":"Последовательность","value":"Gly-His-Lys · Cu²⁺"},{"label":"Молекулярная формула","value":"C14H22CuN6O4"},{"label":"Молекулярная масса","value":"≈ 401,9 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"pack":"Vial · 100 mg","unit_label":"per vial","composition":[{"name":"GHK-Cu (copper tripeptide)","amount":"100 mg / vial"}],"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Pack","value":"Vial · 100 mg"},{"label":"Sequence","value":"Gly-His-Lys · Cu²⁺"},{"label":"Molecular formula","value":"C14H22CuN6O4"},{"label":"Molecular weight","value":"≈ 401.9 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"pack":"Flacon · 100 mg","unit_label":"per flacon","composition":[{"name":"GHK-Cu (tripeptidă cu cupru)","amount":"100 mg / flacon"}],"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Ambalare","value":"Flacon · 100 mg"},{"label":"Secvență","value":"Gly-His-Lys · Cu²⁺"},{"label":"Formulă moleculară","value":"C14H22CuN6O4"},{"label":"Masă moleculară","value":"≈ 401,9 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$ghk-cu$t$;

-- ET-10 · epitalon
update public.products set
  sku = $t$ET-10$t$,
  stock = 10,
  pack = $t$Флакон · 10 мг$t$,
  unit_label = $t$за флакон$t$,
  composition = $t$[{"name":"Эпиталон","amount":"10 мг / флакон"}]$t$::jsonb,
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Фасовка","value":"Флакон · 10 мг"},{"label":"Последовательность","value":"Ala-Glu-Asp-Gly"},{"label":"Молекулярная формула","value":"C14H22N4O9"},{"label":"Молекулярная масса","value":"≈ 390,3 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"pack":"Vial · 10 mg","unit_label":"per vial","composition":[{"name":"Epitalon","amount":"10 mg / vial"}],"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Pack","value":"Vial · 10 mg"},{"label":"Sequence","value":"Ala-Glu-Asp-Gly"},{"label":"Molecular formula","value":"C14H22N4O9"},{"label":"Molecular weight","value":"≈ 390.3 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"pack":"Flacon · 10 mg","unit_label":"per flacon","composition":[{"name":"Epitalon","amount":"10 mg / flacon"}],"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Ambalare","value":"Flacon · 10 mg"},{"label":"Secvență","value":"Ala-Glu-Asp-Gly"},{"label":"Formulă moleculară","value":"C14H22N4O9"},{"label":"Masă moleculară","value":"≈ 390,3 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$epitalon$t$;

-- KS-10 · kisspeptin-10 (новый)
insert into public.products (
  slug, name, category_id, form, purposes, pack, unit_label, short_description, description, usage, warning,
  composition, specs, sku, price, stock, is_new, is_published, sort, translations
)
select $t$kisspeptin-10$t$, $t$Кисспептин-10$t$, c.id, 'vials', array[]::text[], $t$Флакон · 10 мг$t$, $t$за флакон$t$,
  $t$Декапептид — активный фрагмент кисспептина, активатор рецептора KISS1R.$t$,
  $t$Кисспептин-10 — синтетический декапептид Tyr-Asn-Trp-Asn-Ser-Phe-Gly-Leu-Arg-Phe-NH2, самый короткий полностью активный фрагмент белка кисспептина (продукт гена KISS1).

Кисспептин связывается с рецептором KISS1R (GPR54) на нейронах гипоталамуса и запускает выброс гонадотропин-рилизинг-гормона, а через него — лютеинизирующего и фолликулостимулирующего гормонов. Это ключевое звено регуляции репродуктивной системы.

Изучается в клинических исследованиях, в том числе в репродуктивной медицине; как лекарственное средство не зарегистрирован.$t$,
  $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований. Не является лекарственным средством; любое применение — только по рекомендации врача.$t$,
  $t$Не является лекарственным средством. Перед применением проконсультируйтесь со специалистом.$t$,
  $t$[{"name":"Кисспептин-10","amount":"10 мг / флакон"}]$t$::jsonb,
  $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Фасовка","value":"Флакон · 10 мг"},{"label":"Последовательность","value":"Tyr-Asn-Trp-Asn-Ser-Phe-Gly-Leu-Arg-Phe-NH2"},{"label":"Молекулярная формула","value":"C63H83N17O14"},{"label":"Молекулярная масса","value":"≈ 1302,4 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  $t$KS-10$t$, 0, 10, true, true, 20,
  $t${"en":{"pack":"Vial · 10 mg","unit_label":"per vial","composition":[{"name":"Kisspeptin-10","amount":"10 mg / vial"}],"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Pack","value":"Vial · 10 mg"},{"label":"Sequence","value":"Tyr-Asn-Trp-Asn-Ser-Phe-Gly-Leu-Arg-Phe-NH2"},{"label":"Molecular formula","value":"C63H83N17O14"},{"label":"Molecular weight","value":"≈ 1302.4 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}],"name":"Kisspeptin-10","short_description":"A decapeptide — the active fragment of kisspeptin, an activator of the KISS1R receptor.","description":"Kisspeptin-10 is the synthetic decapeptide Tyr-Asn-Trp-Asn-Ser-Phe-Gly-Leu-Arg-Phe-NH2, the shortest fully active fragment of the protein kisspeptin (the product of the KISS1 gene).\n\nKisspeptin binds to the KISS1R (GPR54) receptor on hypothalamic neurons and triggers the release of gonadotropin-releasing hormone and, through it, of luteinizing and follicle-stimulating hormones. This is a key link in the regulation of the reproductive system.\n\nIt is being studied in clinical trials, including in reproductive medicine; it is not registered as a medicine.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research. Not a medicinal product; any use only on a doctor’s recommendation.","warning":"Not a medicinal product. Consult a specialist before use."},"ro":{"pack":"Flacon · 10 mg","unit_label":"per flacon","composition":[{"name":"Kisspeptină-10","amount":"10 mg / flacon"}],"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Ambalare","value":"Flacon · 10 mg"},{"label":"Secvență","value":"Tyr-Asn-Trp-Asn-Ser-Phe-Gly-Leu-Arg-Phe-NH2"},{"label":"Formulă moleculară","value":"C63H83N17O14"},{"label":"Masă moleculară","value":"≈ 1302,4 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}],"name":"Kisspeptină-10","short_description":"Decapeptidă — fragmentul activ al kisspeptinei, activator al receptorului KISS1R.","description":"Kisspeptina-10 este decapeptida sintetică Tyr-Asn-Trp-Asn-Ser-Phe-Gly-Leu-Arg-Phe-NH2, cel mai scurt fragment complet activ al proteinei kisspeptină (produsul genei KISS1).\n\nKisspeptina se leagă de receptorul KISS1R (GPR54) de pe neuronii hipotalamusului și declanșează eliberarea hormonului de eliberare a gonadotropinelor și, prin acesta, a hormonilor luteinizant și foliculostimulant. Aceasta este o verigă-cheie în reglarea sistemului reproducător.\n\nEste studiată în studii clinice, inclusiv în medicina reproductivă; nu este înregistrată ca medicament.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator. Nu este medicament; orice utilizare — doar la recomandarea medicului.","warning":"Nu este medicament. Consultați un specialist înainte de utilizare."}}$t$::jsonb
from public.categories c where c.slug = $t$peptides$t$
on conflict (slug) do update set
  name = excluded.name, category_id = excluded.category_id, purposes = excluded.purposes,
  pack = excluded.pack, unit_label = excluded.unit_label,
  short_description = excluded.short_description, description = excluded.description,
  usage = excluded.usage, warning = excluded.warning,
  composition = excluded.composition, specs = excluded.specs,
  sku = excluded.sku, stock = excluded.stock, translations = excluded.translations;

-- IP-10 · ipamorelin
update public.products set
  sku = $t$IP-10$t$,
  stock = 10,
  pack = $t$Флакон · 10 мг$t$,
  unit_label = $t$за флакон$t$,
  composition = $t$[{"name":"Ипаморелин","amount":"10 мг / флакон"}]$t$::jsonb,
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Фасовка","value":"Флакон · 10 мг"},{"label":"Последовательность","value":"Aib-His-D-2-Nal-D-Phe-Lys-NH2"},{"label":"Молекулярная формула","value":"C38H49N9O5"},{"label":"Молекулярная масса","value":"≈ 711,9 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"pack":"Vial · 10 mg","unit_label":"per vial","composition":[{"name":"Ipamorelin","amount":"10 mg / vial"}],"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Pack","value":"Vial · 10 mg"},{"label":"Sequence","value":"Aib-His-D-2-Nal-D-Phe-Lys-NH2"},{"label":"Molecular formula","value":"C38H49N9O5"},{"label":"Molecular weight","value":"≈ 711.9 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"pack":"Flacon · 10 mg","unit_label":"per flacon","composition":[{"name":"Ipamorelină","amount":"10 mg / flacon"}],"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Ambalare","value":"Flacon · 10 mg"},{"label":"Secvență","value":"Aib-His-D-2-Nal-D-Phe-Lys-NH2"},{"label":"Formulă moleculară","value":"C38H49N9O5"},{"label":"Masă moleculară","value":"≈ 711,9 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$ipamorelin$t$;

-- CT-20 · cartalax (новый)
insert into public.products (
  slug, name, category_id, form, purposes, pack, unit_label, short_description, description, usage, warning,
  composition, specs, sku, price, stock, is_new, is_published, sort, translations
)
select $t$cartalax$t$, $t$Карталакс (Cartalax)$t$, c.id, 'vials', array[$t$skin-joints$t$], $t$Флакон · 20 мг$t$, $t$за флакон$t$,
  $t$Трипептид Ala-Glu-Asp из группы коротких пептидов-биорегуляторов.$t$,
  $t$Карталакс — синтетический трипептид Ala-Glu-Asp (AED). Относится к коротким пептидам-биорегуляторам, разработанным в Санкт-Петербургском институте биорегуляции и геронтологии (В. Х. Хавинсон). Изучается в связи с хрящевой и соединительной тканью.

Данные получены в основном в исследованиях на культурах клеток и животных. Клинических исследований у людей нет; как лекарственное средство не зарегистрирован.$t$,
  $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований. Не является лекарственным средством; любое применение — только по рекомендации врача.$t$,
  $t$Не является лекарственным средством. Перед применением проконсультируйтесь со специалистом.$t$,
  $t$[{"name":"Карталакс (Ala-Glu-Asp)","amount":"20 мг / флакон"}]$t$::jsonb,
  $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Фасовка","value":"Флакон · 20 мг"},{"label":"Последовательность","value":"Ala-Glu-Asp"},{"label":"Молекулярная формула","value":"C12H19N3O8"},{"label":"Молекулярная масса","value":"≈ 333,3 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  $t$CT-20$t$, 0, 10, true, true, 21,
  $t${"en":{"pack":"Vial · 20 mg","unit_label":"per vial","composition":[{"name":"Cartalax (Ala-Glu-Asp)","amount":"20 mg / vial"}],"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Pack","value":"Vial · 20 mg"},{"label":"Sequence","value":"Ala-Glu-Asp"},{"label":"Molecular formula","value":"C12H19N3O8"},{"label":"Molecular weight","value":"≈ 333.3 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}],"name":"Cartalax","short_description":"The tripeptide Ala-Glu-Asp from the group of short bioregulator peptides.","description":"Cartalax is the synthetic tripeptide Ala-Glu-Asp (AED). It belongs to the short bioregulator peptides developed at the St. Petersburg Institute of Bioregulation and Gerontology (V. Kh. Khavinson). It is studied in connection with cartilage and connective tissue.\n\nThe data come mainly from cell culture and animal studies. There are no clinical studies in humans; it is not registered as a medicine.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research. Not a medicinal product; any use only on a doctor’s recommendation.","warning":"Not a medicinal product. Consult a specialist before use."},"ro":{"pack":"Flacon · 20 mg","unit_label":"per flacon","composition":[{"name":"Cartalax (Ala-Glu-Asp)","amount":"20 mg / flacon"}],"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Ambalare","value":"Flacon · 20 mg"},{"label":"Secvență","value":"Ala-Glu-Asp"},{"label":"Formulă moleculară","value":"C12H19N3O8"},{"label":"Masă moleculară","value":"≈ 333,3 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}],"name":"Cartalax","short_description":"Tripeptida Ala-Glu-Asp din grupul peptidelor bioregulatoare scurte.","description":"Cartalax este tripeptida sintetică Ala-Glu-Asp (AED). Face parte din peptidele bioregulatoare scurte dezvoltate la Institutul de Bioreglare și Gerontologie din Sankt Petersburg (V. H. Havinson). Este studiată în legătură cu țesutul cartilaginos și conjunctiv.\n\nDatele provin în principal din studii pe culturi de celule și pe animale. Nu există studii clinice la om; nu este înregistrată ca medicament.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator. Nu este medicament; orice utilizare — doar la recomandarea medicului.","warning":"Nu este medicament. Consultați un specialist înainte de utilizare."}}$t$::jsonb
from public.categories c where c.slug = $t$peptides$t$
on conflict (slug) do update set
  name = excluded.name, category_id = excluded.category_id, purposes = excluded.purposes,
  pack = excluded.pack, unit_label = excluded.unit_label,
  short_description = excluded.short_description, description = excluded.description,
  usage = excluded.usage, warning = excluded.warning,
  composition = excluded.composition, specs = excluded.specs,
  sku = excluded.sku, stock = excluded.stock, translations = excluded.translations;

-- LC-526 · lipo-c (новый)
insert into public.products (
  slug, name, category_id, form, purposes, pack, unit_label, short_description, description, usage, warning,
  composition, specs, sku, price, stock, is_new, is_published, sort, translations
)
select $t$lipo-c$t$, $t$Lipo-C Fat Blaster (LC-526)$t$, c.id, 'vials', array[$t$metabolism$t$], $t$Флакон · 526 мг/мл$t$, $t$за флакон$t$,
  $t$Раствор липотропных веществ: L-карнитин, метионин, инозитол, холин, витамины B6 и B12, NADH — всего 526 мг в 1 мл.$t$,
  $t$Lipo-C — комбинированный раствор так называемых липотропных веществ, которые участвуют в обмене жиров. Число 526 в названии — суммарное содержание компонентов в 1 мл.

L-карнитин переносит жирные кислоты в митохондрии, где они окисляются. Метионин, инозитол и холин (эту комбинацию часто называют MIC) участвуют в обмене жиров в печени. Витамины B6 и B12, а также NADH — коферменты энергетического обмена.

Подобные смеси изготавливают аптеки и лаборатории, единого стандарта состава нет. Клинических доказательств того, что такие инъекции снижают вес, недостаточно.$t$,
  $t$Готовый раствор во флаконе. Продаётся для научных и лабораторных исследований. Не является лекарственным средством; любое применение — только по назначению врача.$t$,
  $t$Не является лекарственным средством. Не применяйте при беременности, кормлении грудью, заболеваниях печени и почек без назначения врача.$t$,
  $t$[{"name":"L-карнитин","amount":"300 мг / мл"},{"name":"Инозитол","amount":"50 мг / мл"},{"name":"Холин","amount":"50 мг / мл"},{"name":"Витамин B6 (пиридоксин)","amount":"50 мг / мл"},{"name":"NADH","amount":"50 мг / мл"},{"name":"L-метионин","amount":"25 мг / мл"},{"name":"Витамин B12 (цианокобаламин)","amount":"1 мг / мл"}]$t$::jsonb,
  $t$[{"label":"Форма выпуска","value":"Раствор во флаконе"},{"label":"Фасовка","value":"Флакон · 526 мг/мл"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"При +2…+8 °C, в защищённом от света месте. Не замораживать."}]$t$::jsonb,
  $t$LC-526$t$, 0, 10, true, true, 22,
  $t${"en":{"pack":"Vial · 526 mg/ml","unit_label":"per vial","composition":[{"name":"L-carnitine","amount":"300 mg / ml"},{"name":"Inositol","amount":"50 mg / ml"},{"name":"Choline","amount":"50 mg / ml"},{"name":"Vitamin B6 (pyridoxine)","amount":"50 mg / ml"},{"name":"NADH","amount":"50 mg / ml"},{"name":"L-methionine","amount":"25 mg / ml"},{"name":"Vitamin B12 (cyanocobalamin)","amount":"1 mg / ml"}],"specs":[{"label":"Form","value":"Solution in a vial"},{"label":"Pack","value":"Vial · 526 mg/ml"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"At +2…+8 °C, protected from light. Do not freeze."}],"name":"Lipo-C Fat Blaster (LC-526)","short_description":"A solution of lipotropic substances: L-carnitine, methionine, inositol, choline, vitamins B6 and B12, NADH — 526 mg per 1 ml in total.","description":"Lipo-C is a combined solution of so-called lipotropic substances involved in fat metabolism. The number 526 in the name is the total content of the components per 1 ml.\n\nL-carnitine transports fatty acids into mitochondria, where they are oxidized. Methionine, inositol and choline (a combination often called MIC) are involved in fat metabolism in the liver. Vitamins B6 and B12 and NADH are coenzymes of energy metabolism.\n\nSuch blends are made by compounding pharmacies and laboratories; there is no single standard composition. Clinical evidence that such injections reduce weight is insufficient.","usage":"Ready-made solution in a vial. Sold for scientific and laboratory research. Not a medicinal product; any use only as prescribed by a doctor.","warning":"Not a medicinal product. Do not use during pregnancy, breastfeeding or with liver or kidney disease without a doctor’s prescription."},"ro":{"pack":"Flacon · 526 mg/ml","unit_label":"per flacon","composition":[{"name":"L-carnitină","amount":"300 mg / ml"},{"name":"Inozitol","amount":"50 mg / ml"},{"name":"Colină","amount":"50 mg / ml"},{"name":"Vitamina B6 (piridoxină)","amount":"50 mg / ml"},{"name":"NADH","amount":"50 mg / ml"},{"name":"L-metionină","amount":"25 mg / ml"},{"name":"Vitamina B12 (cianocobalamină)","amount":"1 mg / ml"}],"specs":[{"label":"Formă","value":"Soluție în flacon"},{"label":"Ambalare","value":"Flacon · 526 mg/ml"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"La +2…+8 °C, ferit de lumină. A nu se congela."}],"name":"Lipo-C Fat Blaster (LC-526)","short_description":"Soluție de substanțe lipotrope: L-carnitină, metionină, inozitol, colină, vitaminele B6 și B12, NADH — în total 526 mg la 1 ml.","description":"Lipo-C este o soluție combinată de așa-numite substanțe lipotrope, implicate în metabolismul grăsimilor. Numărul 526 din denumire este conținutul total al componentelor la 1 ml.\n\nL-carnitina transportă acizii grași în mitocondrii, unde sunt oxidați. Metionina, inozitolul și colina (combinație numită adesea MIC) participă la metabolismul grăsimilor în ficat. Vitaminele B6 și B12, precum și NADH, sunt coenzime ale metabolismului energetic.\n\nAstfel de amestecuri sunt preparate de farmacii și laboratoare; nu există o compoziție standard unică. Dovezile clinice că astfel de injecții reduc greutatea sunt insuficiente.","usage":"Soluție gata preparată în flacon. Se comercializează pentru cercetări științifice și de laborator. Nu este medicament; orice utilizare — doar la indicația medicului.","warning":"Nu este medicament. Nu utilizați în sarcină, în perioada de alăptare sau în boli hepatice și renale fără prescripția medicului."}}$t$::jsonb
from public.categories c where c.slug = $t$lipolytics$t$
on conflict (slug) do update set
  name = excluded.name, category_id = excluded.category_id, purposes = excluded.purposes,
  pack = excluded.pack, unit_label = excluded.unit_label,
  short_description = excluded.short_description, description = excluded.description,
  usage = excluded.usage, warning = excluded.warning,
  composition = excluded.composition, specs = excluded.specs,
  sku = excluded.sku, stock = excluded.stock, translations = excluded.translations;

-- BBG-70 · glow
update public.products set
  sku = $t$BBG-70$t$,
  stock = 10,
  pack = $t$Флакон · 70 мг$t$,
  unit_label = $t$за флакон$t$,
  composition = $t$[{"name":"GHK-Cu (медный трипептид)","amount":"50 мг / флакон"},{"name":"BPC-157","amount":"10 мг / флакон"},{"name":"TB-500 (фрагмент тимозина β4)","amount":"10 мг / флакон"}]$t$::jsonb,
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Фасовка","value":"Флакон · 70 мг"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"pack":"Vial · 70 mg","unit_label":"per vial","composition":[{"name":"GHK-Cu (copper tripeptide)","amount":"50 mg / vial"},{"name":"BPC-157","amount":"10 mg / vial"},{"name":"TB-500 (thymosin β4 fragment)","amount":"10 mg / vial"}],"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Pack","value":"Vial · 70 mg"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"pack":"Flacon · 70 mg","unit_label":"per flacon","composition":[{"name":"GHK-Cu (tripeptidă cu cupru)","amount":"50 mg / flacon"},{"name":"BPC-157","amount":"10 mg / flacon"},{"name":"TB-500 (fragment de timozină β4)","amount":"10 mg / flacon"}],"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Ambalare","value":"Flacon · 70 mg"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$glow$t$;

-- BA-3 · bac-water (новый)
insert into public.products (
  slug, name, category_id, form, purposes, pack, unit_label, short_description, description, usage, warning,
  composition, specs, sku, price, stock, is_new, is_published, sort, translations
)
select $t$bac-water$t$, $t$Бактериостатическая вода (BAC Water)$t$, c.id, 'vials', array[]::text[], $t$Флакон · 3 мл$t$, $t$за флакон$t$,
  $t$Стерильная вода с 0,9 % бензилового спирта для разведения лиофилизатов. Флаконы по 3 мл.$t$,
  $t$Бактериостатическая вода — стерильная вода для инъекций с добавлением 0,9 % бензилового спирта. Бензиловый спирт подавляет размножение большинства бактерий, поэтому пробку флакона можно прокалывать несколько раз.

Применяется для разведения (восстановления) лиофилизированных пептидов. В отличие от обычной стерильной воды, вскрытый флакон пригоден к использованию до 28 дней.$t$,
  $t$Перед разведением протрите пробку флакона спиртовой салфеткой. Наберите нужный объём стерильным шприцем и медленно введите во флакон с лиофилизатом по стенке, не встряхивая. Вскрытый флакон используйте в течение 28 дней.$t$,
  $t$Только для разведения лиофилизатов. Не применяйте у новорождённых: бензиловый спирт для них токсичен. Не используйте, если раствор мутный или флакон повреждён.$t$,
  $t$[{"name":"Вода для инъекций","amount":"3 мл / флакон"},{"name":"Бензиловый спирт","amount":"0,9 % (9 мг / мл)"}]$t$::jsonb,
  $t$[{"label":"Форма выпуска","value":"Раствор во флаконе"},{"label":"Фасовка","value":"Флакон · 3 мл"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"При +20…+25 °C. Вскрытый флакон — не более 28 дней."}]$t$::jsonb,
  $t$BA-3$t$, 0, 30, true, true, 23,
  $t${"en":{"pack":"Vial · 3 ml","unit_label":"per vial","composition":[{"name":"Water for injection","amount":"3 ml / vial"},{"name":"Benzyl alcohol","amount":"0.9% (9 mg / ml)"}],"specs":[{"label":"Form","value":"Solution in a vial"},{"label":"Pack","value":"Vial · 3 ml"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"At +20…+25 °C. Opened vial — no more than 28 days."}],"name":"Bacteriostatic Water (BAC Water)","short_description":"Sterile water with 0.9% benzyl alcohol for reconstituting lyophilized powders. 3 ml vials.","description":"Bacteriostatic water is sterile water for injection with 0.9% benzyl alcohol added. Benzyl alcohol suppresses the growth of most bacteria, so the vial stopper can be punctured several times.\n\nIt is used to reconstitute lyophilized peptides. Unlike plain sterile water, an opened vial can be used for up to 28 days.","usage":"Before reconstitution, wipe the vial stopper with an alcohol swab. Draw the required volume with a sterile syringe and inject it slowly into the vial with the lyophilized powder along the wall, without shaking. Use an opened vial within 28 days.","warning":"For reconstituting lyophilized powders only. Do not use in newborns: benzyl alcohol is toxic to them. Do not use if the solution is cloudy or the vial is damaged."},"ro":{"pack":"Flacon · 3 ml","unit_label":"per flacon","composition":[{"name":"Apă pentru preparate injectabile","amount":"3 ml / flacon"},{"name":"Alcool benzilic","amount":"0,9 % (9 mg / ml)"}],"specs":[{"label":"Formă","value":"Soluție în flacon"},{"label":"Ambalare","value":"Flacon · 3 ml"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"La +20…+25 °C. Flaconul deschis — cel mult 28 de zile."}],"name":"Apă bacteriostatică (BAC Water)","short_description":"Apă sterilă cu 0,9 % alcool benzilic pentru reconstituirea liofilizatelor. Flacoane de 3 ml.","description":"Apa bacteriostatică este apă sterilă pentru preparate injectabile cu adaos de 0,9 % alcool benzilic. Alcoolul benzilic împiedică înmulțirea majorității bacteriilor, de aceea dopul flaconului poate fi perforat de mai multe ori.\n\nSe folosește pentru reconstituirea peptidelor liofilizate. Spre deosebire de apa sterilă obișnuită, un flacon deschis poate fi utilizat până la 28 de zile.","usage":"Înainte de reconstituire, ștergeți dopul flaconului cu un tampon cu alcool. Extrageți volumul necesar cu o seringă sterilă și introduceți-l lent în flaconul cu liofilizat, pe perete, fără a agita. Utilizați flaconul deschis în 28 de zile.","warning":"Doar pentru reconstituirea liofilizatelor. Nu utilizați la nou-născuți: alcoolul benzilic este toxic pentru ei. Nu utilizați dacă soluția este tulbure sau flaconul este deteriorat."}}$t$::jsonb
from public.categories c where c.slug = $t$solvents$t$
on conflict (slug) do update set
  name = excluded.name, category_id = excluded.category_id, purposes = excluded.purposes,
  pack = excluded.pack, unit_label = excluded.unit_label,
  short_description = excluded.short_description, description = excluded.description,
  usage = excluded.usage, warning = excluded.warning,
  composition = excluded.composition, specs = excluded.specs,
  sku = excluded.sku, stock = excluded.stock, translations = excluded.translations;

-- Остальные пептиды: формула и молекулярная масса (дозировки нет в списке поставки)
update public.products set
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Молекулярная формула","value":"C221H342N46O68"},{"label":"Молекулярная масса","value":"≈ 4731,3 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Molecular formula","value":"C221H342N46O68"},{"label":"Molecular weight","value":"≈ 4731.3 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Formulă moleculară","value":"C221H342N46O68"},{"label":"Masă moleculară","value":"≈ 4731,3 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$retatrutide$t$;

update public.products set
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Молекулярная формула","value":"C194H312N54O59S2"},{"label":"Молекулярная масса","value":"≈ 4409 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Molecular formula","value":"C194H312N54O59S2"},{"label":"Molecular weight","value":"≈ 4409 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Formulă moleculară","value":"C194H312N54O59S2"},{"label":"Masă moleculară","value":"≈ 4409 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$cagrilintide$t$;

update public.products set
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Молекулярная формула","value":"C10H11N2⁺"},{"label":"Молекулярная масса","value":"≈ 159,2 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Molecular formula","value":"C10H11N2⁺"},{"label":"Molecular weight","value":"≈ 159.2 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Formulă moleculară","value":"C10H11N2⁺"},{"label":"Masă moleculară","value":"≈ 159,2 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$5-amino-1mq$t$;

update public.products set
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Молекулярная формула","value":"C129H215N33O55"},{"label":"Молекулярная масса","value":"≈ 3108,3 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Molecular formula","value":"C129H215N33O55"},{"label":"Molecular weight","value":"≈ 3108.3 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Formulă moleculară","value":"C129H215N33O55"},{"label":"Masă moleculară","value":"≈ 3108,3 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$thymosin-alpha-1$t$;

update public.products set
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Молекулярная формула","value":"C21H27N7O14P2"},{"label":"Молекулярная масса","value":"≈ 663,4 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Molecular formula","value":"C21H27N7O14P2"},{"label":"Molecular weight","value":"≈ 663.4 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Formulă moleculară","value":"C21H27N7O14P2"},{"label":"Masă moleculară","value":"≈ 663,4 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$nad-plus$t$;

update public.products set
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Последовательность","value":"Cys-Tyr-Ile-Gln-Asn-Cys-Pro-Leu-Gly-NH2"},{"label":"Молекулярная формула","value":"C43H66N12O12S2"},{"label":"Молекулярная масса","value":"≈ 1007,2 г/моль"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Sequence","value":"Cys-Tyr-Ile-Gln-Asn-Cys-Pro-Leu-Gly-NH2"},{"label":"Molecular formula","value":"C43H66N12O12S2"},{"label":"Molecular weight","value":"≈ 1007.2 g/mol"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Secvență","value":"Cys-Tyr-Ile-Gln-Asn-Cys-Pro-Leu-Gly-NH2"},{"label":"Formulă moleculară","value":"C43H66N12O12S2"},{"label":"Masă moleculară","value":"≈ 1007,2 g/mol"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$oxytocin$t$;

update public.products set
  specs = $t$[{"label":"Форма выпуска","value":"Лиофилизат во флаконе"},{"label":"Последовательность","value":"BPC-157: Gly-Glu-Pro-Pro-Pro-Gly-Lys-Pro-Ala-Asp-Asp-Ala-Gly-Leu-Val"},{"label":"Производитель","value":"SP Laboratory (Великобритания)"},{"label":"Хранение","value":"Сухой порошок — при −20 °C или +2…+8 °C, в защищённом от света месте. Готовый раствор — при +2…+8 °C."}]$t$::jsonb,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"specs":[{"label":"Form","value":"Lyophilized powder in a vial"},{"label":"Sequence","value":"BPC-157: Gly-Glu-Pro-Pro-Pro-Gly-Lys-Pro-Ala-Asp-Asp-Ala-Gly-Leu-Val"},{"label":"Manufacturer","value":"SP Laboratory (United Kingdom)"},{"label":"Storage","value":"Dry powder — at −20 °C or +2…+8 °C, protected from light. Reconstituted solution — at +2…+8 °C."}]}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"specs":[{"label":"Formă","value":"Liofilizat în flacon"},{"label":"Secvență","value":"BPC-157: Gly-Glu-Pro-Pro-Pro-Gly-Lys-Pro-Ala-Asp-Asp-Ala-Gly-Leu-Val"},{"label":"Producător","value":"SP Laboratory (Marea Britanie)"},{"label":"Păstrare","value":"Pulberea uscată — la −20 °C sau +2…+8 °C, ferită de lumină. Soluția preparată — la +2…+8 °C."}]}$t$::jsonb)
where slug = $t$bpc-157-tb-500$t$;

-- Проверка: 16 позиций поставки с артикулами
select sku, name, pack, stock, price from public.products where sku is not null order by sort;