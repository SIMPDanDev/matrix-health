-- =====================================================================
--  Убираем из текстов товаров оговорки: «не является лекарственным средством»,
--  «проконсультируйтесь со специалистом / с врачом», «только по назначению врача»,
--  «данные получены на клетках и животных», пометки WADA и т.п.
--  Факты о регистрации (Zepbound, Zadaxin, Vyleesi…) и конкретные предупреждения
--  по безопасности (BAC Water, Lemon Bottle, Lipo-C) остаются.
--  Пустые поля становятся null — на сайте такой блок просто не показывается.
--
--  Запустите в Supabase → SQL Editor. Повторный запуск безопасен.
--  ВАЖНО: старые peptides.sql, peptides-i18n.sql, products-2026-11.sql и
--  descriptions-2026-11.sql заново не запускайте — они вернут прежние тексты.
--  Файл сгенерирован по текущим текстам из базы.
-- =====================================================================

-- omega-3
update public.products set
  warning = null
where slug = $t$omega-3$t$;

-- alergo-stop
update public.products set
  warning = null
where slug = $t$alergo-stop$t$;

-- glow
update public.products set
  description = $t$GLOW — смесь трёх пептидов в одном флаконе: 50 мг GHK-Cu, 10 мг BPC-157 и 10 мг TB-500, всего 70 мг.

GHK-Cu — природный трипептид глицил-гистидил-лизин в комплексе с ионом меди. Содержится в плазме крови человека; известен по исследованиям в области восстановления кожи.

BPC-157 — синтетический пептид из 15 аминокислот, фрагмент белка желудочного сока. TB-500 — синтетический фрагмент белка тимозина бета-4.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"GLOW is a blend of three peptides in one vial: 50 mg GHK-Cu, 10 mg BPC-157 and 10 mg TB-500, 70 mg in total.\n\nGHK-Cu is the naturally occurring tripeptide glycyl-histidyl-lysine bound to a copper ion. It is found in human blood plasma and is known from research on skin repair.\n\nBPC-157 is a synthetic 15-amino-acid peptide, a fragment of a protein from gastric juice. TB-500 is a synthetic fragment of the protein thymosin beta-4.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"GLOW este un amestec de trei peptide într-un singur flacon: 50 mg GHK-Cu, 10 mg BPC-157 și 10 mg TB-500, în total 70 mg.\n\nGHK-Cu este tripeptida naturală glicil-histidil-lizină legată de un ion de cupru. Se găsește în plasma sângelui uman și este cunoscută din cercetările privind refacerea pielii.\n\nBPC-157 este o peptidă sintetică din 15 aminoacizi, un fragment al unei proteine din sucul gastric. TB-500 este un fragment sintetic al proteinei timozină beta-4.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$glow$t$;

-- ss-31
update public.products set
  description = $t$SS-31 (международное название — эламипретид) — синтетический тетрапептид D-Arg-Dmt-Lys-Phe-NH2, где Dmt — 2,6-диметилтирозин.

Пептид проникает в клетки и связывается с кардиолипином — липидом внутренней мембраны митохондрий.

В сентябре 2025 года FDA (США) в ускоренном порядке зарегистрировало эламипретид под названием Forzinity для лечения синдрома Барта — редкого наследственного митохондриального заболевания. Это первый зарегистрированный препарат, действующий на митохондрии. При других заболеваниях эламипретид продолжают изучать.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$ss-31$t$;

-- bpc-157-tb-500
update public.products set
  description = $t$BPC-157 (Body Protection Compound) — синтетический пептид из 15 аминокислот (Gly-Glu-Pro-Pro-Pro-Gly-Lys-Pro-Ala-Asp-Asp-Ala-Gly-Leu-Val), фрагмент белка, выделенного из желудочного сока.

TB-500 — синтетический фрагмент тимозина бета-4, белка, участвующего в перестройке цитоскелета клеток.

Оба пептида изучаются в связи с восстановлением тканей.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"BPC-157 (Body Protection Compound) is a synthetic 15-amino-acid peptide (Gly-Glu-Pro-Pro-Pro-Gly-Lys-Pro-Ala-Asp-Asp-Ala-Gly-Leu-Val), a fragment of a protein isolated from gastric juice.\n\nTB-500 is a synthetic fragment of thymosin beta-4, a protein involved in reorganizing the cell cytoskeleton.\n\nBoth peptides are being studied in connection with tissue repair.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"BPC-157 (Body Protection Compound) este o peptidă sintetică din 15 aminoacizi (Gly-Glu-Pro-Pro-Pro-Gly-Lys-Pro-Ala-Asp-Asp-Ala-Gly-Leu-Val), un fragment al unei proteine izolate din sucul gastric.\n\nTB-500 este un fragment sintetic al timozinei beta-4, o proteină implicată în reorganizarea citoscheletului celular.\n\nAmbele peptide sunt studiate în legătură cu refacerea țesuturilor.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$bpc-157-tb-500$t$;

-- ipamorelin
update public.products set
  description = $t$Ипаморелин — синтетический пентапептид Aib-His-D-2-Nal-D-Phe-Lys-NH2.

Связывается с рецептором грелина (GHSR-1a) в гипофизе и стимулирует выброс гормона роста. В исследованиях отличался избирательностью: слабо влиял на уровень кортизола и АКТГ.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"Ipamorelin is the synthetic pentapeptide Aib-His-D-2-Nal-D-Phe-Lys-NH2.\n\nIt binds to the ghrelin receptor (GHSR-1a) in the pituitary gland and stimulates the release of growth hormone. In studies it was notably selective: it had little effect on cortisol and ACTH levels.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"Ipamorelina este pentapeptida sintetică Aib-His-D-2-Nal-D-Phe-Lys-NH2.\n\nSe leagă de receptorul grelinei (GHSR-1a) din hipofiză și stimulează eliberarea hormonului de creștere. În studii s-a remarcat prin selectivitate: a influențat slab nivelul de cortizol și ACTH.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$ipamorelin$t$;

-- 5-amino-1mq
update public.products set
  description = $t$5-Amino-1MQ (5-амино-1-метилхинолиний) — небольшая молекула, а не пептид.

Подавляет фермент никотинамид-N-метилтрансферазу (NNMT), который активен в жировой ткани.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"5-Amino-1MQ (5-amino-1-methylquinolinium) is a small molecule, not a peptide.\n\nIt inhibits the enzyme nicotinamide N-methyltransferase (NNMT), which is active in adipose tissue.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"5-Amino-1MQ (5-amino-1-metilchinoliniu) este o moleculă mică, nu o peptidă.\n\nInhibă enzima nicotinamid-N-metiltransferaza (NNMT), activă în țesutul adipos.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$5-amino-1mq$t$;

-- thymosin-alpha-1
update public.products set
  description = $t$Тимозин альфа-1 — пептид из 28 аминокислот, впервые выделенный из тимуса (вилочковой железы). Участвует в созревании и активации Т-лимфоцитов.

Его синтетическая форма — тималфазин (торговое название Zadaxin) — зарегистрирована более чем в 30 странах, в том числе в Китае и Италии, как иммуномодулирующее лекарство, в основном для лечения хронического гепатита B.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"Thymosin alpha-1 is a 28-amino-acid peptide first isolated from the thymus gland. It is involved in the maturation and activation of T lymphocytes.\n\nIts synthetic form, thymalfasin (brand name Zadaxin), is registered in more than 30 countries, including China and Italy, as an immunomodulating medicine, mainly for chronic hepatitis B.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"Timozina alfa-1 este o peptidă din 28 de aminoacizi, izolată pentru prima dată din timus. Participă la maturarea și activarea limfocitelor T.\n\nForma sa sintetică, timalfasina (denumire comercială Zadaxin), este înregistrată în peste 30 de țări, inclusiv China și Italia, ca medicament imunomodulator, în principal pentru hepatita B cronică.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$thymosin-alpha-1$t$;

-- retatrutide
update public.products set
  description = $t$Ретатрутид — синтетический пептид компании Eli Lilly, который одновременно активирует три рецептора: GIP, GLP-1 и глюкагона.

В 2026 году завершены четыре исследования III фазы TRIUMPH при ожирении. В основном из них (TRIUMPH-1) участники на максимальной дозе за 80 недель потеряли в среднем около 28 % массы тела. Eli Lilly планирует подать заявку на регистрацию в FDA в I квартале 2027 года.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"Retatrutide is a synthetic peptide by Eli Lilly that activates three receptors at once: GIP, GLP-1 and glucagon.\n\nIn 2026 four phase III TRIUMPH trials in obesity were completed. In the main one (TRIUMPH-1), participants on the highest dose lost on average about 28% of body weight over 80 weeks. Eli Lilly plans to submit it to the FDA in the first quarter of 2027.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"Retatrutida este o peptidă sintetică a companiei Eli Lilly care activează simultan trei receptori: GIP, GLP-1 și glucagonul.\n\nÎn 2026 au fost finalizate patru studii de fază III TRIUMPH în obezitate. În cel principal (TRIUMPH-1), participanții cu doza maximă au pierdut în medie aproximativ 28 % din greutatea corporală în 80 de săptămâni. Eli Lilly intenționează să depună cererea de înregistrare la FDA în primul trimestru al anului 2027.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$retatrutide$t$;

-- tirzepatide
update public.products set
  description = $t$Тирзепатид — синтетический пептид компании Eli Lilly из 39 аминокислот, который активирует рецепторы двух гормонов кишечника: GIP и GLP-1. Вводится подкожно раз в неделю.

Зарегистрирован как рецептурное лекарство: Mounjaro — для лечения сахарного диабета 2 типа, Zepbound — для лечения ожирения. В декабре 2024 года FDA (США) одобрило Zepbound также для лечения обструктивного апноэ сна средней и тяжёлой степени у взрослых с ожирением.$t$,
  usage = null,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"Tirzepatide is a 39-amino-acid synthetic peptide by Eli Lilly that activates the receptors of two gut hormones: GIP and GLP-1. It is injected under the skin once a week.\n\nIt is registered as a prescription medicine: Mounjaro for type 2 diabetes and Zepbound for obesity. In December 2024 the US FDA also approved Zepbound for moderate-to-severe obstructive sleep apnea in adults with obesity.","usage":"","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"Tirzepatida este o peptidă sintetică din 39 de aminoacizi a companiei Eli Lilly, care activează receptorii a doi hormoni intestinali: GIP și GLP-1. Se administrează subcutanat o dată pe săptămână.\n\nEste înregistrată ca medicament eliberat pe bază de rețetă: Mounjaro — pentru diabetul zaharat de tip 2, Zepbound — pentru obezitate. În decembrie 2024, FDA (SUA) a aprobat Zepbound și pentru apneea obstructivă în somn moderată și severă la adulții cu obezitate.","usage":"","warning":""}$t$::jsonb)
where slug = $t$tirzepatide$t$;

-- cagrilintide
update public.products set
  description = $t$Кагрилинтид — синтетический аналог гормона амилина длительного действия, разработанный компанией Novo Nordisk. Амилин вырабатывается в поджелудочной железе вместе с инсулином и участвует в регуляции чувства насыщения.

Изучается при ожирении отдельно и в комбинации с семаглутидом (CagriSema). В декабре 2025 года Novo Nordisk подала заявку на регистрацию CagriSema в FDA.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"Cagrilintide is a long-acting synthetic analogue of the hormone amylin developed by Novo Nordisk. Amylin is produced in the pancreas together with insulin and helps regulate satiety.\n\nIt is being studied for obesity, alone and in combination with semaglutide (CagriSema). In December 2025 Novo Nordisk submitted CagriSema to the FDA for approval.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"Cagrilintida este un analog sintetic cu acțiune prelungită al hormonului amilină, dezvoltat de compania Novo Nordisk. Amilina este produsă în pancreas împreună cu insulina și participă la reglarea senzației de sațietate.\n\nEste studiată în obezitate, separat și în combinație cu semaglutida (CagriSema). În decembrie 2025, Novo Nordisk a depus la FDA cererea de înregistrare a CagriSema.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$cagrilintide$t$;

-- mots-c
update public.products set
  description = $t$MOTS-c — пептид из 16 аминокислот (Met-Arg-Trp-Gln-Glu-Met-Gly-Tyr-Ile-Phe-Tyr-Pro-Arg-Lys-Leu-Arg), закодированный в митохондриальной ДНК. Описан в 2015 году.

Активирует фермент AMPK и изучается в связи с регуляцией обмена веществ и чувствительностью к инсулину.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"MOTS-c is a 16-amino-acid peptide (Met-Arg-Trp-Gln-Glu-Met-Gly-Tyr-Ile-Phe-Tyr-Pro-Arg-Lys-Leu-Arg) encoded in mitochondrial DNA. It was described in 2015.\n\nIt activates the enzyme AMPK and is being studied in connection with the regulation of metabolism and insulin sensitivity.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"MOTS-c este o peptidă din 16 aminoacizi (Met-Arg-Trp-Gln-Glu-Met-Gly-Tyr-Ile-Phe-Tyr-Pro-Arg-Lys-Leu-Arg), codificată în ADN-ul mitocondrial. A fost descrisă în 2015.\n\nActivează enzima AMPK și este studiată în legătură cu reglarea metabolismului și sensibilitatea la insulină.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$mots-c$t$;

-- nad-plus
update public.products set
  description = $t$NAD+ (никотинамидадениндинуклеотид) — кофермент, который есть во всех живых клетках. Участвует в окислительно-восстановительных реакциях энергетического обмена и служит субстратом для ферментов сиртуинов и PARP.

По данным исследований, уровень NAD+ в тканях снижается с возрастом.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"NAD+ (nicotinamide adenine dinucleotide) is a coenzyme present in all living cells. It takes part in the redox reactions of energy metabolism and serves as a substrate for sirtuin and PARP enzymes.\n\nAccording to studies, NAD+ levels in tissues decline with age.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"NAD+ (nicotinamid adenin dinucleotid) este o coenzimă prezentă în toate celulele vii. Participă la reacțiile de oxido-reducere ale metabolismului energetic și servește drept substrat pentru enzimele sirtuine și PARP.\n\nConform studiilor, nivelul NAD+ în țesuturi scade odată cu vârsta.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$nad-plus$t$;

-- oxytocin
update public.products set
  description = $t$Окситоцин — нонапептид Cys-Tyr-Ile-Gln-Asn-Cys-Pro-Leu-Gly-NH2 с дисульфидной связью между остатками цистеина. Вырабатывается в гипоталамусе и выделяется задней долей гипофиза.

В медицине применяется как рецептурный препарат, в основном в акушерстве.$t$,
  usage = null,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"Oxytocin is the nonapeptide Cys-Tyr-Ile-Gln-Asn-Cys-Pro-Leu-Gly-NH2 with a disulfide bond between the cysteine residues. It is produced in the hypothalamus and released by the posterior pituitary gland.\n\nIn medicine it is used as a prescription drug, mainly in obstetrics.","usage":"","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"Oxitocina este nonapeptida Cys-Tyr-Ile-Gln-Asn-Cys-Pro-Leu-Gly-NH2, cu o legătură disulfidică între resturile de cisteină. Este produsă în hipotalamus și eliberată de lobul posterior al hipofizei.\n\nÎn medicină se folosește ca medicament cu prescripție, în principal în obstetrică.","usage":"","warning":""}$t$::jsonb)
where slug = $t$oxytocin$t$;

-- selank
update public.products set
  description = $t$Селанк — синтетический гептапептид Thr-Lys-Pro-Arg-Pro-Gly-Pro. Создан на основе природного пептида тафтсина, к которому добавлен фрагмент Pro-Gly-Pro для большей стабильности.

Разработан в Институте молекулярной генетики РАН. В России зарегистрирован как лекарственное средство в форме назальных капель.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"Selank is the synthetic heptapeptide Thr-Lys-Pro-Arg-Pro-Gly-Pro. It is based on the natural peptide tuftsin, extended with a Pro-Gly-Pro fragment for greater stability.\n\nIt was developed at the Institute of Molecular Genetics of the Russian Academy of Sciences. In Russia it is registered as a medicine in the form of nasal drops.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"Selank este heptapeptida sintetică Thr-Lys-Pro-Arg-Pro-Gly-Pro. Are la bază peptida naturală tuftsină, la care s-a adăugat fragmentul Pro-Gly-Pro pentru o stabilitate mai mare.\n\nA fost dezvoltat la Institutul de Genetică Moleculară al Academiei de Științe a Rusiei. În Rusia este înregistrat ca medicament sub formă de picături nazale.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$selank$t$;

-- epitalon
update public.products set
  description = $t$Эпиталон — синтетический тетрапептид Ala-Glu-Asp-Gly. Создан в Санкт-Петербургском институте биорегуляции и геронтологии (В. Х. Хавинсон) на основе эпиталамина — экстракта шишковидной железы (эпифиза).

Изучается в связи с процессами старения.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"Epitalon is the synthetic tetrapeptide Ala-Glu-Asp-Gly. It was created at the Saint Petersburg Institute of Bioregulation and Gerontology (V. Khavinson) on the basis of epithalamin, an extract of the pineal gland.\n\nIt is being studied in connection with ageing.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"Epitalonul este tetrapeptida sintetică Ala-Glu-Asp-Gly. A fost creat la Institutul de Bioreglare și Gerontologie din Sankt Petersburg (V. Havinson) pe baza epitalaminei — un extract din glanda pineală (epifiză).\n\nEste studiat în legătură cu procesele de îmbătrânire.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$epitalon$t$;

-- ghk-cu
update public.products set
  description = $t$GHK-Cu — трипептид Gly-His-Lys, связанный с ионом меди (Cu2+). Содержится в плазме крови, слюне и моче человека; описан в 1973 году.

Широко изучается в косметологии и дерматологии в связи с восстановлением кожи; используется в составе косметических средств.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"GHK-Cu is the tripeptide Gly-His-Lys bound to a copper ion (Cu2+). It is found in human blood plasma, saliva and urine and was described in 1973.\n\nIt is widely studied in cosmetology and dermatology in connection with skin repair and is used in cosmetic products.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"GHK-Cu este tripeptida Gly-His-Lys legată de un ion de cupru (Cu2+). Se găsește în plasma sângelui, salivă și urina umană și a fost descrisă în 1973.\n\nEste studiată pe larg în cosmetologie și dermatologie în legătură cu refacerea pielii și se folosește în produse cosmetice.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$ghk-cu$t$;

-- semax
update public.products set
  description = $t$Семакс — синтетический гептапептид Met-Glu-His-Phe-Pro-Gly-Pro. Это фрагмент адренокортикотропного гормона АКТГ(4–10), к которому добавлен трипептид Pro-Gly-Pro: он защищает молекулу от быстрого разрушения ферментами. Гормональной активности АКТГ у семакса нет.

Разработан в Институте молекулярной генетики РАН совместно с МГУ. В России зарегистрирован как лекарственное средство в форме назальных капель; изучался в связи с нарушениями мозгового кровообращения.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"Semax is the synthetic heptapeptide Met-Glu-His-Phe-Pro-Gly-Pro. It is a fragment of adrenocorticotropic hormone, ACTH(4–10), extended with the tripeptide Pro-Gly-Pro, which protects the molecule from rapid breakdown by enzymes. Semax has no ACTH hormonal activity.\n\nIt was developed at the Institute of Molecular Genetics of the Russian Academy of Sciences together with Moscow State University. In Russia it is registered as a medicine in the form of nasal drops and has been studied in connection with cerebral circulation disorders.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"Semax este heptapeptida sintetică Met-Glu-His-Phe-Pro-Gly-Pro. Este un fragment al hormonului adrenocorticotrop, ACTH(4–10), la care s-a adăugat tripeptida Pro-Gly-Pro, care protejează molecula de descompunerea rapidă de către enzime. Semax nu are activitatea hormonală a ACTH.\n\nA fost dezvoltat la Institutul de Genetică Moleculară al Academiei de Științe a Rusiei împreună cu Universitatea de Stat din Moscova. În Rusia este înregistrat ca medicament sub formă de picături nazale și a fost studiat în legătură cu tulburările circulației cerebrale.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$semax$t$;

-- prostamax
update public.products set
  description = $t$Простамакс — синтетический тетрапептид Lys-Glu-Asp-Pro (KEDP). Относится к коротким пептидам-биорегуляторам, которые разрабатывали в Санкт-Петербургском институте биорегуляции и геронтологии (В. Х. Хавинсон). Изучается в связи с тканью предстательной железы.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"ProstaMax is the synthetic tetrapeptide Lys-Glu-Asp-Pro (KEDP). It belongs to the short bioregulator peptides developed at the St. Petersburg Institute of Bioregulation and Gerontology (V. Kh. Khavinson). It is studied in connection with prostate tissue.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"ProstaMax este tetrapeptida sintetică Lys-Glu-Asp-Pro (KEDP). Face parte din peptidele bioregulatoare scurte dezvoltate la Institutul de Bioreglare și Gerontologie din Sankt Petersburg (V. H. Havinson). Este studiată în legătură cu țesutul prostatei.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$prostamax$t$;

-- pt-141
update public.products set
  description = $t$PT-141 (международное название — бремеланотид) — синтетический циклический пептид, аналог α-меланоцитстимулирующего гормона. Получен на основе меланотана II; активирует меланокортиновые рецепторы MC3R и MC4R в центральной нервной системе.

В 2019 году FDA (США) зарегистрировало бремеланотид под названием Vyleesi как рецептурный препарат для лечения гипоактивного расстройства сексуального желания у женщин до менопаузы. Частые нежелательные эффекты — тошнота, приливы, головная боль; препарат может временно повышать артериальное давление.$t$,
  usage = null,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"usage":"","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"usage":"","warning":""}$t$::jsonb)
where slug = $t$pt-141$t$;

-- lemon-bottle
update public.products set
  description = $t$Lemon Bottle — косметический раствор по формуле, разработанной в Южной Корее. Продвигается как средство для коррекции локальных жировых отложений.

По данным продавцов, основу состава составляют рибофлавин (витамин B2), бромелайн — фермент из ананаса — и лецитин. Точные концентрации производитель публично не раскрывает.

Корейский дистрибьютор оригинальной формулы (SID Medicos) заявлял, что раствор предназначен только для наружного косметического применения, а не для инъекций.$t$,
  warning = $t$Не предназначено для инъекций. Не применяйте при беременности, кормлении грудью и аллергии на ананас (бромелайн).$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"Lemon Bottle is a cosmetic solution based on a formula developed in South Korea. It is marketed for reducing localized fat deposits.\n\nAccording to sellers, the main ingredients are riboflavin (vitamin B2), bromelain — an enzyme from pineapple — and lecithin. The manufacturer does not publicly disclose exact concentrations.\n\nThe Korean distributor of the original formula (SID Medicos) has stated that the solution is intended only for external cosmetic use and not for injection.","warning":"Not intended for injection. Do not use during pregnancy, breastfeeding or if allergic to pineapple (bromelain)."}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"Lemon Bottle este o soluție cosmetică după o formulă dezvoltată în Coreea de Sud. Este promovată pentru reducerea depozitelor locale de grăsime.\n\nPotrivit vânzătorilor, ingredientele de bază sunt riboflavina (vitamina B2), bromelaina — o enzimă din ananas — și lecitina. Producătorul nu dezvăluie public concentrațiile exacte.\n\nDistribuitorul coreean al formulei originale (SID Medicos) a declarat că soluția este destinată doar utilizării cosmetice externe, nu injectării.","warning":"Nu este destinat injectării. Nu utilizați în sarcină, în perioada de alăptare și în caz de alergie la ananas (bromelaină)."}$t$::jsonb)
where slug = $t$lemon-bottle$t$;

-- kisspeptin-10
update public.products set
  description = $t$Кисспептин-10 — синтетический декапептид Tyr-Asn-Trp-Asn-Ser-Phe-Gly-Leu-Arg-Phe-NH2, самый короткий полностью активный фрагмент белка кисспептина (продукт гена KISS1).

Кисспептин связывается с рецептором KISS1R (GPR54) на нейронах гипоталамуса и запускает выброс гонадотропин-рилизинг-гормона, а через него — лютеинизирующего и фолликулостимулирующего гормонов. Это ключевое звено регуляции репродуктивной системы.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"Kisspeptin-10 is the synthetic decapeptide Tyr-Asn-Trp-Asn-Ser-Phe-Gly-Leu-Arg-Phe-NH2, the shortest fully active fragment of the protein kisspeptin (the product of the KISS1 gene).\n\nKisspeptin binds to the KISS1R (GPR54) receptor on hypothalamic neurons and triggers the release of gonadotropin-releasing hormone and, through it, of luteinizing and follicle-stimulating hormones. This is a key link in the regulation of the reproductive system.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"Kisspeptina-10 este decapeptida sintetică Tyr-Asn-Trp-Asn-Ser-Phe-Gly-Leu-Arg-Phe-NH2, cel mai scurt fragment complet activ al proteinei kisspeptină (produsul genei KISS1).\n\nKisspeptina se leagă de receptorul KISS1R (GPR54) de pe neuronii hipotalamusului și declanșează eliberarea hormonului de eliberare a gonadotropinelor și, prin acesta, a hormonilor luteinizant și foliculostimulant. Aceasta este o verigă-cheie în reglarea sistemului reproducător.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$kisspeptin-10$t$;

-- cartalax
update public.products set
  description = $t$Карталакс — синтетический трипептид Ala-Glu-Asp (AED). Относится к коротким пептидам-биорегуляторам, разработанным в Санкт-Петербургском институте биорегуляции и геронтологии (В. Х. Хавинсон). Изучается в связи с хрящевой и соединительной тканью.$t$,
  usage = $t$Лиофилизат для приготовления раствора. Продаётся для научных и лабораторных исследований.$t$,
  warning = null,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"Cartalax is the synthetic tripeptide Ala-Glu-Asp (AED). It belongs to the short bioregulator peptides developed at the St. Petersburg Institute of Bioregulation and Gerontology (V. Kh. Khavinson). It is studied in connection with cartilage and connective tissue.","usage":"Lyophilized powder for preparing a solution. Sold for scientific and laboratory research.","warning":""}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"Cartalax este tripeptida sintetică Ala-Glu-Asp (AED). Face parte din peptidele bioregulatoare scurte dezvoltate la Institutul de Bioreglare și Gerontologie din Sankt Petersburg (V. H. Havinson). Este studiată în legătură cu țesutul cartilaginos și conjunctiv.","usage":"Liofilizat pentru prepararea soluției. Se comercializează pentru cercetări științifice și de laborator.","warning":""}$t$::jsonb)
where slug = $t$cartalax$t$;

-- lipo-c
update public.products set
  description = $t$Lipo-C — комбинированный раствор так называемых липотропных веществ, которые участвуют в обмене жиров. Число 526 в названии — суммарное содержание компонентов в 1 мл.

L-карнитин переносит жирные кислоты в митохондрии, где они окисляются. Метионин, инозитол и холин (эту комбинацию часто называют MIC) участвуют в обмене жиров в печени. Витамины B6 и B12, а также NADH — коферменты энергетического обмена.

Подобные смеси изготавливают аптеки и лаборатории, единого стандарта состава нет.$t$,
  usage = $t$Готовый раствор во флаконе. Продаётся для научных и лабораторных исследований.$t$,
  warning = $t$Не применяйте при беременности, кормлении грудью, заболеваниях печени и почек.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || $t${"description":"Lipo-C is a combined solution of so-called lipotropic substances involved in fat metabolism. The number 526 in the name is the total content of the components per 1 ml.\n\nL-carnitine transports fatty acids into mitochondria, where they are oxidized. Methionine, inositol and choline (a combination often called MIC) are involved in fat metabolism in the liver. Vitamins B6 and B12 and NADH are coenzymes of energy metabolism.\n\nSuch blends are made by compounding pharmacies and laboratories; there is no single standard composition.","usage":"Ready-made solution in a vial. Sold for scientific and laboratory research.","warning":"Do not use during pregnancy, breastfeeding or with liver or kidney disease."}$t$::jsonb,
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || $t${"description":"Lipo-C este o soluție combinată de așa-numite substanțe lipotrope, implicate în metabolismul grăsimilor. Numărul 526 din denumire este conținutul total al componentelor la 1 ml.\n\nL-carnitina transportă acizii grași în mitocondrii, unde sunt oxidați. Metionina, inozitolul și colina (combinație numită adesea MIC) participă la metabolismul grăsimilor în ficat. Vitaminele B6 și B12, precum și NADH, sunt coenzime ale metabolismului energetic.\n\nAstfel de amestecuri sunt preparate de farmacii și laboratoare; nu există o compoziție standard unică.","usage":"Soluție gata preparată în flacon. Se comercializează pentru cercetări științifice și de laborator.","warning":"Nu utilizați în sarcină, în perioada de alăptare sau în boli hepatice și renale."}$t$::jsonb)
where slug = $t$lipo-c$t$;

-- bac-water
update public.products set
  description = $t$Бактериостатическая вода — стерильная вода для инъекций с добавлением 0,9 % бензилового спирта. Бензиловый спирт подавляет размножение большинства бактерий, поэтому пробку флакона можно прокалывать несколько раз.

Применяется для разведения (восстановления) лиофилизированных пептидов. В отличие от обычной стерильной воды, вскрытый флакон пригоден к использованию до 28 дней.$t$
where slug = $t$bac-water$t$;

-- Страница «О пептидах»: убираем пункт «не зарегистрированы как лекарства / не заменяют лечение врача»
-- и строку «носит справочный характер и не является медицинской рекомендацией» (на всех языках)
update public.pages set
  content = (
    jsonb_set(content - 'disclaimer', '{safety}',
      coalesce((select jsonb_agg(x) from jsonb_array_elements(content -> 'safety') x
                 where x ->> 'text' not ilike '%зарегистрированы как лекарства%'), '[]'::jsonb))
  ),
  translations = jsonb_build_object(
    'en', jsonb_set(coalesce(translations -> 'en', '{}'::jsonb) - 'disclaimer', '{safety}',
      coalesce((select jsonb_agg(x) from jsonb_array_elements(translations -> 'en' -> 'safety') x
                 where x ->> 'text' not ilike '%registered as medicines%'), '[]'::jsonb)),
    'ro', jsonb_set(coalesce(translations -> 'ro', '{}'::jsonb) - 'disclaimer', '{safety}',
      coalesce((select jsonb_agg(x) from jsonb_array_elements(translations -> 'ro' -> 'safety') x
                 where x ->> 'text' not ilike '%înregistrate ca medicamente%'), '[]'::jsonb))
  )
where slug = 'peptides';

-- Проверка: не должно остаться ни одной строки
select slug from public.products
 where concat_ws(' ', description, usage, warning, translations::text) ~* 'не является лекарств|проконсультируйтесь|not a medicinal|consult a specialist|nu este medicament|WADA';