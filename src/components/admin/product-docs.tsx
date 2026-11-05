import Link from 'next/link'
import { doseLabels } from '@/lib/variants'
import type { Certificate, Variant } from '@/lib/types'
import { IconFile, IconPlus } from '../icons'
import { btn } from '../ui'

type Doc = Pick<Certificate, 'id' | 'title' | 'doc_type' | 'batch' | 'issued_at' | 'is_published' | 'file_url' | 'variant_ids'>

/** Документы товара в его карточке в админке: список и кнопка «Добавить сертификат» (товар в форме уже выбран) */
export function ProductDocs({ productId, docs, variants }: { productId: string; docs: Doc[]; variants: Pick<Variant, 'id' | 'label' | 'sort'>[] }) {
  return (
    <div className="space-y-3 text-sm">
      {docs.length ? (
        <ul className="divide-y divide-line rounded-lg border border-line">
          {docs.map((d) => {
            const doses = doseLabels(d.variant_ids, variants)
            return (
              <li key={d.id}>
                <Link href={`/admin/certificates/${d.id}?back=product`} className="flex items-start gap-3 p-3 hover:bg-sand">
                  <IconFile size={18} className="mt-0.5 shrink-0 text-brand" />
                  <span className="min-w-0 flex-1">
                    <span className="block font-medium">
                      {d.title} <span className="font-normal text-mute">· {d.doc_type}</span>
                    </span>
                    <span className="mt-0.5 block text-xs text-mute">
                      {d.batch ? `LOT ${d.batch}` : 'Без партии'}
                      {variants.length > 0 && ` · ${doses.length ? doses.join(', ') : 'все дозировки'}`}
                      {!d.file_url && ' · без файла'}
                      {!d.is_published && ' · скрыт'}
                    </span>
                  </span>
                </Link>
              </li>
            )
          })}
        </ul>
      ) : (
        <p className="text-mute">Документов пока нет. На сайте будет «Документы к этой партии скоро появятся».</p>
      )}
      <Link href={`/admin/certificates/new?product=${productId}`} className={btn.small}>
        <IconPlus size={16} /> Добавить сертификат
      </Link>
    </div>
  )
}
