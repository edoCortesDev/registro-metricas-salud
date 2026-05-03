import { setState } from '../store/appState.js';
import { sanitizeText } from './sanitize.js';

let translations = {};

export async function initI18n() {
  const saved = localStorage.getItem('language');
  const browserLang = (navigator.language || 'es').slice(0, 2).toLowerCase();
  const supported = ['es', 'de'];
  const lang = saved || (supported.includes(browserLang) ? browserLang : 'es');
  await loadLocale(lang);
}

export async function loadLocale(lang) {
  const supported = ['es', 'de'];
  const safeLang = supported.includes(lang) ? lang : 'es';

  let mod;
  if (safeLang === 'de') {
    mod = await import('../i18n/de.json');
  } else {
    mod = await import('../i18n/es.json');
  }
  translations = mod.default;
  localStorage.setItem('language', safeLang);
  setState('language', safeLang);
  document.documentElement.setAttribute('lang', safeLang);
}

export function t(key, params = {}) {
  let str = translations[key] || key;
  for (const [k, v] of Object.entries(params)) {
    str = str.replace(`{${k}}`, sanitizeText(String(v)));
  }
  return str;
}
