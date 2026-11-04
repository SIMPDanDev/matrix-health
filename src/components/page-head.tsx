import { Breadcrumbs } from './breadcrumbs'

/** wide — заголовок и вступление на всю ширину страницы (для длинных текстовых страниц) */
export function PageHead({ title, lead, crumb, wide }: { title: React.ReactNode; lead?: string; crumb: string; wide?: boolean }) {
  return (
    <div className="border-b border-line pb-10 lg:pb-14">
      <Breadcrumbs items={[{ label: crumb }]} />
      <h1 className={`mt-6 ${wide ? '' : 'max-w-3xl '}text-[clamp(2.2rem,5vw,3.75rem)] leading-[1.02] font-bold tracking-[-0.035em] text-balance`}>
        {title}
      </h1>
      {lead && <p className={`mt-4 ${wide ? 'max-w-5xl' : 'max-w-2xl'} text-lg leading-relaxed text-ink-2`}>{lead}</p>}
    </div>
  )
}
