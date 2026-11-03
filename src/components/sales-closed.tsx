import Link from 'next/link'
import { getI18n } from '@/i18n/server'
import { btn } from './ui'

/** Корзина и оформление заказа в режиме витрины */
export async function SalesClosed() {
  const { t, path } = await getI18n()
  return (
    <div className="rounded-3xl border border-dashed border-line-strong px-6 py-16 text-center">
      <p className="text-xl font-medium">{t.showcase.closedTitle}</p>
      <p className="mx-auto mt-2 max-w-md text-ink-2">{t.showcase.closedText}</p>
      <Link href={path('/catalog')} className={`${btn.primary} mt-7`}>
        {t.cart.goCatalog}
      </Link>
    </div>
  )
}
