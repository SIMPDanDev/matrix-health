'use client'

import Link from 'next/link'
import { startTransition, useActionState } from 'react'
import { requestProduct } from '@/app/[lang]/product/[slug]/actions'
import type { RequestState } from '@/app/[lang]/consultation/actions'
import { useI18n } from '@/i18n/client'
import { CONTACT_METHODS } from '@/lib/constants'
import { IconCheck } from './icons'
import { btn, input, label } from './ui'

/** Режим витрины: вместо цены и кнопки «В корзину» — «Сообщить о старте продаж» */
export function ShowcaseBox({ productId, hours }: { productId: string; hours: string | null }) {
  const { t, path, fmt, lang } = useI18n()
  const s = t.showcase
  const c = t.consultation
  const [state, submit, pending] = useActionState(requestProduct, {} as RequestState)

  if (state.ok) {
    return (
      <div role="status" className="rounded-3xl bg-meadow p-5 sm:p-6">
        <span className="flex size-10 items-center justify-center rounded-full bg-sage text-white">
          <IconCheck size={20} strokeWidth={2.4} />
        </span>
        <p className="mt-4 text-xl font-bold tracking-[-0.02em]">{s.successTitle}</p>
        <p className="mt-1.5 leading-relaxed text-ink-2">{fmt(s.successText, { hours: hours ? ` (${hours})` : '' })}</p>
      </div>
    )
  }

  const err = Object.fromEntries(Object.entries(state.fields ?? {}).map(([k, code]) => [k, c.errors[code]])) as Partial<Record<string, string>>

  return (
    <div className="rounded-3xl border border-line bg-surface p-5 sm:p-6">
      <p className="text-2xl font-semibold tracking-[-0.02em]">{s.title}</p>
      <p className="mt-2 leading-relaxed text-ink-2">{s.text}</p>

      <form
        noValidate
        onSubmit={(e) => {
          // Отправляем вручную, чтобы при ошибке введённые данные не сбрасывались
          e.preventDefault()
          const fd = new FormData(e.currentTarget)
          startTransition(() => submit(fd))
        }}
        className="mt-5 space-y-4"
      >
        <input type="hidden" name="lang" value={lang} />
        <input type="hidden" name="product_id" value={productId} />
        <input type="text" name="website" tabIndex={-1} autoComplete="off" className="hidden" aria-hidden="true" />

        <div className="grid gap-3 sm:grid-cols-2">
          <label className="block">
            <span className={label}>{c.name}</span>
            <input name="customer_name" autoComplete="name" className={input} aria-invalid={!!err.customer_name} />
            {err.customer_name && <span className="mt-1.5 block text-sm text-signal">{err.customer_name}</span>}
          </label>
          <label className="block">
            <span className={label}>{c.phone}</span>
            <input name="phone" type="tel" inputMode="tel" autoComplete="tel" placeholder="+373" className={input} aria-invalid={!!err.phone} />
            {err.phone && <span className="mt-1.5 block text-sm text-signal">{err.phone}</span>}
          </label>
        </div>

        <fieldset>
          <legend className={label}>{c.contactMethod}</legend>
          <div className="flex flex-wrap gap-2">
            {CONTACT_METHODS.map((m, i) => (
              <label key={m} className="cursor-pointer">
                <input type="radio" name="contact_method" value={m} defaultChecked={i === 0} className="peer sr-only" />
                <span className="flex h-10 items-center rounded-full border border-line-strong px-4 text-sm font-medium text-ink-2 transition-colors peer-checked:border-brand peer-checked:bg-brand-soft peer-checked:text-brand-dark peer-focus-visible:ring-4 peer-focus-visible:ring-brand/15 hover:border-ink">
                  {c.contactMethods[m]}
                </span>
              </label>
            ))}
          </div>
        </fieldset>

        {state.error && (
          <p role="alert" className="rounded-2xl bg-signal-soft px-3 py-2.5 text-sm text-signal">
            {state.error === 'unavailable' ? s.unavailable : c.errors[state.error]}
          </p>
        )}

        <button type="submit" disabled={pending} className={`${btn.primary} w-full`}>
          {pending ? c.sending : s.submit}
        </button>
        <p className="text-xs leading-relaxed text-mute">
          {c.consent}{' '}
          <Link href={path('/privacy')} className="underline underline-offset-2">
            {t.checkout.consentLink}
          </Link>
          .
        </p>
      </form>
    </div>
  )
}
