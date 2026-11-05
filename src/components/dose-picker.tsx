'use client'

import { useSearchParams } from 'next/navigation'
import { Fragment, useState, type ReactNode } from 'react'
import { useI18n } from '@/i18n/client'
import type { Product, Variant } from '@/lib/types'
import { findVariantByCode, rememberDose } from '@/lib/variants'
import { BuyBox } from './buy-box'

type Dose = Pick<Variant, 'id' | 'label'>

/** Выбор дозировки без цены — для информационного сайта */
export function DosePicker({ variants, initialId }: { variants: Dose[]; initialId?: string | null }) {
  const { t } = useI18n()
  const [selected, setSelected] = useState(initialId ?? variants[0]?.id ?? null)

  return (
    <fieldset>
      <legend className="mb-2.5 text-sm font-medium text-ink-2">{t.product.dosage}</legend>
      <div className="flex flex-wrap gap-2">
        {variants.map((v) => (
          <button
            key={v.id}
            type="button"
            onClick={() => {
              setSelected(v.id)
              rememberDose(variants, v.id)
            }}
            aria-pressed={v.id === selected}
            className={`flex h-11 items-center rounded-full border px-5 text-[15px] font-medium transition-colors ${
              v.id === selected ? 'border-ink bg-ink text-white' : 'border-line-strong hover:border-ink'
            }`}
          >
            {v.label}
          </button>
        ))}
      </div>
    </fieldset>
  )
}

/** DosePicker с дозировкой из ссылки (?dose=…). Оборачивайте в Suspense — см. useSearchParams */
export function DosePickerFromUrl({ variants }: { variants: Dose[] }) {
  const dose = useSearchParams().get('dose')
  const initial = findVariantByCode(variants, dose)
  return <DosePicker key={initial?.id ?? 'default'} variants={variants} initialId={initial?.id} />
}

/** BuyBox с дозировкой из ссылки (?dose=…). Оборачивайте в Suspense — см. useSearchParams */
export function BuyBoxFromUrl({ product }: { product: Product }) {
  const dose = useSearchParams().get('dose')
  const initial = findVariantByCode(product.variants, dose)
  return <BuyBox key={initial?.id ?? 'default'} product={product} initialVariantId={initial?.id} />
}

type DocRowItem = { key: string; variantIds: string[]; node: ReactNode }

/** Документы для выбранной дозировки: без отметки дозировок — для всех, иначе — только для отмеченных */
export function DoseDocs({ rows, selectedId, empty }: { rows: DocRowItem[]; selectedId: string | null; empty: ReactNode }) {
  const shown = rows.filter((r) => !selectedId || !r.variantIds.length || r.variantIds.includes(selectedId))
  if (!shown.length) return <>{empty}</>
  return (
    <ul className="border-t border-line-strong">
      {shown.map((r) => (
        <Fragment key={r.key}>{r.node}</Fragment>
      ))}
    </ul>
  )
}

/** DoseDocs с дозировкой из ссылки (?dose=…); без неё — дозировка по умолчанию, как у кнопок выбора. Оборачивайте в Suspense */
export function DoseDocsFromUrl({
  variants,
  defaultId,
  ...props
}: {
  rows: DocRowItem[]
  empty: ReactNode
  variants: Dose[]
  defaultId: string | null
}) {
  const dose = useSearchParams().get('dose')
  const selected = findVariantByCode(variants, dose)?.id ?? defaultId
  return <DoseDocs {...props} selectedId={selected} />
}
