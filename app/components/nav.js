import { t } from '../utils/i18n.js';

// Settings se accede desde el menú de perfil — no agregar aquí.
const NAV_ITEMS = [
  { hash: '#/dashboard', icon: '⊞', labelKey: 'nav.dashboard' },
  { hash: '#/add',       icon: '+',  labelKey: 'nav.add' },
  { hash: '#/history',   icon: '☰',  labelKey: 'nav.history' },
  { hash: '#/recipes',   icon: '📖', labelKey: 'nav.recipes' },
];

export function mountNav(container) {
  const nav = document.createElement('nav');
  nav.className = 'nav';
  nav.setAttribute('aria-label', t('nav.aria_label'));

  const list = document.createElement('ul');
  list.className = 'nav__list';

  NAV_ITEMS.forEach(({ hash, icon, labelKey }) => {
    const li = document.createElement('li');
    li.className = 'nav__item';

    const a = document.createElement('a');
    a.className = 'nav__link';
    a.href = hash;

    const iconEl = document.createElement('span');
    iconEl.className = 'nav__icon';
    iconEl.setAttribute('aria-hidden', 'true');
    iconEl.textContent = icon;

    const labelEl = document.createElement('span');
    labelEl.className = 'nav__label';
    labelEl.textContent = t(labelKey);

    a.appendChild(iconEl);
    a.appendChild(labelEl);
    li.appendChild(a);
    list.appendChild(li);
  });

  nav.appendChild(list);
  container.appendChild(nav);

  const updateActive = () => {
    const currentHash = '#' + location.hash.replace('#', '').split('?')[0];
    nav.querySelectorAll('.nav__link').forEach(a => {
      a.classList.toggle('nav__link--active', a.getAttribute('href') === currentHash);
      a.setAttribute('aria-current', a.getAttribute('href') === currentHash ? 'page' : 'false');
    });
  };

  window.addEventListener('hashchange', updateActive);
  updateActive();

  return {
    destroy: () => window.removeEventListener('hashchange', updateActive),
    show: () => container.removeAttribute('hidden'),
    hide: () => container.setAttribute('hidden', ''),
  };
}
