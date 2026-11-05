import type { NextRequest } from 'next/server'
import { requireAdmin } from '@/lib/admin/auth'
import { qrLink, qrPng, qrSvg } from '@/lib/qr'
import { variantCodes } from '@/lib/variants'

/**
 * QR-код товара для этикетки: /admin/qr/selank?format=png|svg[&variant=<id>][&download=1]
 * Только для администраторов. Код ведёт на короткую ссылку /P/SELANK или, с дозировкой, /P/SS-31/50MG
 * (см. lib/qr.ts и proxy.ts).
 */
export async function GET(request: NextRequest, { params }: { params: Promise<{ slug: string }> }) {
  const { sb } = await requireAdmin()
  const { slug } = await params
  const search = request.nextUrl.searchParams

  const { data: product } = await sb
    .from('products')
    .select('slug, sku, variants:product_variants(id, label, sort)')
    .eq('slug', slug)
    .maybeSingle()
  if (!product) return new Response('Товар не найден', { status: 404 })

  // Дозировка: код считается по всем вариантам товара в их порядке — как на сайте
  const variants = [...(product.variants ?? [])].sort((a, b) => a.sort - b.sort)
  const variantId = search.get('variant')
  const code = variantId ? variantCodes(variants)[variantId] : null
  if (variantId && !code) return new Response('Дозировка не найдена', { status: 404 })

  const link = qrLink(product.slug, code)
  const svg = search.get('format') === 'svg'
  const base = [product.sku || product.slug, code].filter(Boolean).join('-')
  const name = `qr-${base.replace(/[^A-Za-z0-9.-]/g, '-')}.${svg ? 'svg' : 'png'}`
  const body = svg ? qrSvg(link) : new Uint8Array(qrPng(link))

  return new Response(body, {
    headers: {
      'Content-Type': svg ? 'image/svg+xml' : 'image/png',
      'Content-Disposition': `${search.has('download') ? 'attachment' : 'inline'}; filename="${name}"`,
      'Cache-Control': 'private, no-store',
    },
  })
}
