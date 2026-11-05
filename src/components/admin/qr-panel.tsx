import { qrInfo, qrLink, QR_SIZE_MM } from '@/lib/qr'
import { variantCodes } from '@/lib/variants'
import type { Variant } from '@/lib/types'
import { btn } from '../ui'

/**
 * QR-коды для этикеток: на каждую дозировку свой (ведёт на товар с уже выбранной дозировкой)
 * и общий — на товар без дозировки. Файлы отдаёт /admin/qr/[slug]. Серверный компонент.
 */
export function QrPanel({ slug, variants }: { slug: string; variants: Pick<Variant, 'id' | 'label'>[] }) {
  const codes = variantCodes(variants)
  const items = [
    ...variants.map((v) => ({ key: v.id, title: v.label, query: `variant=${v.id}`, link: qrLink(slug, codes[v.id]) })),
    { key: 'product', title: variants.length ? 'Без дозировки' : 'Товар', query: '', link: qrLink(slug) },
  ]
  const info = qrInfo(items[0].link)

  return (
    <div className="space-y-4 text-sm">
      <ul className="space-y-3">
        {items.map((it) => {
          const src = `/admin/qr/${slug}?${it.query ? `${it.query}&` : ''}`
          return (
            <li key={it.key} className="flex items-start gap-3 rounded-lg border border-line p-3">
              {/* eslint-disable-next-line @next/next/no-img-element -- картинка из админского маршрута, без оптимизации */}
              <img src={`${src}format=svg`} alt={`QR-код: ${it.title}`} width={72} height={72} className="shrink-0 rounded ring-1 ring-line" />
              <div className="min-w-0 flex-1">
                <p className="font-semibold">{it.title}</p>
                <p className="mt-0.5 font-mono text-[11px] break-all text-mute">{it.link}</p>
                <div className="mt-2 flex flex-wrap gap-2">
                  <a href={`${src}format=png&download=1`} className={btn.smallPrimary}>
                    PNG
                  </a>
                  <a href={`${src}format=svg&download=1`} className={btn.small}>
                    SVG
                  </a>
                </div>
              </div>
            </li>
          )
        })}
      </ul>

      <p className="text-xs leading-relaxed text-mute">
        Размер на этикетке — {QR_SIZE_MM}×{QR_SIZE_MM} мм вместе с белым полем, {info.modules}×{info.modules} модулей (модуль ≈{' '}
        {info.moduleMm.toFixed(2).replace('.', ',')} мм). PNG — 1320×1320 px, чёрно-белый, размер 10×10 мм уже записан в файле:
        вставляйте без масштабирования. SVG — вектор, самый чёткий вариант. Оставьте вокруг кода хотя бы 1 мм пустого места.
        QR дозировки зависит от её названия: переименуете «10 mg» — напечатанный код откроет товар без выбранной дозировки.
      </p>
    </div>
  )
}
