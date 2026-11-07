// Адреса документов на нашем домене: health-matrix.co.uk/docs/GLOW-COA-SP-0113.pdf
// Имя — из адреса товара (одинаковый на всех языках), типа документа и номера партии.
// Файл по-прежнему лежит в Supabase Storage, сайт отдаёт его со своего адреса (app/docs/[file]/route.ts).

import { MEDIA_BUCKET, SUPABASE_URL } from './supabase/env'
import { slugify } from './format'

/** Ссылка на файл в нашем хранилище Supabase (а не чужой адрес или javascript:) */
export function isOurFile(url: unknown): url is string {
  return typeof url === 'string' && url.startsWith(`${SUPABASE_URL.replace(/\/+$/, '')}/storage/v1/object/public/${MEDIA_BUCKET}/`)
}

const TYPE_CODE: Record<string, string> = { COA: 'COA', HPLC: 'HPLC', Соответствие: 'CONFORMITY', Другое: 'DOC' }

type DocLike = {
  id: string
  doc_type: string
  batch: string | null
  file_url: string | null
  created_at: string
  product?: { slug: string } | null
}

function ext(url: string) {
  const m = /\.(pdf|png|jpe?g|webp|gif)$/i.exec(url.split('?')[0])
  return m ? m[1].toLowerCase().replace('jpeg', 'jpg') : 'pdf'
}

function baseName(c: DocLike) {
  const parts = [c.product?.slug ?? 'doc', TYPE_CODE[c.doc_type] ?? 'DOC', c.batch ?? ''].map(slugify).filter(Boolean)
  return parts.join('-').toUpperCase()
}

/**
 * Имена файлов всех документов: { id: 'GLOW-COA-SP-0113.pdf' }. Только у документов с файлом.
 * Совпало имя — самый ранний документ остаётся без приписки, у остальных в конце первые символы id:
 * так имя документа не меняется, когда добавляются новые.
 */
export function docNames(certs: DocLike[]) {
  const names = new Map<string, string>()
  const groups = new Map<string, DocLike[]>()
  for (const c of certs) {
    if (!isOurFile(c.file_url)) continue
    const key = `${baseName(c)}.${ext(c.file_url)}`
    groups.set(key, [...(groups.get(key) ?? []), c])
  }
  for (const [key, list] of groups) {
    const [name, extension] = [key.slice(0, key.lastIndexOf('.')), key.slice(key.lastIndexOf('.') + 1)]
    ;[...list]
      .sort((a, b) => a.created_at.localeCompare(b.created_at) || a.id.localeCompare(b.id))
      .forEach((c, i) => names.set(c.id, i === 0 ? key : `${name}-${c.id.slice(0, 4).toUpperCase()}.${extension}`))
  }
  return names
}

/** Адрес документа на нашем сайте или null, если файла нет */
export function docHref(names: Map<string, string>, id: string) {
  const name = names.get(id)
  return name ? `/docs/${name}` : null
}
