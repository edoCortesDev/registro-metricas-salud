import { t } from '../utils/i18n.js';

export function createModal({ title, body, onConfirm, confirmText, cancelText, confirmDanger = false }) {
  const overlay = document.createElement('div');
  overlay.className = 'modal__overlay';
  overlay.setAttribute('role', 'dialog');
  overlay.setAttribute('aria-modal', 'true');
  overlay.setAttribute('aria-labelledby', 'modal-title');

  const modal = document.createElement('div');
  modal.className = 'modal';

  // Header
  const header = document.createElement('div');
  header.className = 'modal__header';
  const titleEl = document.createElement('h2');
  titleEl.className = 'modal__title';
  titleEl.id = 'modal-title';
  titleEl.textContent = title;
  header.appendChild(titleEl);

  // Body
  const bodyEl = document.createElement('div');
  bodyEl.className = 'modal__body';
  const bodyText = document.createElement('p');
  bodyText.textContent = body;
  bodyEl.appendChild(bodyText);

  // Footer
  const footer = document.createElement('div');
  footer.className = 'modal__footer';

  const cancelBtn = document.createElement('button');
  cancelBtn.className = 'btn btn--secondary';
  cancelBtn.textContent = cancelText || t('common.cancel');
  cancelBtn.type = 'button';

  const confirmBtn = document.createElement('button');
  confirmBtn.className = `btn ${confirmDanger ? 'btn--danger' : 'btn--primary'}`;
  confirmBtn.textContent = confirmText || t('common.confirm');
  confirmBtn.type = 'button';

  footer.appendChild(cancelBtn);
  footer.appendChild(confirmBtn);

  modal.appendChild(header);
  modal.appendChild(bodyEl);
  modal.appendChild(footer);
  overlay.appendChild(modal);
  document.body.appendChild(overlay);

  const close = () => {
    overlay.classList.remove('modal__overlay--visible');
    overlay.addEventListener('transitionend', () => overlay.remove(), { once: true });
  };

  requestAnimationFrame(() => {
    requestAnimationFrame(() => overlay.classList.add('modal__overlay--visible'));
  });

  cancelBtn.addEventListener('click', close);
  overlay.addEventListener('click', e => { if (e.target === overlay) close(); });
  confirmBtn.addEventListener('click', () => { onConfirm?.(); });

  document.addEventListener('keydown', function onEsc(e) {
    if (e.key === 'Escape') { close(); document.removeEventListener('keydown', onEsc); }
  });

  return { close };
}
