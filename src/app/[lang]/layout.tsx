import type { Metadata, Viewport } from 'next'
import { JsonLd } from '@/components/json-ld'
import { SiteFooter } from '@/components/site-footer'
import { SiteHeader } from '@/components/site-header'
import { I18nProvider } from '@/i18n/client'
import { LOCALES, type Lang } from '@/i18n/config'
import { DICTIONARIES } from '@/i18n/dictionaries'
import { getI18n } from '@/i18n/server'
import { getSettings } from '@/lib/data'
import { localizeSettings } from '@/lib/localize'
import type { Settings } from '@/lib/types'
import { OG_IMAGE, SITE_URL, absoluteUrl } from '@/lib/seo'
import { isSupabaseConfigured } from '@/lib/supabase/env'
import { fontVariables } from '../fonts'
import '../globals.css'

// Три языковые версии сайта собираются заранее: /en, /ro, /ru
export async function generateStaticParams() {
  return LOCALES.map((lang) => ({ lang }))
}

export async function generateMetadata(): Promise<Metadata> {
  const [{ lang, t }, settings] = await Promise.all([getI18n(), getSettings()])
  const s = localizeSettings(settings, lang)
  const verification = process.env.NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION
  return {
    metadataBase: new URL(SITE_URL),
    title: { default: s.store_name, template: `%s — ${s.store_name}` },
    description: s.tagline ?? t.meta.homeDescription,
    applicationName: s.store_name,
    openGraph: { type: 'website', siteName: s.store_name, images: [OG_IMAGE] },
    twitter: { card: 'summary_large_image' },
    // Подтверждение сайта в Google Search Console (метод «HTML-тег»)
    verification: verification ? { google: verification } : undefined,
  }
}

export const viewport: Viewport = {
  themeColor: '#0b2386',
}

export default async function SiteLayout({ children }: LayoutProps<'/[lang]'>) {
  const [{ lang, t }, settings] = await Promise.all([getI18n(), getSettings()])
  const s = localizeSettings(settings, lang)

  return (
    <html lang={lang} className={`${fontVariables} antialiased`}>
      <body className="min-h-dvh bg-paper font-sans text-ink selection:bg-brand selection:text-white">
        <JsonLd data={siteSchema(lang, s)} />
        <I18nProvider lang={lang} dict={DICTIONARIES[lang]}>
          <div className="flex min-h-dvh flex-col overflow-x-clip">
            {!isSupabaseConfigured && <p className="bg-signal px-4 py-2 text-center text-sm text-white">{t.banner.notConnected}</p>}
            <SiteHeader />
            <main className="flex-1">{children}</main>
            <SiteFooter />
          </div>
        </I18nProvider>
      </body>
    </html>
  )
}

/** Организация и сайт — для Google: название, логотип, контакты и поиск по каталогу */
function siteSchema(lang: Lang, s: Settings) {
  const org = `${SITE_URL}/#organization`
  return {
    '@context': 'https://schema.org',
    '@graph': [
      {
        '@type': 'Organization',
        '@id': org,
        name: s.store_name,
        url: absoluteUrl(lang, '/'),
        logo: `${SITE_URL}/brand/logo.png`,
        image: `${SITE_URL}${OG_IMAGE.url}`,
        description: s.tagline ?? undefined,
        telephone: s.phone ?? undefined,
        email: s.email ?? undefined,
        address: s.address ? { '@type': 'PostalAddress', streetAddress: s.address, addressCountry: 'MD' } : undefined,
        areaServed: { '@type': 'Country', name: 'Moldova' },
      },
      {
        '@type': 'WebSite',
        '@id': `${SITE_URL}/#website-${lang}`,
        url: absoluteUrl(lang, '/'),
        name: s.store_name,
        inLanguage: lang,
        publisher: { '@id': org },
        potentialAction: {
          '@type': 'SearchAction',
          target: { '@type': 'EntryPoint', urlTemplate: `${absoluteUrl(lang, '/catalog')}?q={search_term_string}` },
          'query-input': 'required name=search_term_string',
        },
      },
    ],
  }
}
