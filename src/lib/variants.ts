// Код дозировки для ссылок и QR-кодов: «10 mg» → 10MG, «2,5 мг» → 2.5MG, «500 мкг» → 500MCG.
// Только A–Z, 0–9 и точка — так QR остаётся в компактном «буквенно-цифровом» режиме (см. lib/qr.ts).
// Код считается из названия варианта, поэтому отдельного поля в базе не нужно.

const UNITS: [RegExp, string][] = [
  [/мкг/gi, 'MCG'],
  [/мг/gi, 'MG'],
  [/мл/gi, 'ML'],
  [/ме/gi, 'IU'],
  [/г/gi, 'G'],
]

export function variantCode(label: string) {
  let s = label.trim().replace(/(\d),(\d)/g, '$1.$2')
  for (const [re, unit] of UNITS) s = s.replace(re, unit)
  return s.toUpperCase().replace(/[^A-Z0-9.]+/g, '')
}

/** Коды всех вариантов товара: { id: код }. Пустой или повторяющийся код заменяется на V1, V2… по порядку */
export function variantCodes(variants: { id: string; label: string }[]) {
  const seen = new Set<string>()
  const codes: Record<string, string> = {}
  variants.forEach((v, i) => {
    let code = variantCode(v.label)
    if (!code || seen.has(code)) code = `V${i + 1}`
    seen.add(code)
    codes[v.id] = code
  })
  return codes
}

/** Вариант по коду из ссылки (?dose=50mg), без учёта регистра */
export function findVariantByCode<T extends { id: string; label: string }>(variants: T[], code: string | null | undefined) {
  if (!code) return null
  const codes = variantCodes(variants)
  return variants.find((v) => codes[v.id] === code.toUpperCase()) ?? null
}

/** Только в браузере: запоминает выбранную дозировку в адресе (?dose=50mg) — ссылку можно переслать, QR ведёт туда же */
export function rememberDose(variants: { id: string; label: string }[], id: string | null) {
  const url = new URL(window.location.href)
  const code = id ? variantCodes(variants)[id] : null
  if (code) url.searchParams.set('dose', code.toLowerCase())
  else url.searchParams.delete('dose')
  window.history.replaceState(window.history.state, '', url)
}

/** Названия дозировок, к которым относится сертификат, в порядке вариантов. Пусто — документ для всех дозировок */
export function doseLabels(variantIds: string[] | null | undefined, variants: { id: string; label: string; sort?: number }[] = []) {
  if (!variantIds?.length) return []
  return [...variants]
    .sort((a, b) => (a.sort ?? 0) - (b.sort ?? 0))
    .filter((v) => variantIds.includes(v.id))
    .map((v) => v.label)
}
