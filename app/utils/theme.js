import { setState } from '../store/appState.js';

export function initTheme() {
  const saved = localStorage.getItem('theme') || 'auto';
  applyTheme(saved);
}

export function applyTheme(mode) {
  const root = document.documentElement;
  if (mode === 'dark') {
    root.setAttribute('data-theme', 'dark');
  } else if (mode === 'light') {
    root.setAttribute('data-theme', 'light');
  } else {
    root.removeAttribute('data-theme');
  }
  localStorage.setItem('theme', mode);
  setState('theme', mode);
}
