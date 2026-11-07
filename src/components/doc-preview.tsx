'use client'

import { useEffect, useRef, useState } from 'react'
import { useI18n } from '@/i18n/client'
import { IconClose, IconDownload, IconFile } from './icons'

// Предпросмотр документа партии: миниатюра первой страницы в списке и просмотр всех страниц поверх сайта.
// PDF рисуем сами через pdf.js (Mozilla): встроенный просмотр PDF в <iframe> не работает на Android,
// а на iPhone показывает только первую страницу. Фото документа показываем как есть.

export type DocKind = 'pdf' | 'image' | null

/** Тип документа по адресу файла */
export function docKind(url: string | null | undefined): DocKind {
  if (!url) return null
  const path = url.split('?')[0].toLowerCase()
  if (path.endsWith('.pdf')) return 'pdf'
  if (/\.(png|jpe?g|webp|gif)$/.test(path)) return 'image'
  return null
}

type PdfLib = typeof import('pdfjs-dist')
type PdfDoc = Awaited<ReturnType<PdfLib['getDocument']>['promise']>

let lib: Promise<PdfLib> | null = null
const docs = new Map<string, Promise<PdfDoc>>()

/** pdf.js загружается только когда на экране появился первый документ */
function loadPdf(url: string) {
  lib ??= import('pdfjs-dist').then((m) => {
    m.GlobalWorkerOptions.workerSrc = new URL('pdfjs-dist/build/pdf.worker.min.mjs', import.meta.url).toString()
    return m
  })
  let doc = docs.get(url)
  if (!doc) {
    // isEvalSupported: false — pdf.js не выполняет код из файла, даже если он там есть
    doc = lib.then((m) => m.getDocument({ url, isEvalSupported: false }).promise)
    docs.set(url, doc)
    doc.catch(() => docs.delete(url))
  }
  return doc
}

/** Рисует страницу PDF в canvas шириной width CSS-пикселей (с учётом чёткости экрана) */
async function drawPage(doc: PdfDoc, n: number, canvas: HTMLCanvasElement, width: number) {
  const page = await doc.getPage(n)
  const base = page.getViewport({ scale: 1 })
  const dpr = Math.min(window.devicePixelRatio || 1, 3)
  const viewport = page.getViewport({ scale: (width / base.width) * dpr })
  canvas.width = Math.floor(viewport.width)
  canvas.height = Math.floor(viewport.height)
  // Пропорции — как у самой страницы (горизонтальный лист не растягивается)
  canvas.style.aspectRatio = `${viewport.width} / ${viewport.height}`
  const ctx = canvas.getContext('2d')
  if (!ctx) return
  await page.render({ canvas, canvasContext: ctx, viewport }).promise
}

/** Миниатюра документа; по нажатию открывается просмотр. size — ширина миниатюры в пикселях */
export function DocPreview({ url, title, size = 64 }: { url: string | null; title: string; size?: number }) {
  const { t } = useI18n()
  const kind = docKind(url)
  const [open, setOpen] = useState(false)
  const box = { width: size, height: Math.round(size * 1.38) } // пропорции листа A4

  if (!url || !kind) {
    return (
      <span style={box} className="flex shrink-0 items-center justify-center rounded-xl bg-brand-soft text-brand">
        <IconFile size={20} />
      </span>
    )
  }

  return (
    <>
      <button
        type="button"
        onClick={() => setOpen(true)}
        aria-label={`${t.product.docPreview}: ${title}`}
        style={box}
        className="relative shrink-0 overflow-hidden rounded-lg bg-white shadow-[0_1px_3px_rgba(15,26,68,0.18)] ring-1 ring-line transition hover:ring-2 hover:ring-brand"
      >
        {kind === 'image' ? (
          // eslint-disable-next-line @next/next/no-img-element -- документ из хранилища, без оптимизации
          <img src={url} alt="" className="size-full object-cover object-top" loading="lazy" />
        ) : (
          <PdfThumb url={url} width={size} />
        )}
      </button>
      {open && <DocViewer url={url} kind={kind} title={title} onClose={() => setOpen(false)} />}
    </>
  )
}

function PdfThumb({ url, width }: { url: string; width: number }) {
  const ref = useRef<HTMLCanvasElement>(null)
  const [state, setState] = useState<'wait' | 'ok' | 'error'>('wait')

  useEffect(() => {
    const canvas = ref.current
    if (!canvas) return
    let cancelled = false
    // Рисуем, только когда миниатюра появилась на экране
    const io = new IntersectionObserver(
      ([entry]) => {
        if (!entry.isIntersecting) return
        io.disconnect()
        loadPdf(url)
          .then((doc) => drawPage(doc, 1, canvas, width))
          .then(() => !cancelled && setState('ok'))
          .catch(() => !cancelled && setState('error'))
      },
      { rootMargin: '200px' },
    )
    io.observe(canvas)
    return () => {
      cancelled = true
      io.disconnect()
    }
  }, [url, width])

  return (
    <>
      <canvas ref={ref} className={`size-full object-cover object-top ${state === 'ok' ? '' : 'invisible'}`} style={{ aspectRatio: 'auto' }} />
      {state !== 'ok' && (
        <span className={`absolute inset-0 flex items-center justify-center text-brand ${state === 'wait' ? 'animate-pulse' : ''}`}>
          <IconFile size={20} />
        </span>
      )}
    </>
  )
}

/** Просмотр документа поверх страницы: все страницы PDF или фото, «Скачать» и «Закрыть» */
function DocViewer({ url, kind, title, onClose }: { url: string; kind: 'pdf' | 'image'; title: string; onClose: () => void }) {
  const { t } = useI18n()
  const closeRef = useRef<HTMLButtonElement>(null)

  useEffect(() => {
    const prev = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    closeRef.current?.focus()
    const onKey = (e: KeyboardEvent) => e.key === 'Escape' && onClose()
    window.addEventListener('keydown', onKey)
    return () => {
      document.body.style.overflow = prev
      window.removeEventListener('keydown', onKey)
    }
  }, [onClose])

  return (
    <div role="dialog" aria-modal="true" aria-label={title} className="fixed inset-0 z-50 flex flex-col bg-ink/80 backdrop-blur-sm">
      <div className="flex items-center gap-3 bg-surface px-4 py-3 shadow-sm sm:px-6">
        <p className="min-w-0 flex-1 truncate font-semibold">{title}</p>
        <a
          href={url}
          target="_blank"
          rel="noreferrer"
          download
          className="inline-flex h-10 items-center gap-2 rounded-full border border-line-strong px-4 text-sm font-medium hover:border-ink"
        >
          <IconDownload size={16} /> <span className="hidden sm:inline">{t.product.docDownload}</span>
        </a>
        <button
          ref={closeRef}
          type="button"
          onClick={onClose}
          aria-label={t.product.docClose}
          className="flex size-10 items-center justify-center rounded-full bg-sand hover:bg-line"
        >
          <IconClose size={18} />
        </button>
      </div>

      {/* Клик по тёмному фону вокруг документа закрывает просмотр */}
      <div className="flex-1 overflow-y-auto px-3 py-4 sm:px-6 sm:py-6" onClick={(e) => e.target === e.currentTarget && onClose()}>
        <div className="mx-auto max-w-3xl" onClick={(e) => e.target === e.currentTarget && onClose()}>
          {kind === 'image' ? (
            // eslint-disable-next-line @next/next/no-img-element -- документ из хранилища, без оптимизации
            <img src={url} alt={title} className="mx-auto w-full rounded-lg bg-white shadow-lg" />
          ) : (
            <PdfPages url={url} />
          )}
        </div>
      </div>
    </div>
  )
}

function PdfPages({ url }: { url: string }) {
  const { t } = useI18n()
  const wrap = useRef<HTMLDivElement>(null)
  const [pages, setPages] = useState(0)
  const [error, setError] = useState(false)

  useEffect(() => {
    let cancelled = false
    loadPdf(url)
      .then((doc) => !cancelled && setPages(Math.min(doc.numPages, 50)))
      .catch(() => !cancelled && setError(true))
    return () => {
      cancelled = true
    }
  }, [url])

  if (error) return <p className="rounded-lg bg-surface p-6 text-center text-ink-2">{t.product.docError}</p>
  if (!pages) return <p className="animate-pulse p-6 text-center text-white">{t.product.docLoading}</p>

  return (
    <div ref={wrap} className="space-y-4">
      {Array.from({ length: pages }, (_, i) => (
        <PdfPage key={i} url={url} n={i + 1} />
      ))}
    </div>
  )
}

function PdfPage({ url, n }: { url: string; n: number }) {
  const ref = useRef<HTMLCanvasElement>(null)

  useEffect(() => {
    const canvas = ref.current
    if (!canvas) return
    // Страницы рисуются по мере прокрутки — длинный документ не тормозит
    const io = new IntersectionObserver(
      ([entry]) => {
        if (!entry.isIntersecting) return
        io.disconnect()
        const width = canvas.parentElement?.clientWidth ?? 800
        loadPdf(url).then((doc) => drawPage(doc, n, canvas, width))
      },
      { rootMargin: '600px' },
    )
    io.observe(canvas)
    return () => io.disconnect()
  }, [url, n])

  return (
    <div className="overflow-hidden rounded-lg bg-white shadow-lg">
      <canvas ref={ref} className="block aspect-[1/1.414] w-full" />
    </div>
  )
}
