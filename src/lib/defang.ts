// «Обезвреживание» ссылок в тексте от посетителя — для Telegram и писем.
// Telegram и почтовые программы сами делают кликабельным любой адрес вида site.com,
// поэтому злоумышленник может прислать в заявке фишинговую ссылку. После defang её видно и можно
// прочитать, но нельзя нажать: https://evil.com/login → hxxps[:]//evil[.]com/login.
// Русский текст и числа вроде «2.5» не меняются: точка заменяется только перед латинскими буквами домена.

export function defang(text: string) {
  return text
    .replace(/\b(h)(tt)(ps?)(:)\/\//gi, (_, h, _tt, ps) => `${h}xx${ps}[:]//`)
    .replace(/\b(ftp|file|javascript|data|vbscript):/gi, '$1[:]')
    .replace(/\bwww\./gi, 'www[.]')
    .replace(/([a-z0-9-])\.(?=[a-z][a-z0-9-]*\b)/gi, '$1[.]')
    .replace(/@/g, '[@]')
}
