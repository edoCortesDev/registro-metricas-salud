import { signOut } from '../services/authService.js';
import { getState, resetState } from '../store/appState.js';
import { showToast } from './toast.js';
import { t } from '../utils/i18n.js';

export function mountProfileMenu(container) {
  const user = getState('user');
  const initial = user?.email ? user.email[0].toUpperCase() : '?';

  // Avatar button
  const avatar = document.createElement('button');
  avatar.type = 'button';
  avatar.className = 'profile-menu__avatar';
  avatar.setAttribute('aria-label', t('profile.menu_label'));
  avatar.setAttribute('aria-expanded', 'false');
  avatar.setAttribute('aria-haspopup', 'true');

  const avatarText = document.createElement('span');
  avatarText.className = 'profile-menu__avatar-initial';
  avatarText.textContent = initial;
  avatar.appendChild(avatarText);

  // Overlay (mobile bottom sheet backdrop)
  const overlay = document.createElement('div');
  overlay.className = 'profile-menu__overlay';
  overlay.setAttribute('hidden', '');
  overlay.setAttribute('aria-hidden', 'true');

  // Sheet / dropdown
  const sheet = document.createElement('div');
  sheet.className = 'profile-menu__sheet';
  sheet.setAttribute('hidden', '');
  sheet.setAttribute('role', 'menu');

  // Email display (non-editable in this menu — settings has the full edit)
  const emailEl = document.createElement('div');
  emailEl.className = 'profile-menu__email';
  emailEl.textContent = user?.email ?? '';

  const divider = document.createElement('hr');
  divider.className = 'profile-menu__divider';

  const settingsItem = makeMenuItem('settings', t('nav.settings'), () => {
    close();
    location.hash = '#/settings';
  });

  const changePassItem = makeMenuItem('key', t('settings.change_password'), () => {
    close();
    location.hash = '#/settings';
  });

  const logoutItem = makeMenuItem('logout', t('settings.logout'), async () => {
    close();
    try {
      await signOut();
      resetState();
      location.hash = '#/auth';
    } catch {
      showToast(t('errors.generic'), 'error');
    }
  });
  logoutItem.classList.add('profile-menu__item--danger');

  sheet.appendChild(emailEl);
  sheet.appendChild(divider);
  sheet.appendChild(settingsItem);
  sheet.appendChild(changePassItem);
  sheet.appendChild(logoutItem);

  container.appendChild(avatar);
  document.body.appendChild(overlay);
  document.body.appendChild(sheet);

  function open() {
    overlay.removeAttribute('hidden');
    sheet.removeAttribute('hidden');
    avatar.setAttribute('aria-expanded', 'true');
    positionSheet();
  }

  function close() {
    overlay.setAttribute('hidden', '');
    sheet.setAttribute('hidden', '');
    avatar.setAttribute('aria-expanded', 'false');
  }

  function positionSheet() {
    const isMobile = window.innerWidth < 768;
    if (isMobile) {
      sheet.classList.add('profile-menu__sheet--bottom');
      sheet.classList.remove('profile-menu__sheet--dropdown');
    } else {
      sheet.classList.remove('profile-menu__sheet--bottom');
      sheet.classList.add('profile-menu__sheet--dropdown');
      const rect = avatar.getBoundingClientRect();
      sheet.style.top = `${rect.bottom + 8}px`;
      sheet.style.right = `${window.innerWidth - rect.right}px`;
    }
  }

  avatar.addEventListener('click', () => {
    const isOpen = sheet.getAttribute('hidden') === null;
    isOpen ? close() : open();
  });

  overlay.addEventListener('click', close);

  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') close();
  });

  return { close };
}

function makeMenuItem(icon, label, onClick) {
  const btn = document.createElement('button');
  btn.type = 'button';
  btn.className = 'profile-menu__item';
  btn.setAttribute('role', 'menuitem');
  btn.textContent = label;
  btn.addEventListener('click', onClick);
  return btn;
}
