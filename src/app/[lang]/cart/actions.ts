'use server'

import { after } from 'next/server'
import type { RequestState } from '@/app/[lang]/consultation/actions'
import { CONTACT_METHODS } from '@/lib/constants'
import { getCatalog } from '@/lib/data'
import { isSupabaseConfigured } from '@/lib/supabase/env'
import { createPublicClient } from '@/lib/supabase/public'
import { requestMessage, sendTelegram, siteOrigin } from '@/lib/telegram'
import type { RequestItem } from '@/lib/types'

export type InquiryState = Omit<RequestState, 'error'> & { error?: RequestState['error'] | 'empty' }

type ItemInput = { product_id: string; variant_id: string | null; qty: number }

const str = (fd: FormData, key: string) => String(fd.get(key) ?? '').trim()

/** Запрос цены (режим витрины): список товаров из корзины и контакты — продавец перезванивает */
export async function requestPrices(_prev: InquiryState, fd: FormData): Promise<InquiryState> {
  // Ловушка для ботов: поле скрыто от людей
  if (str(fd, 'website')) return { ok: true, number: 0 }

  const request = {
    customer_name: str(fd, 'customer_name'),
    phone: str(fd, 'phone'),
    contact_method: str(fd, 'contact_method'),
    comment: str(fd, 'comment'),
  }

  const fields: InquiryState['fields'] = {}
  if (request.customer_name.length < 2) fields.customer_name = 'name'
  if (request.phone.replace(/\D/g, '').length < 8) fields.phone = 'phone'
  if (!(CONTACT_METHODS as readonly string[]).includes(request.contact_method)) request.contact_method = 'phone'
  if (Object.keys(fields).length) return { error: 'check', fields }

  let items: ItemInput[] = []
  try {
    const parsed = JSON.parse(str(fd, 'items'))
    items = (Array.isArray(parsed) ? parsed : [])
      .map((i) => ({
        product_id: String(i.product_id),
        variant_id: i.variant_id ? String(i.variant_id) : null,
        qty: Math.max(1, Math.min(99, Number(i.qty) || 1)),
      }))
      .slice(0, 50)
  } catch {
    items = []
  }
  if (!items.length) return { error: 'empty' }

  if (!isSupabaseConfigured) return { error: 'notConnected' }

  const { data, error } = await createPublicClient().rpc('request_products', { p_items: items, p_request: request })

  if (error) {
    // Тексты ошибок request_products — на русском; переводим известные в коды
    if (/недоступ/i.test(error.message)) return { error: 'unavailable' }
    if (/Список/i.test(error.message)) return { error: 'empty' }
    if (/имя/i.test(error.message)) return { error: 'check', fields: { customer_name: 'name' } }
    if (/телефон/i.test(error.message)) return { error: 'check', fields: { phone: 'phone' } }
    return { error: 'failed' }
  }

  const number = Number(data)
  const lang = str(fd, 'lang')

  // Уведомление в Telegram — уже после ответа посетителю, чтобы он не ждал
  after(async () => {
    const [{ products }, origin] = await Promise.all([getCatalog(), siteOrigin()])
    const lines: RequestItem[] = items.map((i) => {
      const p = products.find((x) => x.id === i.product_id)
      const v = p?.variants.find((x) => x.id === i.variant_id)
      return { name: p?.name ?? '—', variant: v?.label ?? null, qty: i.qty }
    })
    await sendTelegram(
      requestMessage({
        number,
        adminUrl: origin ? `${origin}/admin/requests` : null,
        lang,
        service: null,
        items: lines,
        customer: { name: request.customer_name, phone: request.phone, contact: request.contact_method, comment: request.comment },
      }),
    )
  })

  return { ok: true, number }
}
