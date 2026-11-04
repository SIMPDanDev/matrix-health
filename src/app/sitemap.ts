import type { MetadataRoute } from 'next'
import { LOCALES } from '@/i18n/config'
import { getCatalog, getPage, getSettings } from '@/lib/data'
import { SITE_URL, absoluteUrl, languageAlternates } from '@/lib/seo'

// Карта сайта для Google: каждая страница на трёх языках, у каждой — ссылки на остальные версии (hreflang).
// Товары и категории берутся из базы: новый товар появится в карте сам.

type Entry = { path: string; lastModified?: string; priority: number; changeFrequency: 'daily' | 'weekly' | 'monthly' | 'yearly' }

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const [{ products, categories }, peptides, settings] = await Promise.all([getCatalog(), getPage('peptides'), getSettings()])
  // На информационном сайте нет страниц «Доставка» и «Контакты»
  const sales = settings.sales_enabled
  // Пустые категории на сайте не показываются — и в карту их не кладём
  const used = categories.filter((c) => products.some((p) => p.category_id === c.id))

  const entries: Entry[] = [
    { path: '/', priority: 1, changeFrequency: 'daily' },
    { path: '/catalog', priority: 0.9, changeFrequency: 'daily' },
    ...used.map((c): Entry => ({ path: `/catalog?cat=${c.slug}`, priority: 0.8, changeFrequency: 'weekly' })),
    ...products.map((p): Entry => ({ path: `/product/${p.slug}`, lastModified: p.updated_at ?? p.created_at, priority: 0.8, changeFrequency: 'weekly' })),
    ...(peptides ? [{ path: '/peptides', lastModified: peptides.updated_at, priority: 0.7, changeFrequency: 'monthly' } as Entry] : []),
    { path: '/consultation', priority: 0.7, changeFrequency: 'monthly' },
    { path: '/certificates', priority: 0.6, changeFrequency: 'weekly' },
    ...(sales ? [{ path: '/delivery', priority: 0.5, changeFrequency: 'monthly' } as Entry] : []),
    { path: '/about', priority: 0.5, changeFrequency: 'monthly' },
    ...(sales ? [{ path: '/contacts', priority: 0.5, changeFrequency: 'monthly' } as Entry] : []),
    { path: '/privacy', priority: 0.2, changeFrequency: 'yearly' },
  ]

  const abs = (languages: Record<string, string>) => Object.fromEntries(Object.entries(languages).map(([l, p]) => [l, `${SITE_URL}${p}`]))

  return entries.flatMap((e) =>
    LOCALES.map((lang) => ({
      url: absoluteUrl(lang, e.path),
      lastModified: e.lastModified,
      changeFrequency: e.changeFrequency,
      priority: e.priority,
      alternates: { languages: abs(languageAlternates(e.path)) },
    })),
  )
}
