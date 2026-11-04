import { qrInfo, QR_SIZE_MM } from '@/lib/qr'
import { btn } from '../ui'

/** QR-код для этикетки: превью и скачивание PNG/SVG (серверный компонент, файлы отдаёт /admin/qr/[slug]) */
export function QrPanel({ slug }: { slug: string }) {
  const info = qrInfo(slug)
  const src = `/admin/qr/${slug}`

  return (
    <div className="space-y-4 text-sm">
      <div className="flex items-start gap-4">
        {/* eslint-disable-next-line @next/next/no-img-element -- картинка из админского маршрута, без оптимизации */}
        <img src={`${src}?format=svg`} alt="QR-код товара" width={112} height={112} className="shrink-0 rounded-md ring-1 ring-line" />
        <div className="min-w-0 space-y-1 text-mute">
          <p>
            Размер на этикетке — <b className="text-ink">{QR_SIZE_MM}×{QR_SIZE_MM} мм</b>, вместе с белым полем.
          </p>
          <p>
            {info.modules}×{info.modules} модулей, модуль ≈ {info.moduleMm.toFixed(2).replace('.', ',')} мм
          </p>
          <p className="font-mono text-xs break-all text-ink-2">{info.link}</p>
        </div>
      </div>

      <div className="flex flex-wrap gap-2">
        <a href={`${src}?format=png&download=1`} className={btn.smallPrimary}>
          Скачать PNG
        </a>
        <a href={`${src}?format=svg&download=1`} className={btn.small}>
          Скачать SVG
        </a>
      </div>

      <p className="text-xs leading-relaxed text-mute">
        PNG — 1320×1320 px, чёрно-белый, в файле уже записан размер 10×10 мм: вставляйте без масштабирования. SVG — вектор,
        самый чёткий вариант, если программа этикеток его принимает. JPG не подходит: он размывает края модулей. Оставьте
        вокруг кода хотя бы 1 мм пустого места без текста. Код ведёт на страницу товара и не изменится, пока не меняется адрес
        (slug) товара и домен сайта.
      </p>
    </div>
  )
}
