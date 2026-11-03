'use server'

import { after } from 'next/server'
import type { RequestState } from '@/app/[lang]/consultation/actions'
import { CONTACT_METHODS } from '@/lib/constants'
import { getCatalog } from '@/lib/data'
import { isSupabaseConfigured } from '@/lib/supabase/env'
import { createPublicClient } from '@/lib/supabase/public'
import { requestMessage, sendTelegram, siteOrigin } from '@/lib/telegram'

const str = (fd: FormData, key: string) => String(fd.get(key) ?? '').trim()
const isUuid = (v: string) => /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(v)

/** Заявка «Сообщить о старте продаж» — в режиме витрины вместо кнопки «В корзину» */
export async function requestProduct(_prev: RequestState, fd: FormData): Promise<RequestState> {
  // Ловушка для ботов: поле скрыто от людей
  if (str(fd, 'website')) return { ok: true, number: 0 }

  const product = str(fd, 'product_id')
  const request = {
    customer_name: str(fd, 'customer_name'),
    phone: str(fd, 'phone'),
    contact_method: str(fd, 'contact_method'),
  }

  const fields: RequestState['fields'] = {}
  if (request.customer_name.length < 2) fields.customer_name = 'name'
  if (request.phone.replace(/\D/g, '').length < 8) fields.phone = 'phone'
  if (!(CONTACT_METHODS as readonly string[]).includes(request.contact_method)) request.contact_method = 'phone'
  if (Object.keys(fields).length) return { error: 'check', fields }
  if (!isUuid(product)) return { error: 'unavailable' }

  if (!isSupabaseConfigured) return { error: 'notConnected' }

  const { data, error } = await createPublicClient().rpc('request_product', { p_product: product, p_request: request })

  if (error) {
    // Тексты ошибок request_product — на русском; переводим известные в коды
    if (/недоступ/i.test(error.message)) return { error: 'unavailable' }
    if (/имя/i.test(error.message)) return { error: 'check', fields: { customer_name: 'name' } }
    if (/телефон/i.test(error.message)) return { error: 'check', fields: { phone: 'phone' } }
    return { error: 'failed' }
  }

  const number = Number(data)
  const lang = str(fd, 'lang')

  // Уведомление в Telegram — уже после ответа посетителю, чтобы он не ждал
  after(async () => {
    const [{ products }, origin] = await Promise.all([getCatalog(), siteOrigin()])
    await sendTelegram(
      requestMessage({
        number,
        adminUrl: origin ? `${origin}/admin/requests` : null,
        lang,
        service: null,
        product: products.find((p) => p.id === product)?.name ?? 'товар с сайта',
        customer: { name: request.customer_name, phone: request.phone, contact: request.contact_method, comment: '' },
      }),
    )
  })

  return { ok: true, number }
}
