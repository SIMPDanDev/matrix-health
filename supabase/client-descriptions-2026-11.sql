-- =====================================================================
--  Описания от клиента для 12 пептидов — выверены по фактам, на трёх языках.
--  Абзацы — через пустую строку, строки с «• » — пункты списка (на сайте — список).
--  Запустите в Supabase → SQL Editor ПОСЛЕ texts-cleanup-2026-11.sql.
--  Повторный запуск безопасен. Файл сгенерирован.
--
--  Что исправлено в тексте клиента:
--   • MOTS-c — данные Cell Metabolism и Nature Communications получены на мышах;
--   • 5-Amino-1MQ — клинических испытаний у людей не было, убраны выдуманные результаты и схема приёма;
--   • кагрилинтид — REDEFINE 1: ~12 % в одиночку и ~20 % с семаглутидом;
--   • NAD+ — исправлен путь синтеза;
--   • эпиталон — убрано «снижает риск опухолей до 5 раз»;
--   • семакс — убраны «формат спрея» (у нас флакон) и «педиатрия, СДВГ»;
--   • дозировки «20 мг/2 мл», «100 мг» из текста клиента не указаны — они задаются вариантами товара.
-- =====================================================================

update public.products set
  description = $t$Эпиталон — синтетический тетрапептид Ala-Glu-Asp-Gly. Создан в Санкт-Петербургском институте биорегуляции и геронтологии под руководством В. Х. Хавинсона на основе эпиталамина — экстракта шишковидной железы (эпифиза).

Эпифиз вырабатывает мелатонин и задаёт суточные ритмы организма. Эпиталон изучается как регулятор этой системы и как геропротектор: в работах Хавинсона он активировал теломеразу в клетках и увеличивал продолжительность жизни лабораторных животных.

Направления применения:
• выработка мелатонина и суточные биоритмы;
• нарушения сна и бессонница;
• джетлаг — сбой сна после длительных перелётов;
• усталость и стресс;
• ослабленный иммунитет и антиоксидантная защита;
• нейроэндокринная регуляция, в том числе репродуктивной системы и в период климакса;
• здоровое старение.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$Epitalon is the synthetic tetrapeptide Ala-Glu-Asp-Gly. It was created at the St. Petersburg Institute of Bioregulation and Gerontology under V. Kh. Khavinson, based on epithalamin, an extract of the pineal gland.

The pineal gland produces melatonin and sets the body’s daily rhythms. Epitalon is studied as a regulator of this system and as a geroprotector: in Khavinson’s work it activated telomerase in cells and extended the lifespan of laboratory animals.

Areas of use:
• melatonin production and daily biorhythms;
• sleep disorders and insomnia;
• jet lag — disrupted sleep after long flights;
• fatigue and stress;
• weakened immunity and antioxidant protection;
• neuroendocrine regulation, including the reproductive system and menopause;
• healthy ageing.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$Epitalonul este tetrapeptida sintetică Ala-Glu-Asp-Gly. A fost creat la Institutul de Bioreglare și Gerontologie din Sankt Petersburg sub conducerea lui V. H. Havinson, pe baza epitalaminei — un extract din glanda pineală (epifiză).

Epifiza produce melatonină și stabilește ritmurile zilnice ale organismului. Epitalonul este studiat ca regulator al acestui sistem și ca geroprotector: în lucrările lui Havinson a activat telomeraza în celule și a prelungit viața animalelor de laborator.

Direcții de utilizare:
• producția de melatonină și bioritmurile zilnice;
• tulburările de somn și insomnia;
• jet lag — dereglarea somnului după zboruri lungi;
• oboseala și stresul;
• imunitatea slăbită și protecția antioxidantă;
• reglarea neuroendocrină, inclusiv a sistemului reproductiv și în perioada menopauzei;
• îmbătrânirea sănătoasă.$t$::text))
where slug = $t$epitalon$t$;

update public.products set
  description = $t$GLOW (Glow Blend) — комбинация трёх пептидов в одном флаконе: GHK-Cu (50 мг), BPC-157 (10 мг) и TB-500 (10 мг), всего 70 мг.

Для чего используется GLOW:
• синтез коллагена и эластина;
• качество кожи и мелкие морщины;
• заживление кожи и мягких тканей;
• снижение воспаления;
• рост волос;
• восстановление после травм и физических нагрузок.

Что делает каждый компонент:
• GHK-Cu — медный трипептид: стимулирует выработку коллагена, ускоряет заживление кожи, обладает антиоксидантными свойствами. Лучше всего изучен в косметологии, особенно в сыворотках.
• BPC-157 — пептид из 15 аминокислот, фрагмент белка желудочного сока. Влияет в основном на восстановление сухожилий, связок и слизистой ЖКТ.
• TB-500 — фрагмент белка тимозина бета-4. В составе отвечает за восстановление тканей.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$GLOW (Glow Blend) is a combination of three peptides in one vial: GHK-Cu (50 mg), BPC-157 (10 mg) and TB-500 (10 mg), 70 mg in total.

What GLOW is used for:
• collagen and elastin synthesis;
• skin quality and fine wrinkles;
• healing of skin and soft tissues;
• reducing inflammation;
• hair growth;
• recovery after injuries and physical exertion.

What each component does:
• GHK-Cu — a copper tripeptide: stimulates collagen production, speeds up skin healing and has antioxidant properties. It is best studied in cosmetology, especially in serums.
• BPC-157 — a 15-amino-acid peptide, a fragment of a gastric juice protein. It mainly supports the repair of tendons, ligaments and the gut lining.
• TB-500 — a fragment of the protein thymosin beta-4. In this blend it is responsible for tissue repair.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$GLOW (Glow Blend) este o combinație de trei peptide într-un singur flacon: GHK-Cu (50 mg), BPC-157 (10 mg) și TB-500 (10 mg), în total 70 mg.

Pentru ce se folosește GLOW:
• sinteza colagenului și elastinei;
• calitatea pielii și ridurile fine;
• vindecarea pielii și a țesuturilor moi;
• reducerea inflamației;
• creșterea părului;
• recuperarea după traumatisme și efort fizic.

Ce face fiecare componentă:
• GHK-Cu — tripeptidă cu cupru: stimulează producția de colagen, accelerează vindecarea pielii și are proprietăți antioxidante. Este cel mai bine studiată în cosmetologie, mai ales în seruri.
• BPC-157 — peptidă din 15 aminoacizi, fragment al unei proteine din sucul gastric. Susține în principal refacerea tendoanelor, ligamentelor și a mucoasei tractului digestiv.
• TB-500 — fragment al proteinei timozină beta-4. În acest amestec răspunde de refacerea țesuturilor.$t$::text))
where slug = $t$glow$t$;

update public.products set
  description = $t$MOTS-c — пептид из 16 аминокислот (Met-Arg-Trp-Gln-Glu-Met-Gly-Tyr-Ile-Phe-Tyr-Pro-Arg-Lys-Leu-Arg), закодированный в ДНК митохондрий. Относится к митохондриальным пептидам (mitochondrial-derived peptides, MDP) — сигнальным молекулам, через которые митохондрии влияют на обмен веществ всего организма.

MOTS-c регулирует клеточный энергетический баланс: активирует фермент AMPK, влияет на обмен глюкозы и чувствительность к инсулину. При метаболическом стрессе он перемещается в ядро клетки и меняет работу генов, отвечающих за обмен веществ и защиту клетки. Пептид циркулирует в крови, поэтому его считают митохондриальным гормоном; его уровень растёт при физической нагрузке.

MOTS-c описан в 2015 году в журнале Cell Metabolism: у мышей на жирной диете он предотвращал ожирение и инсулинорезистентность. В работе 2021 года в Nature Communications MOTS-c повышал физическую выносливость у молодых и пожилых мышей.

Направления исследований:
• обмен веществ и масса тела;
• толерантность к глюкозе и чувствительность к инсулину;
• физическая выносливость и функция мышц;
• функция митохондрий и устойчивость к стрессу;
• хроническое воспаление;
• костная ткань и остеопороз;
• возрастные метаболические нарушения и здоровое долголетие.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$MOTS-c is a 16-amino-acid peptide (Met-Arg-Trp-Gln-Glu-Met-Gly-Tyr-Ile-Phe-Tyr-Pro-Arg-Lys-Leu-Arg) encoded in mitochondrial DNA. It belongs to the mitochondrial-derived peptides (MDPs) — signalling molecules through which mitochondria influence the metabolism of the whole body.

MOTS-c regulates cellular energy balance: it activates the enzyme AMPK and affects glucose metabolism and insulin sensitivity. Under metabolic stress it moves into the cell nucleus and changes the activity of genes responsible for metabolism and cell protection. The peptide circulates in the blood, so it is considered a mitochondrial hormone; its level rises with physical exercise.

MOTS-c was described in 2015 in Cell Metabolism: in mice on a high-fat diet it prevented obesity and insulin resistance. In a 2021 study in Nature Communications, MOTS-c improved physical endurance in young and old mice.

Areas of research:
• metabolism and body weight;
• glucose tolerance and insulin sensitivity;
• physical endurance and muscle function;
• mitochondrial function and stress resistance;
• chronic inflammation;
• bone tissue and osteoporosis;
• age-related metabolic disorders and healthy longevity.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$MOTS-c este o peptidă din 16 aminoacizi (Met-Arg-Trp-Gln-Glu-Met-Gly-Tyr-Ile-Phe-Tyr-Pro-Arg-Lys-Leu-Arg), codificată în ADN-ul mitocondrial. Face parte din peptidele mitocondriale (mitochondrial-derived peptides, MDP) — molecule de semnalizare prin care mitocondriile influențează metabolismul întregului organism.

MOTS-c reglează echilibrul energetic al celulei: activează enzima AMPK și influențează metabolismul glucozei și sensibilitatea la insulină. În condiții de stres metabolic se deplasează în nucleul celulei și modifică activitatea genelor responsabile de metabolism și protecția celulei. Peptida circulă în sânge, de aceea este considerată un hormon mitocondrial; nivelul ei crește în timpul efortului fizic.

MOTS-c a fost descrisă în 2015 în revista Cell Metabolism: la șoarecii hrăniți cu dietă bogată în grăsimi a prevenit obezitatea și rezistența la insulină. Într-un studiu din 2021 publicat în Nature Communications, MOTS-c a crescut rezistența fizică la șoarecii tineri și bătrâni.

Direcții de cercetare:
• metabolismul și greutatea corporală;
• toleranța la glucoză și sensibilitatea la insulină;
• rezistența fizică și funcția musculară;
• funcția mitocondriilor și rezistența la stres;
• inflamația cronică;
• țesutul osos și osteoporoza;
• tulburările metabolice legate de vârstă și longevitatea sănătoasă.$t$::text))
where slug = $t$mots-c$t$;

update public.products set
  description = $t$SS-31 (эламипретид) — синтетический тетрапептид D-Arg-Dmt-Lys-Phe-NH2, где Dmt — 2,6-диметилтирозин. Он проникает в клетки, накапливается во внутренней мембране митохондрий и связывается с кардиолипином — липидом, от которого зависит работа дыхательной цепи.

Так SS-31 стабилизирует митохондрии: улучшает выработку клеточной энергии (АТФ) и снижает образование активных форм кислорода. В сентябре 2025 года FDA (США) в ускоренном порядке одобрило эламипретид под названием Forzinity для лечения синдрома Барта — редкого наследственного митохондриального заболевания.

Направления применения:
• поддержка митохондриальной функции;
• повышение клеточной энергии (АТФ);
• снижение хронической усталости;
• защита и восстановление мышечной ткани, восстановление после физических нагрузок;
• когнитивные функции, память и нейропротекция;
• сердечно-сосудистая система;
• здоровье почек и глаз;
• снижение окислительного стресса и контроль воспаления;
• здоровое старение и клеточная регенерация.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$SS-31 (elamipretide) is the synthetic tetrapeptide D-Arg-Dmt-Lys-Phe-NH2, where Dmt is 2,6-dimethyltyrosine. It enters cells, accumulates in the inner mitochondrial membrane and binds to cardiolipin — a lipid on which the respiratory chain depends.

In this way SS-31 stabilises mitochondria: it improves cellular energy (ATP) production and reduces the formation of reactive oxygen species. In September 2025 the US FDA granted accelerated approval to elamipretide under the name Forzinity for Barth syndrome, a rare inherited mitochondrial disease.

Areas of use:
• support of mitochondrial function;
• higher cellular energy (ATP);
• less chronic fatigue;
• protection and repair of muscle tissue, recovery after exercise;
• cognitive function, memory and neuroprotection;
• the cardiovascular system;
• kidney and eye health;
• lower oxidative stress and control of inflammation;
• healthy ageing and cell regeneration.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$SS-31 (elamipretidă) este tetrapeptida sintetică D-Arg-Dmt-Lys-Phe-NH2, unde Dmt este 2,6-dimetiltirozina. Pătrunde în celule, se acumulează în membrana internă a mitocondriilor și se leagă de cardiolipină — un lipid de care depinde funcționarea lanțului respirator.

Astfel SS-31 stabilizează mitocondriile: îmbunătățește producția de energie celulară (ATP) și reduce formarea speciilor reactive de oxigen. În septembrie 2025, FDA (SUA) a aprobat în regim accelerat elamipretida sub denumirea Forzinity pentru sindromul Barth — o boală mitocondrială ereditară rară.

Direcții de utilizare:
• susținerea funcției mitocondriale;
• creșterea energiei celulare (ATP);
• reducerea oboselii cronice;
• protecția și refacerea țesutului muscular, recuperarea după efort fizic;
• funcțiile cognitive, memoria și neuroprotecția;
• sistemul cardiovascular;
• sănătatea rinichilor și a ochilor;
• reducerea stresului oxidativ și controlul inflamației;
• îmbătrânirea sănătoasă și regenerarea celulară.$t$::text))
where slug = $t$ss-31$t$;

update public.products set
  description = $t$Ипаморелин — синтетический пентапептид Aib-His-D-2-Nal-D-Phe-Lys-NH2 из группы секретагогов гормона роста. Он связывается с рецептором грелина (GHSR-1a) в гипофизе и усиливает собственную, естественную секрецию гормона роста.

Главная особенность ипаморелина — избирательность: в исследованиях он почти не влиял на уровень кортизола, АКТГ и пролактина, в отличие от более ранних пептидов этой группы.

Для чего используется:
• поддержка естественной секреции гормона роста;
• восстановление после тренировок и нагрузок;
• рост и сохранение мышечной массы;
• жиросжигание и композиция тела при активном образе жизни;
• энергия и физическая работоспособность;
• суставы, связки, сухожилия и регенерация тканей;
• качество сна и ночное восстановление;
• поддержание физической формы и активное долголетие.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$Ipamorelin is the synthetic pentapeptide Aib-His-D-2-Nal-D-Phe-Lys-NH2 from the group of growth hormone secretagogues. It binds to the ghrelin receptor (GHSR-1a) in the pituitary gland and boosts the body’s own, natural secretion of growth hormone.

Its main feature is selectivity: in studies it had almost no effect on cortisol, ACTH and prolactin levels, unlike earlier peptides of this group.

What it is used for:
• support of natural growth hormone secretion;
• recovery after training and exertion;
• building and preserving muscle mass;
• fat burning and body composition with an active lifestyle;
• energy and physical performance;
• joints, ligaments, tendons and tissue regeneration;
• sleep quality and overnight recovery;
• staying in shape and active longevity.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$Ipamorelina este pentapeptida sintetică Aib-His-D-2-Nal-D-Phe-Lys-NH2 din grupul secretagogilor hormonului de creștere. Se leagă de receptorul grelinei (GHSR-1a) din hipofiză și intensifică secreția proprie, naturală, a hormonului de creștere.

Principala ei particularitate este selectivitatea: în studii aproape nu a influențat nivelul de cortizol, ACTH și prolactină, spre deosebire de peptidele mai vechi din acest grup.

Pentru ce se folosește:
• susținerea secreției naturale a hormonului de creștere;
• recuperarea după antrenamente și efort;
• creșterea și menținerea masei musculare;
• arderea grăsimilor și compoziția corporală la un stil de viață activ;
• energia și performanța fizică;
• articulațiile, ligamentele, tendoanele și regenerarea țesuturilor;
• calitatea somnului și recuperarea pe timpul nopții;
• menținerea formei fizice și longevitatea activă.$t$::text))
where slug = $t$ipamorelin$t$;

update public.products set
  description = $t$Простамакс — синтетический тетрапептид Lys-Glu-Asp-Pro (KEDP), пептидный биорегулятор предстательной железы. Относится к коротким пептидам, разработанным в Санкт-Петербургском институте биорегуляции и геронтологии (В. Х. Хавинсон).

Он состоит из четырёх аминокислот: лизина (Lys), глутаминовой кислоты (Glu), аспарагиновой кислоты (Asp) и пролина (Pro). Короткие пептиды-биорегуляторы рассматриваются как сигнальные молекулы, которые поддерживают работу клеток конкретного органа, — в случае простамакса это ткань предстательной железы.

Для чего используется:
• поддержка функции предстательной железы;
• нормализация мочеиспускания, в том числе ночного;
• снижение хронического воспаления простаты;
• сексуальное здоровье и потенция;
• профилактика возрастных изменений простаты у мужчин.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$ProstaMax is the synthetic tetrapeptide Lys-Glu-Asp-Pro (KEDP), a peptide bioregulator of the prostate gland. It belongs to the short peptides developed at the St. Petersburg Institute of Bioregulation and Gerontology (V. Kh. Khavinson).

It consists of four amino acids: lysine (Lys), glutamic acid (Glu), aspartic acid (Asp) and proline (Pro). Short bioregulator peptides are seen as signalling molecules that support the cells of a specific organ — for ProstaMax, the prostate tissue.

What it is used for:
• support of prostate function;
• normal urination, including at night;
• reducing chronic prostate inflammation;
• sexual health and potency;
• prevention of age-related prostate changes in men.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$ProstaMax este tetrapeptida sintetică Lys-Glu-Asp-Pro (KEDP), un bioregulator peptidic al prostatei. Face parte din peptidele scurte dezvoltate la Institutul de Bioreglare și Gerontologie din Sankt Petersburg (V. H. Havinson).

Este alcătuită din patru aminoacizi: lizină (Lys), acid glutamic (Glu), acid aspartic (Asp) și prolină (Pro). Peptidele bioregulatoare scurte sunt considerate molecule de semnalizare care susțin celulele unui anumit organ — în cazul ProstaMax, țesutul prostatei.

Pentru ce se folosește:
• susținerea funcției prostatei;
• normalizarea urinării, inclusiv pe timpul nopții;
• reducerea inflamației cronice a prostatei;
• sănătatea sexuală și potența;
• prevenirea modificărilor prostatei legate de vârstă la bărbați.$t$::text))
where slug = $t$prostamax$t$;

update public.products set
  description = $t$GHK-Cu — природный трипептид глицил-L-гистидил-L-лизин в комплексе с ионом меди (Cu²⁺). Содержится в плазме крови, слюне и моче человека, с возрастом его уровень снижается. Один из самых изученных пептидов для кожи, широко используется в косметологии.

GHK-Cu стимулирует синтез коллагена, эластина и гликозаминогликанов, ускоряет заживление, улучшает тонус и структуру кожи и снижает воспаление. Подходит для профессионального использования и домашнего ухода.

Действие на кожу:
• разглаживает морщины и мелкие линии за счёт выработки коллагена;
• укрепляет коллагеновую сеть и повышает эластичность;
• улучшает увлажнённость и гладкость кожи;
• успокаивает кожу и уменьшает покраснения;
• выравнивает тон, уменьшает пигментацию и следы постакне;
• ускоряет заживление ран и восстановление после процедур и солнца;
• защищает клетки от окислительного стресса и преждевременного старения;
• придаёт коже сияющий вид («glow-эффект»).$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$GHK-Cu is the naturally occurring tripeptide glycyl-L-histidyl-L-lysine bound to a copper ion (Cu²⁺). It is found in human blood plasma, saliva and urine, and its level falls with age. It is one of the most studied peptides for the skin and is widely used in cosmetology.

GHK-Cu stimulates the synthesis of collagen, elastin and glycosaminoglycans, speeds up healing, improves skin tone and texture and reduces inflammation. It is suitable for professional use and home care.

Effects on the skin:
• smooths wrinkles and fine lines by boosting collagen;
• strengthens the collagen network and improves elasticity;
• improves skin hydration and smoothness;
• soothes the skin and reduces redness;
• evens out skin tone, reduces pigmentation and post-acne marks;
• speeds up wound healing and recovery after procedures and sun exposure;
• protects cells from oxidative stress and premature ageing;
• gives the skin a radiant look (the “glow effect”).$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$GHK-Cu este tripeptida naturală glicil-L-histidil-L-lizină legată de un ion de cupru (Cu²⁺). Se găsește în plasma sângelui, în salivă și în urina umană, iar nivelul ei scade odată cu vârsta. Este una dintre cele mai studiate peptide pentru piele și este folosită pe scară largă în cosmetologie.

GHK-Cu stimulează sinteza colagenului, elastinei și glicozaminoglicanilor, accelerează vindecarea, îmbunătățește tonusul și structura pielii și reduce inflamația. Este potrivită pentru uz profesional și pentru îngrijirea la domiciliu.

Efectele asupra pielii:
• netezește ridurile și liniile fine prin stimularea colagenului;
• întărește rețeaua de colagen și crește elasticitatea;
• îmbunătățește hidratarea și netezimea pielii;
• calmează pielea și reduce roșeața;
• uniformizează tenul, reduce pigmentarea și urmele de acnee;
• accelerează vindecarea rănilor și refacerea după proceduri și expunerea la soare;
• protejează celulele de stresul oxidativ și de îmbătrânirea prematură;
• oferă pielii un aspect strălucitor („efectul glow”).$t$::text))
where slug = $t$ghk-cu$t$;

update public.products set
  description = $t$5-Amino-1MQ (5-амино-1-метилхинолиний) — небольшая синтетическая молекула, а не пептид. Она подавляет фермент никотинамид-N-метилтрансферазу (NNMT), который участвует в обмене никотинамида — формы витамина B3 — и особенно активен в жировой ткани.

Когда NNMT заблокирован, в клетках остаётся больше никотинамида для синтеза NAD+ и меняется энергетический обмен жировых клеток. В исследовании 2018 года у мышей с ожирением 5-Amino-1MQ снижал массу тела и жировой ткани и уменьшал размер жировых клеток, хотя животные ели столько же. У пожилых мышей он улучшал восстановление мышц после травмы.

Направления исследований:
• расщепление жиров и снижение массы тела;
• энергетический обмен клеток и уровень NAD+;
• чувствительность к инсулину и уровень глюкозы;
• функция и восстановление мышц;
• возрастные изменения обмена веществ.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$5-Amino-1MQ (5-amino-1-methylquinolinium) is a small synthetic molecule, not a peptide. It inhibits the enzyme nicotinamide N-methyltransferase (NNMT), which takes part in the metabolism of nicotinamide — a form of vitamin B3 — and is especially active in adipose tissue.

When NNMT is blocked, cells keep more nicotinamide for NAD+ synthesis and the energy metabolism of fat cells changes. In a 2018 study in obese mice, 5-Amino-1MQ reduced body weight and fat mass and shrank fat cells, although the animals ate the same amount. In old mice it improved muscle recovery after injury.

Areas of research:
• fat breakdown and weight loss;
• cellular energy metabolism and NAD+ levels;
• insulin sensitivity and blood glucose;
• muscle function and recovery;
• age-related metabolic changes.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$5-Amino-1MQ (5-amino-1-metilchinoliniu) este o moleculă sintetică mică, nu o peptidă. Inhibă enzima nicotinamid-N-metiltransferaza (NNMT), care participă la metabolismul nicotinamidei — o formă a vitaminei B3 — și este deosebit de activă în țesutul adipos.

Când NNMT este blocată, în celule rămâne mai multă nicotinamidă pentru sinteza NAD+ și se modifică metabolismul energetic al celulelor adipoase. Într-un studiu din 2018 pe șoareci obezi, 5-Amino-1MQ a redus greutatea corporală și masa de grăsime și a micșorat celulele adipoase, deși animalele au mâncat la fel. La șoarecii bătrâni a îmbunătățit refacerea mușchilor după traumatisme.

Direcții de cercetare:
• descompunerea grăsimilor și scăderea în greutate;
• metabolismul energetic celular și nivelul NAD+;
• sensibilitatea la insulină și glicemia;
• funcția și refacerea mușchilor;
• modificările metabolice legate de vârstă.$t$::text))
where slug = $t$5-amino-1mq$t$;

update public.products set
  description = $t$Кагрилинтид — синтетический аналог гормона амилина длительного действия, разработанный компанией Novo Nordisk. Амилин вырабатывается в поджелудочной железе вместе с инсулином и участвует в регуляции аппетита и уровня сахара в крови.

Кагрилинтид активирует рецепторы амилина в мозге: человек быстрее чувствует сытость и ест меньше. Он также замедляет опорожнение желудка, поэтому сытость держится дольше. Вводится подкожно раз в неделю — отдельно или вместе с семаглутидом (комбинация CagriSema).

В исследовании III фазы REDEFINE 1 за 68 недель участники на одном кагрилинтиде потеряли в среднем около 12 % массы тела, а на комбинации с семаглутидом — около 20 %. В декабре 2025 года Novo Nordisk подала заявку на регистрацию CagriSema в FDA.

Как действует:
• снижает аппетит через рецепторы амилина в мозге;
• замедляет опорожнение желудка и продлевает сытость;
• помогает сократить перекусы и переедание;
• улучшает контроль уровня сахара и показатели липидов в крови.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$Cagrilintide is a long-acting synthetic analogue of the hormone amylin developed by Novo Nordisk. Amylin is produced in the pancreas together with insulin and helps regulate appetite and blood sugar.

Cagrilintide activates amylin receptors in the brain: you feel full sooner and eat less. It also slows stomach emptying, so the feeling of fullness lasts longer. It is injected under the skin once a week — on its own or together with semaglutide (the CagriSema combination).

In the phase III REDEFINE 1 trial, over 68 weeks participants on cagrilintide alone lost about 12% of body weight on average, and on the combination with semaglutide about 20%. In December 2025 Novo Nordisk submitted CagriSema to the FDA for approval.

How it works:
• reduces appetite through amylin receptors in the brain;
• slows stomach emptying and prolongs fullness;
• helps cut down on snacking and overeating;
• improves blood sugar control and blood lipid levels.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$Cagrilintida este un analog sintetic cu acțiune prelungită al hormonului amilină, dezvoltat de compania Novo Nordisk. Amilina este produsă în pancreas împreună cu insulina și participă la reglarea apetitului și a glicemiei.

Cagrilintida activează receptorii amilinei din creier: senzația de sațietate apare mai repede și se mănâncă mai puțin. De asemenea, încetinește golirea stomacului, astfel încât sațietatea durează mai mult. Se administrează subcutanat o dată pe săptămână — separat sau împreună cu semaglutida (combinația CagriSema).

În studiul de fază III REDEFINE 1, în 68 de săptămâni participanții care au primit doar cagrilintidă au pierdut în medie aproximativ 12 % din greutatea corporală, iar cei cu combinația cu semaglutidă — aproximativ 20 %. În decembrie 2025, Novo Nordisk a depus la FDA cererea de înregistrare a CagriSema.

Cum acționează:
• reduce apetitul prin receptorii amilinei din creier;
• încetinește golirea stomacului și prelungește sațietatea;
• ajută la reducerea gustărilor și a mâncatului în exces;
• îmbunătățește controlul glicemiei și nivelul lipidelor din sânge.$t$::text))
where slug = $t$cagrilintide$t$;

update public.products set
  description = $t$NAD+ (никотинамидадениндинуклеотид) — кофермент, без которого не работает ни одна клетка. Он участвует в гликолизе — расщеплении глюкозы, в цикле Кребса, окислении жирных кислот и выработке АТФ, а также служит «топливом» для ферментов восстановления ДНК (PARP) и сиртуинов, которые регулируют работу генов.

Организм получает NAD+ двумя путями: синтезирует его из аминокислоты триптофана (кинурениновый путь) и повторно собирает из никотинамида через NMN (путь «спасения»), а также из никотиновой кислоты. С возрастом уровень NAD+ в тканях снижается, и это связывают со снижением энергии, ухудшением когнитивных функций и возрастными заболеваниями.

Процессы, которые зависят от NAD+:
• энергетический обмен и выработка АТФ;
• восстановление ДНК и стабильность генома;
• работа генов через сиртуины;
• иммунный ответ и контроль воспаления;
• суточные ритмы, сон и бодрствование;
• работа сердца, почек и печени;
• защита нейронов мозга.

Для чего применяют NAD+ в виде инфузий и инъекций:
• хроническая усталость и низкий уровень энергии;
• когнитивные функции: память, концентрация и внимание;
• спортивные нагрузки и восстановление мышц;
• программы восстановления при зависимостях;
• здоровое старение.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$NAD+ (nicotinamide adenine dinucleotide) is a coenzyme that no cell can work without. It takes part in glycolysis (the breakdown of glucose), the Krebs cycle, fatty acid oxidation and ATP production, and also serves as “fuel” for DNA repair enzymes (PARP) and sirtuins, which regulate gene activity.

The body gets NAD+ in two ways: it synthesises it from the amino acid tryptophan (the kynurenine pathway) and recycles it from nicotinamide via NMN (the salvage pathway), as well as from nicotinic acid. NAD+ levels in tissues fall with age, which is linked to lower energy, weaker cognitive function and age-related diseases.

Processes that depend on NAD+:
• energy metabolism and ATP production;
• DNA repair and genome stability;
• gene activity through sirtuins;
• the immune response and control of inflammation;
• daily rhythms, sleep and wakefulness;
• heart, kidney and liver function;
• protection of brain neurons.

What NAD+ infusions and injections are used for:
• chronic fatigue and low energy;
• cognitive function: memory, concentration and attention;
• sports and muscle recovery;
• recovery programmes for addictions;
• healthy ageing.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$NAD+ (nicotinamid adenin dinucleotid) este o coenzimă fără de care nicio celulă nu poate funcționa. Participă la glicoliză (descompunerea glucozei), la ciclul Krebs, la oxidarea acizilor grași și la producția de ATP și servește drept „combustibil” pentru enzimele de reparare a ADN-ului (PARP) și pentru sirtuine, care reglează activitatea genelor.

Organismul obține NAD+ pe două căi: îl sintetizează din aminoacidul triptofan (calea kinureninei) și îl reciclează din nicotinamidă prin NMN (calea de „salvare”), precum și din acidul nicotinic. Odată cu vârsta, nivelul NAD+ din țesuturi scade, iar acest lucru este asociat cu scăderea energiei, înrăutățirea funcțiilor cognitive și bolile legate de vârstă.

Procese care depind de NAD+:
• metabolismul energetic și producția de ATP;
• repararea ADN-ului și stabilitatea genomului;
• activitatea genelor prin sirtuine;
• răspunsul imun și controlul inflamației;
• ritmurile zilnice, somnul și starea de veghe;
• funcționarea inimii, rinichilor și ficatului;
• protecția neuronilor din creier.

Pentru ce se folosesc perfuziile și injecțiile cu NAD+:
• oboseala cronică și nivelul scăzut de energie;
• funcțiile cognitive: memoria, concentrarea și atenția;
• efortul sportiv și refacerea musculară;
• programele de recuperare în dependențe;
• îmbătrânirea sănătoasă.$t$::text))
where slug = $t$nad-plus$t$;

update public.products set
  description = $t$Семакс — синтетический гептапептид Met-Glu-His-Phe-Pro-Gly-Pro, ноотропный пептид на основе фрагмента адренокортикотропного гормона АКТГ(4–10). Трипептид Pro-Gly-Pro защищает молекулу от быстрого разрушения ферментами. Гормональной активности АКТГ у семакса нет.

Разработан в Институте молекулярной генетики РАН совместно с МГУ. В России зарегистрирован как лекарственное средство в форме назальных капель и применяется в неврологии, в том числе после инсульта. Семакс повышает в мозге уровень нейротрофического фактора BDNF, который поддерживает выживание и работу нейронов.

Основные свойства:
• улучшает память, внимание и обучаемость;
• повышает умственную и физическую работоспособность;
• защищает мозг при гипоксии, инсульте и стрессовых нагрузках;
• снижает тревожность и усталость;
• ускоряет восстановление после стрессов и травм нервной системы.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$Semax is the synthetic heptapeptide Met-Glu-His-Phe-Pro-Gly-Pro, a nootropic peptide based on the adrenocorticotropic hormone fragment ACTH(4–10). The Pro-Gly-Pro tripeptide protects the molecule from rapid breakdown by enzymes. Semax has no ACTH hormonal activity.

It was developed at the Institute of Molecular Genetics of the Russian Academy of Sciences together with Moscow State University. In Russia it is registered as a medicine in the form of nasal drops and is used in neurology, including after stroke. Semax raises the brain’s level of BDNF, a neurotrophic factor that supports the survival and function of neurons.

Key properties:
• improves memory, attention and learning;
• increases mental and physical performance;
• protects the brain during hypoxia, stroke and stress;
• reduces anxiety and fatigue;
• speeds up recovery after stress and nervous system injuries.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$Semax este heptapeptida sintetică Met-Glu-His-Phe-Pro-Gly-Pro, o peptidă nootropă bazată pe fragmentul hormonului adrenocorticotrop ACTH(4–10). Tripeptida Pro-Gly-Pro protejează molecula de descompunerea rapidă de către enzime. Semax nu are activitatea hormonală a ACTH.

A fost dezvoltat la Institutul de Genetică Moleculară al Academiei de Științe a Rusiei împreună cu Universitatea de Stat din Moscova. În Rusia este înregistrat ca medicament sub formă de picături nazale și se folosește în neurologie, inclusiv după accident vascular cerebral. Semax crește în creier nivelul factorului neurotrofic BDNF, care susține supraviețuirea și funcționarea neuronilor.

Proprietăți principale:
• îmbunătățește memoria, atenția și capacitatea de învățare;
• crește performanța mentală și fizică;
• protejează creierul în hipoxie, accident vascular cerebral și stres;
• reduce anxietatea și oboseala;
• accelerează refacerea după stres și traumatisme ale sistemului nervos.$t$::text))
where slug = $t$semax$t$;

update public.products set
  description = $t$Окситоцин — пептидный гормон из 9 аминокислот (Cys-Tyr-Ile-Gln-Asn-Cys-Pro-Leu-Gly-NH2). Вырабатывается в гипоталамусе и выделяется задней долей гипофиза; в медицине давно применяется в акушерстве.

Как нейропептид окситоцин помогает укреплять социальные связи, повышая доверие и эмпатию. Он снижает тревожность и стресс, уменьшает излишнее эмоциональное напряжение, улучшает восприятие эмоций и реакцию на социальные сигналы. Окситоцин влияет на системы мозга, связанные с мотивацией и эмоциональными реакциями, а также участвует в регуляции аппетита и снижает тягу к еде.

Направления применения:
• трудности в социальных связях и проблемы с доверием;
• повышенная тревожность и стрессовые состояния;
• эмоциональная отстранённость и сниженная эмпатия;
• нарушения пищевого поведения — в составе комплексной терапии.$t$,
  translations = translations || jsonb_build_object(
    'en', coalesce(translations -> 'en', '{}'::jsonb) || jsonb_build_object('description', $t$Oxytocin is a peptide hormone of 9 amino acids (Cys-Tyr-Ile-Gln-Asn-Cys-Pro-Leu-Gly-NH2). It is produced in the hypothalamus and released by the posterior pituitary gland; in medicine it has long been used in obstetrics.

As a neuropeptide, oxytocin helps strengthen social bonds by increasing trust and empathy. It reduces anxiety and stress, eases excessive emotional tension and improves the perception of emotions and the response to social cues. Oxytocin affects brain systems related to motivation and emotional reactions, and also helps regulate appetite and reduces food cravings.

Areas of use:
• difficulties with social bonds and trust;
• heightened anxiety and stress;
• emotional detachment and reduced empathy;
• eating disorders — as part of comprehensive therapy.$t$::text),
    'ro', coalesce(translations -> 'ro', '{}'::jsonb) || jsonb_build_object('description', $t$Oxitocina este un hormon peptidic din 9 aminoacizi (Cys-Tyr-Ile-Gln-Asn-Cys-Pro-Leu-Gly-NH2). Este produsă în hipotalamus și eliberată de lobul posterior al hipofizei; în medicină se folosește de mult timp în obstetrică.

Ca neuropeptidă, oxitocina ajută la consolidarea legăturilor sociale, crescând încrederea și empatia. Reduce anxietatea și stresul, diminuează tensiunea emoțională excesivă și îmbunătățește perceperea emoțiilor și reacția la semnalele sociale. Oxitocina influențează sistemele creierului legate de motivație și reacțiile emoționale și participă la reglarea apetitului, reducând pofta de mâncare.

Direcții de utilizare:
• dificultăți în legăturile sociale și probleme de încredere;
• anxietate crescută și stări de stres;
• detașare emoțională și empatie redusă;
• tulburări de comportament alimentar — în cadrul unei terapii complexe.$t$::text))
where slug = $t$oxytocin$t$;

-- Проверка: должно быть 12 строк
select slug, left(description, 50) from public.products where slug in ('epitalon', 'glow', 'mots-c', 'ss-31', 'ipamorelin', 'prostamax', 'ghk-cu', '5-amino-1mq', 'cagrilintide', 'nad-plus', 'semax', 'oxytocin');