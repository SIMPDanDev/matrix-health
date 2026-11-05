import type { NextConfig } from "next";

// Фото товаров и PDF лежат в Supabase Storage — разрешаем next/image грузить их оттуда.
function supabaseImages() {
  try {
    const url = new URL(process.env.NEXT_PUBLIC_SUPABASE_URL ?? "");
    return [new URL(`${url.origin}/storage/v1/object/public/**`)];
  } catch {
    return [];
  }
}

// Заголовки безопасности для всех ответов сайта и админки
const SECURITY_HEADERS = [
  // Только HTTPS, два года, включая поддомены
  { key: 'Strict-Transport-Security', value: 'max-age=63072000; includeSubDomains; preload' },
  // Сайт нельзя встроить в чужую страницу (защита от «кликджекинга»); плагины и чужой <base> запрещены;
  // формы отправляются только на наш сайт
  { key: 'Content-Security-Policy', value: "frame-ancestors 'none'; object-src 'none'; base-uri 'self'; form-action 'self'" },
  { key: 'X-Frame-Options', value: 'DENY' },
  // Браузер не угадывает тип файла — картинка не исполнится как скрипт
  { key: 'X-Content-Type-Options', value: 'nosniff' },
  // Чужим сайтам — только адрес домена, без страниц и параметров
  { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
  // Камера, микрофон, геолокация и т.п. сайту не нужны
  { key: 'Permissions-Policy', value: 'camera=(), microphone=(), geolocation=(), payment=(), usb=(), browsing-topics=()' },
]

const nextConfig: NextConfig = {
  // Не сообщаем, на чём сделан сайт
  poweredByHeader: false,
  async headers() {
    return [{ source: '/:path*', headers: SECURITY_HEADERS }]
  },
  cacheComponents: true,
  partialPrefetching: true,
  images: {
    remotePatterns: supabaseImages(),
  },
  experimental: {
    // Своя 404 для адресов вне /en, /ro, /ru и /admin (у сайта и админки разные корневые layout'ы)
    globalNotFound: true,
    // Загрузка фото и PDF из админки идёт через Server Actions
    serverActions: {
      bodySizeLimit: "30mb",
    },
    proxyClientMaxBodySize: "30mb",
  },
  turbopack: {
    rules: {
      "*.css": {
        loaders: ["@tailwindcss/turbopack"],
        as: "*.css",
      },
    },
  },
};

export default nextConfig;
