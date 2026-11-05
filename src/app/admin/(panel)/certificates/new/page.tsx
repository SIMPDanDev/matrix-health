import Link from 'next/link'
import { CertificateForm } from '@/components/admin/certificate-form'
import { AdminTitle } from '@/components/admin/parts'
import { IconArrowLeft } from '@/components/icons'
import { requireAdmin } from '@/lib/admin/auth'

export const metadata = { title: 'Новый документ' }

export default async function NewCertificatePage(props: PageProps<'/admin/certificates/new'>) {
  const { sb } = await requireAdmin()
  // ?product=<id> — пришли из карточки товара: товар уже выбран, после сохранения вернёмся туда
  const { product } = await props.searchParams
  const productId = typeof product === 'string' ? product : null
  const { data } = await sb.from('products').select('id, name, batch, variants:product_variants(id, label, sort)').order('name')
  const back = productId && (data ?? []).some((p) => p.id === productId) ? `/admin/products/${productId}` : null

  return (
    <>
      <Link href={back ?? '/admin/certificates'} className="mb-4 inline-flex items-center gap-1.5 text-sm text-mute hover:text-ink">
        <IconArrowLeft size={16} /> {back ? 'К товару' : 'Сертификаты'}
      </Link>
      <AdminTitle title="Новый документ" />
      <CertificateForm cert={null} products={data ?? []} productId={back ? productId : null} returnTo={back} />
    </>
  )
}
