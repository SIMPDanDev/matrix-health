-- =====================================================================
--  Уточнённые описания пептидов по итогам проверки (ноябрь 2026).
--  Запустите в Supabase → SQL Editor ПОСЛЕ products-2026-11.sql.
--  Повторный запуск безопасен. Файл сгенерирован.
--
--  • Ретатрутид: завершены исследования III фазы, заявка в FDA — I кв. 2027.
--  • Кагрилинтид: заявка на CagriSema в FDA подана в декабре 2025.
--  • Тирзепатид: Zepbound одобрен также при апноэ сна (FDA, декабрь 2024).
--  • Тимозин альфа-1: Zadaxin, более 30 стран, гепатит B.
--  • Ипаморелин, MOTS-c, Кисспептин-10, BPC-157 + TB-500, GLOW:
--    уточнены данные исследований и пометка о Запрещённом списке WADA.
-- =====================================================================

update public.products set
  description = $t$Ретатрутид — синтетический пептид компании Eli Lilly, который одновременно активирует три рецептора: GIP, GLP-1 и глюкагона.

В 2026 году завершены четыре исследования III фазы TRIUMPH при ожирении. В основном из них (TRIUMPH-1) участники на максимальной дозе за 80 недель потеряли в среднем около 28 % массы тела. Eli Lilly планирует подать заявку на регистрацию в FDA в I квартале 2027 года. На момент составления описания ретатрутид не зарегистрирован как лекарственное средство.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$Retatrutide is a synthetic peptide by Eli Lilly that activates three receptors at once: GIP, GLP-1 and glucagon.

In 2026 four phase III TRIUMPH trials in obesity were completed. In the main one (TRIUMPH-1), participants on the highest dose lost on average about 28% of body weight over 80 weeks. Eli Lilly plans to submit it to the FDA in the first quarter of 2027. At the time this description was written, retatrutide is not registered as a medicine.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$Retatrutida este o peptidă sintetică a companiei Eli Lilly care activează simultan trei receptori: GIP, GLP-1 și glucagonul.

În 2026 au fost finalizate patru studii de fază III TRIUMPH în obezitate. În cel principal (TRIUMPH-1), participanții cu doza maximă au pierdut în medie aproximativ 28 % din greutatea corporală în 80 de săptămâni. Eli Lilly intenționează să depună cererea de înregistrare la FDA în primul trimestru al anului 2027. La momentul redactării descrierii, retatrutida nu este înregistrată ca medicament.$t$::text))
where slug = $t$retatrutide$t$;

update public.products set
  description = $t$Кагрилинтид — синтетический аналог гормона амилина длительного действия, разработанный компанией Novo Nordisk. Амилин вырабатывается в поджелудочной железе вместе с инсулином и участвует в регуляции чувства насыщения.

Изучается при ожирении отдельно и в комбинации с семаглутидом (CagriSema). В декабре 2025 года Novo Nordisk подала заявку на регистрацию CagriSema в FDA. На момент составления описания ни кагрилинтид, ни CagriSema не зарегистрированы как лекарственные средства.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$Cagrilintide is a long-acting synthetic analogue of the hormone amylin developed by Novo Nordisk. Amylin is produced in the pancreas together with insulin and helps regulate satiety.

It is being studied for obesity, alone and in combination with semaglutide (CagriSema). In December 2025 Novo Nordisk submitted CagriSema to the FDA for approval. At the time this description was written, neither cagrilintide nor CagriSema is registered as a medicine.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$Cagrilintida este un analog sintetic cu acțiune prelungită al hormonului amilină, dezvoltat de compania Novo Nordisk. Amilina este produsă în pancreas împreună cu insulina și participă la reglarea senzației de sațietate.

Este studiată în obezitate, separat și în combinație cu semaglutida (CagriSema). În decembrie 2025, Novo Nordisk a depus la FDA cererea de înregistrare a CagriSema. La momentul redactării descrierii, nici cagrilintida, nici CagriSema nu sunt înregistrate ca medicamente.$t$::text))
where slug = $t$cagrilintide$t$;

update public.products set
  description = $t$Тирзепатид — синтетический пептид компании Eli Lilly из 39 аминокислот, который активирует рецепторы двух гормонов кишечника: GIP и GLP-1. Вводится подкожно раз в неделю.

Зарегистрирован как рецептурное лекарство: Mounjaro — для лечения сахарного диабета 2 типа, Zepbound — для лечения ожирения. В декабре 2024 года FDA (США) одобрило Zepbound также для лечения обструктивного апноэ сна средней и тяжёлой степени у взрослых с ожирением.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$Tirzepatide is a 39-amino-acid synthetic peptide by Eli Lilly that activates the receptors of two gut hormones: GIP and GLP-1. It is injected under the skin once a week.

It is registered as a prescription medicine: Mounjaro for type 2 diabetes and Zepbound for obesity. In December 2024 the US FDA also approved Zepbound for moderate-to-severe obstructive sleep apnea in adults with obesity.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$Tirzepatida este o peptidă sintetică din 39 de aminoacizi a companiei Eli Lilly, care activează receptorii a doi hormoni intestinali: GIP și GLP-1. Se administrează subcutanat o dată pe săptămână.

Este înregistrată ca medicament eliberat pe bază de rețetă: Mounjaro — pentru diabetul zaharat de tip 2, Zepbound — pentru obezitate. În decembrie 2024, FDA (SUA) a aprobat Zepbound și pentru apneea obstructivă în somn moderată și severă la adulții cu obezitate.$t$::text))
where slug = $t$tirzepatide$t$;

update public.products set
  description = $t$Тимозин альфа-1 — пептид из 28 аминокислот, впервые выделенный из тимуса (вилочковой железы). Участвует в созревании и активации Т-лимфоцитов.

Его синтетическая форма — тималфазин (торговое название Zadaxin) — зарегистрирована более чем в 30 странах, в том числе в Китае и Италии, как иммуномодулирующее лекарство, в основном для лечения хронического гепатита B. В США и Евросоюзе как лекарство не зарегистрирован.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$Thymosin alpha-1 is a 28-amino-acid peptide first isolated from the thymus gland. It is involved in the maturation and activation of T lymphocytes.

Its synthetic form, thymalfasin (brand name Zadaxin), is registered in more than 30 countries, including China and Italy, as an immunomodulating medicine, mainly for chronic hepatitis B. It is not registered as a medicine in the US or the EU.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$Timozina alfa-1 este o peptidă din 28 de aminoacizi, izolată pentru prima dată din timus. Participă la maturarea și activarea limfocitelor T.

Forma sa sintetică, timalfasina (denumire comercială Zadaxin), este înregistrată în peste 30 de țări, inclusiv China și Italia, ca medicament imunomodulator, în principal pentru hepatita B cronică. În SUA și Uniunea Europeană nu este înregistrată ca medicament.$t$::text))
where slug = $t$thymosin-alpha-1$t$;

update public.products set
  description = $t$Ипаморелин — синтетический пентапептид Aib-His-D-2-Nal-D-Phe-Lys-NH2.

Связывается с рецептором грелина (GHSR-1a) в гипофизе и стимулирует выброс гормона роста. В исследованиях отличался избирательностью: слабо влиял на уровень кортизола и АКТГ.

Компания Helsinn изучала его во II фазе клинических исследований для восстановления работы кишечника после операций; значимого отличия от плацебо получено не было. Как лекарственное средство не зарегистрирован. Входит в Запрещённый список WADA: спортсменам применять нельзя.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$Ipamorelin is the synthetic pentapeptide Aib-His-D-2-Nal-D-Phe-Lys-NH2.

It binds to the ghrelin receptor (GHSR-1a) in the pituitary gland and stimulates the release of growth hormone. In studies it was notably selective: it had little effect on cortisol and ACTH levels.

Helsinn studied it in phase II clinical trials for recovery of bowel function after surgery; no significant difference from placebo was found. It is not registered as a medicine. It is on the WADA Prohibited List: athletes must not use it.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$Ipamorelina este pentapeptida sintetică Aib-His-D-2-Nal-D-Phe-Lys-NH2.

Se leagă de receptorul grelinei (GHSR-1a) din hipofiză și stimulează eliberarea hormonului de creștere. În studii s-a remarcat prin selectivitate: a influențat slab nivelul de cortizol și ACTH.

Compania Helsinn a studiat-o în studii clinice de fază II pentru refacerea funcției intestinale după operații; nu s-a obținut o diferență semnificativă față de placebo. Nu este înregistrată ca medicament. Figurează pe Lista interzisă WADA: sportivii nu au voie să o utilizeze.$t$::text))
where slug = $t$ipamorelin$t$;

update public.products set
  description = $t$MOTS-c — пептид из 16 аминокислот (Met-Arg-Trp-Gln-Glu-Met-Gly-Tyr-Ile-Phe-Tyr-Pro-Arg-Lys-Leu-Arg), закодированный в митохондриальной ДНК. Описан в 2015 году.

Активирует фермент AMPK и изучается в связи с регуляцией обмена веществ и чувствительностью к инсулину. Основные данные получены в исследованиях на животных; у людей изучался только его модифицированный аналог CB4211 в ранних клинических исследованиях. Как лекарственное средство не зарегистрирован. Входит в Запрещённый список WADA: спортсменам применять нельзя.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$MOTS-c is a 16-amino-acid peptide (Met-Arg-Trp-Gln-Glu-Met-Gly-Tyr-Ile-Phe-Tyr-Pro-Arg-Lys-Leu-Arg) encoded in mitochondrial DNA. It was described in 2015.

It activates the enzyme AMPK and is being studied in connection with the regulation of metabolism and insulin sensitivity. Most data come from animal studies; in humans only its modified analogue CB4211 has been tested, in early clinical trials. It is not registered as a medicine. It is on the WADA Prohibited List: athletes must not use it.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$MOTS-c este o peptidă din 16 aminoacizi (Met-Arg-Trp-Gln-Glu-Met-Gly-Tyr-Ile-Phe-Tyr-Pro-Arg-Lys-Leu-Arg), codificată în ADN-ul mitocondrial. A fost descrisă în 2015.

Activează enzima AMPK și este studiată în legătură cu reglarea metabolismului și sensibilitatea la insulină. Majoritatea datelor provin din studii pe animale; la om a fost testat doar analogul său modificat CB4211, în studii clinice timpurii. Nu este înregistrată ca medicament. Figurează pe Lista interzisă WADA: sportivii nu au voie să o utilizeze.$t$::text))
where slug = $t$mots-c$t$;

update public.products set
  description = $t$Кисспептин-10 — синтетический декапептид Tyr-Asn-Trp-Asn-Ser-Phe-Gly-Leu-Arg-Phe-NH2, самый короткий полностью активный фрагмент белка кисспептина (продукт гена KISS1).

Кисспептин связывается с рецептором KISS1R (GPR54) на нейронах гипоталамуса и запускает выброс гонадотропин-рилизинг-гормона, а через него — лютеинизирующего и фолликулостимулирующего гормонов. Это ключевое звено регуляции репродуктивной системы.

В клинических исследованиях, в том числе при ЭКО, чаще применяли более длинную форму — кисспептин-54; кисспептин-10 быстро выводится из организма и используется в основном в научных исследованиях. Как лекарственное средство не зарегистрирован. Для спортсменов-мужчин входит в Запрещённый список WADA.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$Kisspeptin-10 is the synthetic decapeptide Tyr-Asn-Trp-Asn-Ser-Phe-Gly-Leu-Arg-Phe-NH2, the shortest fully active fragment of the protein kisspeptin (the product of the KISS1 gene).

Kisspeptin binds to the KISS1R (GPR54) receptor on hypothalamic neurons and triggers the release of gonadotropin-releasing hormone and, through it, of luteinizing and follicle-stimulating hormones. This is a key link in the regulation of the reproductive system.

Clinical trials, including in IVF, have mostly used the longer form, kisspeptin-54; kisspeptin-10 is cleared from the body quickly and is used mainly in scientific research. It is not registered as a medicine. For male athletes it is on the WADA Prohibited List.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$Kisspeptina-10 este decapeptida sintetică Tyr-Asn-Trp-Asn-Ser-Phe-Gly-Leu-Arg-Phe-NH2, cel mai scurt fragment complet activ al proteinei kisspeptină (produsul genei KISS1).

Kisspeptina se leagă de receptorul KISS1R (GPR54) de pe neuronii hipotalamusului și declanșează eliberarea hormonului de eliberare a gonadotropinelor și, prin acesta, a hormonilor luteinizant și foliculostimulant. Aceasta este o verigă-cheie în reglarea sistemului reproducător.

În studiile clinice, inclusiv în FIV, s-a folosit mai des forma mai lungă — kisspeptina-54; kisspeptina-10 este eliminată rapid din organism și se folosește în principal în cercetarea științifică. Nu este înregistrată ca medicament. Pentru sportivii bărbați figurează pe Lista interzisă WADA.$t$::text))
where slug = $t$kisspeptin-10$t$;

update public.products set
  description = $t$BPC-157 (Body Protection Compound) — синтетический пептид из 15 аминокислот (Gly-Glu-Pro-Pro-Pro-Gly-Lys-Pro-Ala-Asp-Asp-Ala-Gly-Leu-Val), фрагмент белка, выделенного из желудочного сока.

TB-500 — синтетический фрагмент тимозина бета-4, белка, участвующего в перестройке цитоскелета клеток.

Оба пептида изучаются в доклинических исследованиях (на клетках и животных) в связи с восстановлением тканей. Как лекарственные средства не зарегистрированы. BPC-157 и TB-500 входят в Запрещённый список WADA: спортсменам применять нельзя.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$BPC-157 (Body Protection Compound) is a synthetic 15-amino-acid peptide (Gly-Glu-Pro-Pro-Pro-Gly-Lys-Pro-Ala-Asp-Asp-Ala-Gly-Leu-Val), a fragment of a protein isolated from gastric juice.

TB-500 is a synthetic fragment of thymosin beta-4, a protein involved in reorganizing the cell cytoskeleton.

Both peptides are being studied in preclinical research (in cells and animals) in connection with tissue repair. They are not registered as medicines. BPC-157 and TB-500 are on the WADA Prohibited List: athletes must not use them.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$BPC-157 (Body Protection Compound) este o peptidă sintetică din 15 aminoacizi (Gly-Glu-Pro-Pro-Pro-Gly-Lys-Pro-Ala-Asp-Asp-Ala-Gly-Leu-Val), un fragment al unei proteine izolate din sucul gastric.

TB-500 este un fragment sintetic al timozinei beta-4, o proteină implicată în reorganizarea citoscheletului celular.

Ambele peptide sunt studiate în cercetări preclinice (pe celule și animale) în legătură cu refacerea țesuturilor. Nu sunt înregistrate ca medicamente. BPC-157 și TB-500 figurează pe Lista interzisă WADA: sportivii nu au voie să le utilizeze.$t$::text))
where slug = $t$bpc-157-tb-500$t$;

update public.products set
  description = $t$GLOW — смесь трёх пептидов в одном флаконе: 50 мг GHK-Cu, 10 мг BPC-157 и 10 мг TB-500, всего 70 мг.

GHK-Cu — природный трипептид глицил-гистидил-лизин в комплексе с ионом меди. Содержится в плазме крови человека; известен по исследованиям в области восстановления кожи.

BPC-157 — синтетический пептид из 15 аминокислот, фрагмент белка желудочного сока. TB-500 — синтетический фрагмент белка тимозина бета-4.

Данные о действии компонентов получены преимущественно в исследованиях на клетках и животных. Клинических исследований этой комбинации у людей нет. BPC-157 и TB-500 входят в Запрещённый список WADA: спортсменам применять нельзя.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$GLOW is a blend of three peptides in one vial: 50 mg GHK-Cu, 10 mg BPC-157 and 10 mg TB-500, 70 mg in total.

GHK-Cu is the naturally occurring tripeptide glycyl-histidyl-lysine bound to a copper ion. It is found in human blood plasma and is known from research on skin repair.

BPC-157 is a synthetic 15-amino-acid peptide, a fragment of a protein from gastric juice. TB-500 is a synthetic fragment of the protein thymosin beta-4.

Data on the effects of the components come mainly from cell and animal studies. There are no clinical studies of this combination in humans. BPC-157 and TB-500 are on the WADA Prohibited List: athletes must not use them.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$GLOW este un amestec de trei peptide într-un singur flacon: 50 mg GHK-Cu, 10 mg BPC-157 și 10 mg TB-500, în total 70 mg.

GHK-Cu este tripeptida naturală glicil-histidil-lizină legată de un ion de cupru. Se găsește în plasma sângelui uman și este cunoscută din cercetările privind refacerea pielii.

BPC-157 este o peptidă sintetică din 15 aminoacizi, un fragment al unei proteine din sucul gastric. TB-500 este un fragment sintetic al proteinei timozină beta-4.

Datele despre efectele componentelor provin în principal din studii pe celule și animale. Nu există studii clinice ale acestei combinații la om. BPC-157 și TB-500 figurează pe Lista interzisă WADA: sportivii nu au voie să le utilizeze.$t$::text))
where slug = $t$glow$t$;

-- Проверка: должно быть 9 строк
select slug, left(description, 60) from public.products where slug in ('retatrutide', 'cagrilintide', 'tirzepatide', 'thymosin-alpha-1', 'ipamorelin', 'mots-c', 'kisspeptin-10', 'bpc-157-tb-500', 'glow');