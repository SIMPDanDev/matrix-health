import Link from 'next/link'
import { notFound } from 'next/navigation'
import { CertificateForm } from '@/components/admin/certificate-form'
import { AdminTitle } from '@/components/admin/parts'
import { IconArrowLeft } from '@/components/icons'
import { requireAdmin } from '@/lib/admin/auth'
import type { Certificate } from '@/lib/types'

export const metadata = { title: 'Документ' }

export default async function EditCertificatePage(props: PageProps<'/admin/certificates/[id]'>) {
  const { sb } = await requireAdmin()
  const [{ id }, { back }] = await Promise.all([props.params, props.searchParams])

  const [{ data: cert }, { data: products }] = await Promise.all([
    sb.from('certificates').select('*').eq('id', id).maybeSingle(),
    sb.from('products').select('id, name, batch, variants:product_variants(id, label, sort)').order('name'),
  ])
  if (!cert) notFound()
  // Открыли из карточки товара — туда и вернёмся
  const returnTo = back === 'product' && cert.product_id ? `/admin/products/${cert.product_id}` : null

  return (
    <>
      <Link href={returnTo ?? '/admin/certificates'} className="mb-4 inline-flex items-center gap-1.5 text-sm text-mute hover:text-ink">
        <IconArrowLeft size={16} /> {returnTo ? 'К товару' : 'Сертификаты'}
      </Link>
      <AdminTitle title={cert.title} sub={cert.batch ? `LOT ${cert.batch}` : undefined} />
      <CertificateForm cert={{ ...(cert as Certificate), product: null }} products={products ?? []} returnTo={returnTo} />
    </>
  )
}
