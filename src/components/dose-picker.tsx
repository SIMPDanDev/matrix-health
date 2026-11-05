'use client'

import { useSearchParams } from 'next/navigation'
import { useState } from 'react'
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
