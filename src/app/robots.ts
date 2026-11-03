import type { MetadataRoute } from 'next'
import { LOCALES, localePath } from '@/i18n/config'
import { SITE_URL } from '@/lib/seo'

// Поисковикам закрыты админка, корзина (запрос цены) и оформление заказа — на всех языках
export default function robots(): MetadataRoute.Robots {
  const closed = LOCALES.flatMap((l) => [localePath(l, '/cart'), localePath(l, '/checkout')])
  return {
    rules: { userAgent: '*', allow: '/', disallow: ['/admin', ...closed] },
    sitemap: `${SITE_URL}/sitemap.xml`,
  }
}
