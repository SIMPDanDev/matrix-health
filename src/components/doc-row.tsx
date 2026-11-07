import { getI18n } from '@/i18n/server'
import type { Certificate } from '@/lib/types'
import { DocPreview } from './doc-preview'
import { IconDownload } from './icons'

/**
 * doses — названия дозировок, к которым относится документ (пусто — для всех);
 * href — адрес файла на нашем домене (/docs/GLOW-COA-SP-0113.pdf, см. lib/doc-links.ts)
 */
export async function DocRow({ cert, doses = [], href }: { cert: Certificate; doses?: string[]; href: string | null }) {
  const { t, date } = await getI18n()

  return (
    <li className="grid grid-cols-[64px_1fr] items-center gap-x-4 gap-y-3 border-b border-line py-4 sm:grid-cols-[64px_1fr_auto_auto_auto] sm:gap-x-6">
      {/* Миниатюра первой страницы — по нажатию документ открывается целиком */}
      <span className="row-span-4 self-start sm:row-span-1 sm:self-center">
        <DocPreview url={href} title={cert.title} />
      </span>
      <div className="min-w-0">
        <p className="font-medium">
          {cert.title} <span className="text-mute">· {t.docTypes[cert.doc_type] ?? cert.doc_type}</span>
        </p>
        <p className="mt-0.5 truncate text-sm text-mute">
          {cert.lab ?? '—'}
          {doses.length > 0 && <span className="text-ink-2"> · {doses.join(', ')}</span>}
        </p>
      </div>
      <span className="col-start-2 font-mono text-sm text-ink-2 sm:col-start-auto">
        {cert.batch ? `LOT ${cert.batch}` : t.product.noBatch}
      </span>
      <span className="col-start-2 font-mono text-sm text-mute sm:col-start-auto">{date(cert.issued_at)}</span>
      <div className="col-start-2 sm:col-start-auto">
        {href ? (
          <a
            href={href}
            target="_blank"
            rel="noreferrer"
            className="inline-flex h-10 items-center gap-2 rounded-full border border-line-strong px-3.5 text-sm font-medium hover:border-ink"
          >
            <IconDownload size={16} /> PDF
          </a>
        ) : (
          <span className="text-sm text-mute">{t.product.fileOnRequest}</span>
        )}
      </div>
    </li>
  )
}
