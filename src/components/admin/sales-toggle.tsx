'use client'

import { startTransition, useActionState } from 'react'
import { setSalesEnabled } from '@/lib/admin/actions'
import { btn } from '../ui'
import { FormMessage } from './controls'

/** Переключатель «продажи / витрина». installed — в базе уже есть поле из supabase/showcase.sql */
export function SalesToggle({ enabled, installed }: { enabled: boolean; installed: boolean }) {
  const [state, action, pending] = useActionState(setSalesEnabled, {})

  if (!installed) {
    return (
      <p className="text-sm text-ink-2">
        <b className="text-signal">Нужно один раз выполнить SQL.</b> Откройте Supabase → SQL Editor и запустите файл{' '}
        <code className="font-mono">supabase/showcase.sql</code> — сайт перейдёт в режим витрины, а здесь появится переключатель.
      </p>
    )
  }

  const toggle = () => {
    const question = enabled
      ? 'Выключить продажи? Цены, корзина и оформление заказа пропадут с сайта.'
      : 'Включить продажи? На сайте появятся цены, корзина и оформление заказа.'
    if (!confirm(question)) return
    const fd = new FormData()
    fd.set('enabled', enabled ? '0' : '1')
    startTransition(() => action(fd))
  }

  return (
    <div className="flex flex-wrap items-start justify-between gap-x-8 gap-y-4">
      <div className="max-w-xl text-sm">
        <p className="flex items-center gap-2 text-[15px] font-semibold">
          <span className={`size-2.5 rounded-full ${enabled ? 'bg-sage' : 'bg-signal'}`} />
          {enabled ? 'Продажи включены' : 'Режим витрины'}
        </p>
        <p className="mt-1.5 leading-relaxed text-ink-2">
          {enabled
            ? 'На сайте видны цены, работают корзина и оформление заказа.'
            : 'Каталог без цен, корзины и оформления заказа. На странице товара — форма «Сообщить о старте продаж», заявки приходят в «Заявки» и в Telegram. Цены товаров в админке сохраняются и вернутся на сайт, когда вы включите продажи.'}
        </p>
        <div className="mt-2">
          <FormMessage state={state} />
        </div>
      </div>
      <button type="button" onClick={toggle} disabled={pending} className={enabled ? btn.danger : btn.smallPrimary}>
        {pending ? 'Сохраняем…' : enabled ? 'Выключить продажи' : 'Включить продажи'}
      </button>
    </div>
  )
}
