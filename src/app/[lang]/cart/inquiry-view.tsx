'use client'

import Link from 'next/link'
import { startTransition, useActionState, useEffect } from 'react'
import { IconCheck, IconMinus, IconPlus, IconTrash } from '@/components/icons'
import { ProductVisual } from '@/components/product-visual'
import { btn, input, label, textarea } from '@/components/ui'
import { useI18n } from '@/i18n/client'
import { cart, maxQty, useCart } from '@/lib/cart'
import { CONTACT_METHODS } from '@/lib/constants'
import { orderNo } from '@/lib/format'
import { requestPrices, type InquiryState } from './actions'

/** Режим витрины: корзина становится запросом цены — товары без цен и форма контактов */
export function InquiryView({ stock, hours }: { stock: Record<string, number>; hours: string | null }) {
  const { items } = useCart()
  const { t, path, fmt, lang } = useI18n()
  const s = t.showcase
  const c = t.consultation
  const [state, submit, pending] = useActionState(requestPrices, {} as InquiryState)

  // Подтягиваем свежие остатки: лишнее количество уменьшается до того, что есть на складе
  useEffect(() => {
    cart.syncStock(stock)
  }, [stock, items.length])

  // Запрос отправлен — список больше не нужен
  useEffect(() => {
    if (state.ok) cart.clear()
  }, [state.ok])

  if (state.ok) {
    return (
      <div role="status" className="flex flex-col items-start rounded-3xl bg-meadow p-8 sm:p-10">
        <span className="flex size-12 items-center justify-center rounded-full bg-sage text-white">
          <IconCheck size={24} strokeWidth={2.4} />
        </span>
        <p className="mt-5 text-2xl font-bold tracking-[-0.02em]">{s.successTitle}</p>
        <p className="mt-2 max-w-md leading-relaxed text-ink-2">
          {fmt(s.successText, { n: state.number ? orderNo(state.number) : '', hours: hours ? ` (${hours})` : '' })}
        </p>
        <Link href={path('/catalog')} className={`${btn.outline} mt-7 bg-white/60`}>
          {t.cart.goCatalog}
        </Link>
      </div>
    )
  }

  if (items.length === 0) {
    return (
      <div className="rounded-3xl border border-dashed border-line-strong px-6 py-20 text-center">
        <p className="text-2xl font-semibold">{s.emptyTitle}</p>
        <p className="mx-auto mt-2 max-w-sm text-ink-2">{s.emptyText}</p>
        <Link href={path('/catalog')} className={`${btn.primary} mt-8`}>
          {t.cart.goCatalog}
        </Link>
      </div>
    )
  }

  const err = Object.fromEntries(Object.entries(state.fields ?? {}).map(([k, code]) => [k, c.errors[code]])) as Partial<Record<string, string>>
  const error = state.error === 'empty' ? s.emptyError : state.error === 'unavailable' ? s.unavailable : state.error && c.errors[state.error]

  return (
    <div className="grid gap-10 lg:grid-cols-[1fr_420px] lg:gap-14">
      <div>
        <ul className="border-t border-line-strong">
          {items.map((l) => (
            <li key={l.key} className="grid grid-cols-[80px_1fr] gap-4 border-b border-line py-5 sm:grid-cols-[96px_1fr] sm:gap-6">
              <Link href={path(`/product/${l.slug}`)} className="relative flex aspect-square items-center justify-center overflow-hidden rounded-2xl bg-brand-soft">
                <ProductVisual form={l.form} image={l.image} alt={l.name} name={l.name} pack={l.pack} tone={l.tone} size="sm" sizes="96px" />
              </Link>

              <div className="min-w-0">
                <Link href={path(`/product/${l.slug}`)} className="font-medium hover:text-brand">
                  {l.name}
                </Link>
                {l.variantLabel && <p className="mt-0.5 text-sm text-mute">{l.variantLabel}</p>}

                <div className="mt-3 flex items-center gap-3">
                  <div className="flex h-10 items-center rounded-full border border-line-strong">
                    <button
                      type="button"
                      onClick={() => cart.setQty(l.key, l.qty - 1)}
                      disabled={l.qty <= 1}
                      aria-label={t.cart.less}
                      className="flex h-full w-9 items-center justify-center disabled:text-line-strong"
                    >
                      <IconMinus size={14} />
                    </button>
                    <span className="min-w-7 text-center font-semibold tabular-nums">{l.qty}</span>
                    <button
                      type="button"
                      onClick={() => cart.setQty(l.key, l.qty + 1)}
                      disabled={l.qty >= maxQty(l)}
                      aria-label={t.cart.more}
                      className="flex h-full w-9 items-center justify-center disabled:text-line-strong"
                    >
                      <IconPlus size={14} />
                    </button>
                  </div>
                  <button
                    type="button"
                    onClick={() => cart.remove(l.key)}
                    className="flex h-10 items-center gap-1.5 rounded-full px-2 text-sm text-mute hover:bg-sand hover:text-signal"
                  >
                    <IconTrash size={16} /> <span className="hidden sm:inline">{t.cart.remove}</span>
                  </button>
                </div>
                {l.qty >= maxQty(l) && l.stock !== undefined && maxQty(l) > 0 && (
                  <p className="mt-2 text-sm text-mute">{fmt(t.cart.stockLimit, { n: maxQty(l) })}</p>
                )}
              </div>
            </li>
          ))}
        </ul>

        <div className="mt-4 flex flex-wrap gap-x-6 gap-y-2 text-sm">
          <Link href={path('/catalog')} className="text-ink-2 underline underline-offset-4 hover:text-ink">
            {t.cart.continue}
          </Link>
          <button type="button" onClick={() => cart.clear()} className="text-mute underline underline-offset-4 hover:text-ink">
            {s.clear}
          </button>
        </div>
      </div>

      <aside className="h-fit rounded-3xl border border-line bg-surface p-6 lg:sticky lg:top-32">
        <h2 className="text-xl font-semibold tracking-[-0.02em]">{s.formTitle}</h2>
        <p className="mt-1.5 text-[15px] leading-relaxed text-ink-2">{s.formLead}</p>
        {hours && <p className="mt-1 text-sm text-mute">{hours}</p>}

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
          <input
            type="hidden"
            name="items"
            value={JSON.stringify(items.map((l) => ({ product_id: l.productId, variant_id: l.variantId, qty: l.qty })))}
          />
          <input type="text" name="website" tabIndex={-1} autoComplete="off" className="hidden" aria-hidden="true" />

          <Field label={c.name} error={err.customer_name}>
            <input name="customer_name" autoComplete="name" className={input} aria-invalid={!!err.customer_name} />
          </Field>
          <Field label={c.phone} error={err.phone}>
            <input name="phone" type="tel" inputMode="tel" autoComplete="tel" placeholder="+373" className={input} aria-invalid={!!err.phone} />
          </Field>

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

          <Field label={s.comment}>
            <textarea name="comment" rows={3} placeholder={s.commentPlaceholder} className={textarea} />
          </Field>

          {error && (
            <p role="alert" className="rounded-2xl bg-signal-soft px-3 py-2.5 text-sm text-signal">
              {error}
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
      </aside>
    </div>
  )
}

function Field({ label: text, error, children }: { label: string; error?: string; children: React.ReactNode }) {
  return (
    <label className="block">
      <span className={label}>{text}</span>
      {children}
      {error && <span className="mt-1.5 block text-sm text-signal">{error}</span>}
    </label>
  )
}
