import type { Metadata } from 'next'
import { PageHead } from '@/components/page-head'
import { wrap } from '@/components/ui'
import { getI18n } from '@/i18n/server'
import { getShop, shopMeta } from '@/lib/shop'

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await getI18n()
  return shopMeta('/privacy', { title: t.meta.privacy, description: t.meta.privacyDescription })
}

// Сайт Национального центра по защите персональных данных — в тексте политики становится ссылкой
const AUTHORITY = 'datepersonale.md'

export default async function PrivacyPage() {
  const { i18n, settings: s } = await getShop()
  const { t, fmt } = i18n
  const p = t.privacy

  const vars = {
    store: s.store_name,
    email: s.email ?? p.ourEmail,
    phone: s.phone ? fmt(p.phoneSuffix, { phone: s.phone }) : '',
  }

  // Информационный сайт: только заявки на консультацию — без заказов, доставки, почты и телефона
  const sections = s.sales_enabled ? p.sections : p.sectionsInfo

  return (
    <div className={`${wrap} pt-6 lg:pt-8`}>
      <PageHead wide crumb={t.meta.privacy} title={t.meta.privacy} lead={fmt(p.lead, { store: s.store_name })} />
      {/* Разделы на всю ширину: слева номер и заголовок, справа текст */}
      <div className="py-14">
        {sections.map((section, i) => (
          <section
            key={section.title}
            className="grid gap-3 border-b border-line py-8 first:pt-0 lg:grid-cols-[minmax(0,1fr)_minmax(0,2.2fr)] lg:gap-16"
          >
            <div className="flex items-start gap-4">
              <span className="flex size-9 shrink-0 items-center justify-center rounded-full bg-brand-soft text-sm font-bold text-brand">{i + 1}</span>
              <h2 className="pt-1 text-xl font-semibold tracking-[-0.01em]">{section.title}</h2>
            </div>
            <div className="space-y-3 text-[17px] leading-relaxed text-ink-2 lg:pt-1">{paragraphs(fmt(section.text, vars))}</div>
          </section>
        ))}
      </div>
    </div>
  )
}

/** Текст раздела: строки — абзацы, строки с «• » подряд — список */
function paragraphs(text: string) {
  const blocks: (string | string[])[] = []
  for (const line of text.split('\n')) {
    if (line.startsWith('• ')) {
      const last = blocks.at(-1)
      if (Array.isArray(last)) last.push(line.slice(2))
      else blocks.push([line.slice(2)])
    } else blocks.push(line)
  }
  return blocks.map((b, i) =>
    Array.isArray(b) ? (
      <ul key={i} className="list-disc space-y-1 pl-5 marker:text-brand">
        {b.map((item) => (
          <li key={item}>{item}</li>
        ))}
      </ul>
    ) : (
      <p key={i}>{linkify(b)}</p>
    ),
  )
}

function linkify(text: string) {
  const at = text.indexOf(AUTHORITY)
  if (at < 0) return text
  return (
    <>
      {text.slice(0, at)}
      <a href={`https://${AUTHORITY}`} target="_blank" rel="noopener noreferrer" className="font-medium text-brand hover:underline">
        {AUTHORITY}
      </a>
      {text.slice(at + AUTHORITY.length)}
    </>
  )
}
