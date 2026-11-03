/** Разметка schema.org для Google (JSON-LD). «<» экранируется, чтобы текст из базы не закрыл тег script */
export function JsonLd({ data }: { data: Record<string, unknown> | Record<string, unknown>[] }) {
  return <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(data).replace(/</g, '\\u003c') }} />
}
