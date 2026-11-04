import 'server-only'
import { deflateSync } from 'node:zlib'
import QRCode from 'qrcode'
import { SITE_URL } from './seo'

// QR-код для этикетки товара. Печатается размером около 1×1 см, поэтому всё подчинено чёткости:
//  • короткая ссылка /P/SLUG большими буквами — так QR кодируется в «буквенно-цифровом» режиме,
//    модулей меньше (обычно версия 3 — 29×29), и каждый модуль на этикетке крупнее;
//  • уровень коррекции M — выдерживает ~15 % повреждений и не раздувает код;
//  • PNG рисуем сами: каждый модуль — ровный квадрат из целого числа пикселей, без сглаживания,
//    1 бит на пиксель (только чёрный и белый), а в файл записан физический размер 10×10 мм;
//  • SVG — векторный, чёткий при любом размере печати.
// Ссылку /P/SLUG принимает proxy.ts и ведёт на страницу товара.

/** Белое поле вокруг кода, в модулях. Стандарт советует 4, для крошечной этикетки 2 — разумный минимум */
const QUIET = 2
/** Пикселей на модуль в PNG: 33 модуля × 40 = 1320 px на 1 см — это ~3350 dpi, с запасом для любого принтера */
const PX = 40
/** Размер кода на этикетке вместе с белым полем, мм */
export const QR_SIZE_MM = 10

/** Что зашито в QR: короткая ссылка на товар, большими буквами (так короче) */
export function qrLink(slug: string) {
  return `${SITE_URL}/P/${slug}`.toUpperCase()
}

function matrix(slug: string) {
  const { modules, version } = QRCode.create(qrLink(slug), { errorCorrectionLevel: 'M' })
  const n = modules.size
  const total = n + QUIET * 2
  const dark = (x: number, y: number) => {
    const col = x - QUIET
    const row = y - QUIET
    return col >= 0 && row >= 0 && col < n && row < n && modules.get(row, col) === 1
  }
  return { total, version, dark }
}

/** Сведения для админки: версия кода и число модулей */
export function qrInfo(slug: string) {
  const { total, version } = matrix(slug)
  return { link: qrLink(slug), version, modules: total - QUIET * 2, moduleMm: QR_SIZE_MM / total }
}

export function qrSvg(slug: string) {
  const { total, dark } = matrix(slug)
  let d = ''
  for (let y = 0; y < total; y++) {
    for (let x = 0; x < total; ) {
      if (!dark(x, y)) {
        x++
        continue
      }
      let len = 1
      while (x + len < total && dark(x + len, y)) len++
      d += `M${x} ${y}h${len}v1h-${len}z`
      x += len
    }
  }
  return (
    `<svg xmlns="http://www.w3.org/2000/svg" width="${QR_SIZE_MM}mm" height="${QR_SIZE_MM}mm" viewBox="0 0 ${total} ${total}" shape-rendering="crispEdges">` +
    `<rect width="${total}" height="${total}" fill="#fff"/><path fill="#000" d="${d}"/></svg>`
  )
}

export function qrPng(slug: string) {
  const { total, dark } = matrix(slug)
  const size = total * PX
  const rowBytes = Math.ceil(size / 8)

  // Ч/б PNG, 1 бит на пиксель: 1 — белый, 0 — чёрный. Перед каждой строкой — байт фильтра (0).
  const raw = Buffer.alloc((rowBytes + 1) * size)
  for (let y = 0; y < size; y++) {
    const offset = y * (rowBytes + 1)
    const my = Math.floor(y / PX)
    for (let x = 0; x < size; x++) {
      if (!dark(Math.floor(x / PX), my)) raw[offset + 1 + (x >> 3)] |= 0x80 >> (x & 7)
    }
  }

  const ihdr = Buffer.alloc(13)
  ihdr.writeUInt32BE(size, 0)
  ihdr.writeUInt32BE(size, 4)
  ihdr[8] = 1 // глубина цвета — 1 бит
  ihdr[9] = 0 // оттенки серого

  // pHYs: пикселей на метр — программы вёрстки этикеток сразу ставят картинку размером 10×10 мм
  const ppm = Math.round(size / (QR_SIZE_MM / 1000))
  const phys = Buffer.alloc(9)
  phys.writeUInt32BE(ppm, 0)
  phys.writeUInt32BE(ppm, 4)
  phys[8] = 1 // единица — метр

  return Buffer.concat([
    Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
    chunk('IHDR', ihdr),
    chunk('pHYs', phys),
    chunk('IDAT', deflateSync(raw, { level: 9 })),
    chunk('IEND', Buffer.alloc(0)),
  ])
}

function chunk(type: string, data: Buffer) {
  const head = Buffer.alloc(8)
  head.writeUInt32BE(data.length, 0)
  head.write(type, 4, 'ascii')
  const crc = Buffer.alloc(4)
  crc.writeUInt32BE(crc32(Buffer.concat([head.subarray(4), data])), 0)
  return Buffer.concat([head, data, crc])
}

const CRC_TABLE = Array.from({ length: 256 }, (_, n) => {
  let c = n
  for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1
  return c >>> 0
})

function crc32(buf: Buffer) {
  let c = 0xffffffff
  for (const b of buf) c = CRC_TABLE[(c ^ b) & 0xff] ^ (c >>> 8)
  return (c ^ 0xffffffff) >>> 0
}
