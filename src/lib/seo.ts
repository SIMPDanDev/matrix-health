import type { Metadata } from 'next'
import { DEFAULT_LANG, LOCALES, localePath, type Lang } from '@/i18n/config'
import type { Product } from './types'

/**
 * Адрес сайта для canonical, hreflang, sitemap и превью в соцсетях.
 * Свой домен — переменная NEXT_PUBLIC_SITE_URL (https://example.md). Без неё на Vercel берётся
 * основной адрес проекта (health-matrix.vercel.app), локально — localhost.
 */
export const SITE_URL = (
  process.env.NEXT_PUBLIC_SITE_URL ||
  (process.env.VERCEL_PROJECT_PRODUCTION_URL ? `https://${process.env.VERCEL_PROJECT_PRODUCTION_URL}` : 'http://localhost:3000')
).replace(/\/+$/, '')

/** Картинка для превью ссылки, если у страницы нет своей (public/og.png, 1200×630) */
export const OG_IMAGE = { url: '/og.png', width: 1200, height: 630 }

const OG_LOCALE: Record<Lang, string> = { en: 'en_US', ro: 'ro_MD', ru: 'ru_MD' }

/** Полный адрес: absoluteUrl('ro', '/catalog') → 'https://…/ro/catalog' */
export function absoluteUrl(lang: Lang, path: string) {
  return `${SITE_URL}${localePath(lang, path)}`
}

/** Все языковые версии страницы — для hreflang. x-default — английская версия без префикса */
export function languageAlternates(path: string) {
  return {
    ...Object.fromEntries(LOCALES.map((l) => [l, localePath(l, path)])),
    'x-default': localePath(DEFAULT_LANG, path),
  }
}

/**
 * Метаданные страницы: заголовок, описание, canonical, hreflang и превью для соцсетей.
 * path — адрес без языка ('/catalog'), он одинаковый у всех языковых версий.
 */
export function pageMeta(
  lang: Lang,
  path: string,
  m: {
    title: string | { absolute: string }
    description?: string | null
    siteName: string
    image?: string | null
    type?: 'website' | 'article'
  },
): Metadata {
  const title = typeof m.title === 'string' ? m.title : m.title.absolute
  const description = m.description?.trim() || undefined
  const images = m.image ? [{ url: m.image, alt: title }] : [{ ...OG_IMAGE, alt: m.siteName }]

  return {
    title: m.title,
    description,
    alternates: { canonical: localePath(lang, path), languages: languageAlternates(path) },
    openGraph: {
      type: m.type ?? 'website',
      url: localePath(lang, path),
      siteName: m.siteName,
      title,
      description,
      locale: OG_LOCALE[lang],
      alternateLocale: LOCALES.filter((l) => l !== lang).map((l) => OG_LOCALE[l]),
      images,
    },
    twitter: { card: 'summary_large_image', title, description, images: images.map((i) => i.url) },
  }
}

/** Короткое описание из длинного текста — для meta description (до ~160 знаков, по границе слова) */
export function snippet(text: string | null | undefined, max = 160) {
  const clean = (text ?? '').replace(/\s+/g, ' ').trim()
  if (clean.length <= max) return clean || null
  const cut = clean.slice(0, max - 1)
  return `${cut.slice(0, cut.lastIndexOf(' ') > 80 ? cut.lastIndexOf(' ') : cut.length)}…`
}

/** «Хлебные крошки» для Google: путь страницы над её адресом в результатах поиска */
export function breadcrumbSchema(lang: Lang, items: { name: string; path: string }[]) {
  return {
    '@context': 'https://schema.org',
    '@type': 'BreadcrumbList',
    itemListElement: items.map((item, i) => ({ '@type': 'ListItem', position: i + 1, name: item.name, item: absoluteUrl(lang, item.path) })),
  }
}

/** Товар для Google: название, фото, описание и цена с наличием (Product + Offer) */
export function productSchema(lang: Lang, p: Product, brand: string) {
  const prices = p.variants.length ? p.variants.map((v) => v.price) : [p.price]
  const available = p.variants.length ? p.variants.some((v) => v.stock > 0) : p.stock > 0
  const url = absoluteUrl(lang, `/product/${p.slug}`)
  const availability = `https://schema.org/${available ? 'InStock' : 'OutOfStock'}`

  return {
    '@context': 'https://schema.org',
    '@type': 'Product',
    name: p.name,
    url,
    image: p.images.length ? p.images : [`${SITE_URL}${OG_IMAGE.url}`],
    description: snippet(p.short_description ?? p.description, 500) ?? undefined,
    sku: p.sku ?? undefined,
    category: p.category?.name,
    brand: { '@type': 'Brand', name: brand },
    offers:
      prices.length > 1
        ? {
            '@type': 'AggregateOffer',
            priceCurrency: 'EUR',
            lowPrice: Math.min(...prices),
            highPrice: Math.max(...prices),
            offerCount: prices.length,
            availability,
            url,
          }
        : { '@type': 'Offer', priceCurrency: 'EUR', price: prices[0], availability, url },
  }
}
