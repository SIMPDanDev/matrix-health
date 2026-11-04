import type { NextRequest } from 'next/server'
import { requireAdmin } from '@/lib/admin/auth'
import { qrPng, qrSvg } from '@/lib/qr'

/**
 * QR-код товара для этикетки: /admin/qr/selank?format=png|svg[&download=1]
 * Только для администраторов. Код ведёт на короткую ссылку /P/SELANK (см. lib/qr.ts и proxy.ts).
 */
export async function GET(request: NextRequest, { params }: { params: Promise<{ slug: string }> }) {
  const { sb } = await requireAdmin()
  const { slug } = await params

  const { data: product } = await sb.from('products').select('slug, sku').eq('slug', slug).maybeSingle()
  if (!product) return new Response('Товар не найден', { status: 404 })

  const svg = request.nextUrl.searchParams.get('format') === 'svg'
  const name = `qr-${(product.sku || product.slug).replace(/[^A-Za-z0-9-]/g, '-')}.${svg ? 'svg' : 'png'}`
  const body = svg ? qrSvg(product.slug) : new Uint8Array(qrPng(product.slug))

  return new Response(body, {
    headers: {
      'Content-Type': svg ? 'image/svg+xml' : 'image/png',
      'Content-Disposition': `${request.nextUrl.searchParams.has('download') ? 'attachment' : 'inline'}; filename="${name}"`,
      'Cache-Control': 'private, no-store',
    },
  })
}
