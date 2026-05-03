import { setState } from '../store/appState.js';
import { sanitizeText } from './sanitize.js';

let translations = {};
let currentLocale = 'es';

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
  currentLocale = safeLang;
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

export function formatDate(dateStrOrDate) {
  const date = typeof dateStrOrDate === 'string'
    ? new Date(dateStrOrDate + 'T00:00:00')
    : dateStrOrDate;
  return new Intl.DateTimeFormat(currentLocale === 'de' ? 'de-DE' : 'es-ES', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
  }).format(date);
}

export function formatNumber(value, decimals = 1) {
  if (value == null || isNaN(value)) return '—';
  return new Intl.NumberFormat(currentLocale === 'de' ? 'de-DE' : 'es-ES', {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  }).format(value);
}
