import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'
import { DEFAULT_LANG, LANG_COOKIE, hasLocale, localePath, matchLanguage, stripLocale } from '@/i18n/config'
import { SUPABASE_KEY, SUPABASE_URL, isSupabaseConfigured } from '@/lib/supabase/env'

// Адреса: английский без префикса (/catalog), румынский и русский — /ro/catalog, /ru/catalog.
// Страницы лежат в app/[lang], поэтому английский адрес незаметно подменяется (rewrite): /catalog → /en/catalog.
// У каждого языка свой адрес — так Google видит и индексирует все три версии.

// Поисковые роботы всегда получают страницу по адресу как есть, без перенаправлений по языку
const BOT = /bot|crawl|spider|slurp|facebookexternalhit|embedly|preview|lighthouse|chrome-lighthouse/i

export async function proxy(request: NextRequest) {
  const { pathname, search } = request.nextUrl
  if (pathname === '/admin' || pathname.startsWith('/admin/')) return protectAdmin(request)

  const first = pathname.split('/')[1]

  // /en/... — дубль английской версии: навсегда ведём на адрес без префикса
  if (first === DEFAULT_LANG) {
    const url = request.nextUrl.clone()
    url.pathname = stripLocale(pathname)
    return NextResponse.redirect(url, 308)
  }

  // /ro/..., /ru/... — страница на этом языке как есть
  if (hasLocale(first)) return NextResponse.next()

  // Адрес без префикса. Посетителя, который выбрал другой язык (cookie), ведём на его версию.
  // Язык браузера учитываем только на главной — остальные адреса открываются как есть,
  // нужный язык из поиска подскажет Google по hreflang.
  if (!BOT.test(request.headers.get('user-agent') ?? '')) {
    const saved = request.cookies.get(LANG_COOKIE)?.value
    const lang = hasLocale(saved) ? saved : pathname === '/' ? matchLanguage(request.headers.get('accept-language')) : null
    if (lang && lang !== DEFAULT_LANG) {
      const url = request.nextUrl.clone()
      url.pathname = localePath(lang, pathname)
      url.search = search
      return NextResponse.redirect(url) // 307: зависит от посетителя, браузер не запоминает
    }
  }

  const url = request.nextUrl.clone()
  url.pathname = `/${DEFAULT_LANG}${pathname === '/' ? '' : pathname}`
  return NextResponse.rewrite(url)
}

// Обновляет сессию Supabase и не пускает в админку без входа.
// Права администратора дополнительно проверяются на сервере (lib/admin/auth.ts).
async function protectAdmin(request: NextRequest) {
  const isLogin = request.nextUrl.pathname.startsWith('/admin/login')

  if (!isSupabaseConfigured) {
    return isLogin ? NextResponse.next() : NextResponse.redirect(new URL('/admin/login', request.url))
  }

  let response = NextResponse.next({ request })

  const supabase = createServerClient(SUPABASE_URL, SUPABASE_KEY, {
    cookies: {
      getAll() {
        return request.cookies.getAll()
      },
      setAll(list, headers) {
        list.forEach(({ name, value }) => request.cookies.set(name, value))
        response = NextResponse.next({ request })
        list.forEach(({ name, value, options }) => response.cookies.set(name, value, options))
        Object.entries(headers ?? {}).forEach(([key, value]) => response.headers.set(key, value))
      },
    },
  })

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user && !isLogin) {
    const url = new URL('/admin/login', request.url)
    url.searchParams.set('next', request.nextUrl.pathname)
    return NextResponse.redirect(url)
  }

  return response
}

export const config = {
  // Всё, кроме служебных файлов Next.js и файлов с расширением (картинки, robots.txt, icon.png)
  matcher: ['/((?!_next/|api/|.*\\..*).*)'],
}
