import { getCatalog } from '@/lib/data'
import { docNames, isOurFile } from '@/lib/doc-links'

/**
 * Документ партии со своего домена: /docs/GLOW-COA-SP-0113.pdf.
 * Ищем опубликованный документ с таким именем и отдаём его файл из Supabase Storage.
 * Адрес на сайте — короткий и понятный, файл при скачивании сохраняется под тем же именем.
 */
export async function GET(_request: Request, { params }: { params: Promise<{ file: string }> }) {
  const { file } = await params
  const wanted = decodeURIComponent(file).toUpperCase()

  const { certificates } = await getCatalog()
  const names = docNames(certificates)
  const cert = certificates.find((c) => names.get(c.id)?.toUpperCase() === wanted)
  if (!cert || !isOurFile(cert.file_url)) return new Response('Документ не найден', { status: 404 })

  const upstream = await fetch(cert.file_url)
  if (!upstream.ok || !upstream.body) return new Response('Документ временно недоступен', { status: 502 })

  const name = names.get(cert.id) as string
  const headers = new Headers({
    'Content-Type': upstream.headers.get('content-type') ?? 'application/octet-stream',
    // inline — открывается в браузере; при скачивании сохранится под этим именем
    'Content-Disposition': `inline; filename="${name}"`,
    // Браузер — 5 минут, CDN Vercel — 10 минут: заменили файл в админке — новый появится так же быстро, как каталог
    'Cache-Control': 'public, max-age=300, s-maxage=600',
  })
  const length = upstream.headers.get('content-length')
  if (length) headers.set('Content-Length', length)

  return new Response(upstream.body, { headers })
}
