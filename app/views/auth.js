import { sendMagicLink } from '../services/authService.js';
import { showToast } from '../components/toast.js';
import { sanitizeText } from '../utils/sanitize.js';
import { t } from '../utils/i18n.js';

function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

export async function mount(container) {
  const section = document.createElement('section');
  section.className = 'auth';

  const header = document.createElement('div');
  header.className = 'auth__header';

  const logo = document.createElement('div');
  logo.className = 'auth__logo';
  logo.textContent = '⊕';

  const title = document.createElement('h1');
  title.className = 'auth__title';
  title.textContent = t('auth.title');

  const subtitle = document.createElement('p');
  subtitle.className = 'auth__subtitle';
  subtitle.textContent = t('auth.subtitle');

  header.appendChild(logo);
  header.appendChild(title);
  header.appendChild(subtitle);

  const form = document.createElement('form');
  form.className = 'auth__form form';
  form.setAttribute('novalidate', '');

  const emailGroup = document.createElement('div');
  emailGroup.className = 'form__group';

  const emailLabel = document.createElement('label');
  emailLabel.className = 'form__label form__label--required';
  emailLabel.htmlFor = 'auth-email';
  emailLabel.textContent = t('auth.email_label');

  const emailInput = document.createElement('input');
  emailInput.type = 'email';
  emailInput.id = 'auth-email';
  emailInput.className = 'form__input';
  emailInput.placeholder = t('auth.email_placeholder');
  emailInput.autocomplete = 'email';
  emailInput.required = true;

  const emailError = document.createElement('span');
  emailError.className = 'form__error';
  emailError.id = 'auth-email-error';
  emailError.setAttribute('aria-live', 'polite');
  emailInput.setAttribute('aria-describedby', 'auth-email-error');

  emailGroup.appendChild(emailLabel);
  emailGroup.appendChild(emailInput);
  emailGroup.appendChild(emailError);

  const submitBtn = document.createElement('button');
  submitBtn.type = 'submit';
  submitBtn.className = 'btn btn--primary btn--block';
  submitBtn.textContent = t('auth.submit');

  form.appendChild(emailGroup);
  form.appendChild(submitBtn);

  const successMsg = document.createElement('div');
  successMsg.className = 'auth__success';
  successMsg.setAttribute('hidden', '');
  successMsg.setAttribute('role', 'status');

  const successIcon = document.createElement('div');
  successIcon.className = 'auth__success-icon';
  successIcon.textContent = '✓';

  const successText = document.createElement('p');
  successText.className = 'auth__success-text';

  successMsg.appendChild(successIcon);
  successMsg.appendChild(successText);

  section.appendChild(header);
  section.appendChild(form);
  section.appendChild(successMsg);
  container.appendChild(section);

  emailInput.focus();

  form.addEventListener('submit', async e => {
    e.preventDefault();
    emailError.textContent = '';
    emailInput.classList.remove('form__input--error');

    const email = emailInput.value.trim();

    if (!email) {
      emailError.textContent = t('auth.error_required');
      emailInput.classList.add('form__input--error');
      emailInput.focus();
      return;
    }

    if (!isValidEmail(email)) {
      emailError.textContent = t('auth.error_invalid_email');
      emailInput.classList.add('form__input--error');
      emailInput.focus();
      return;
    }

    submitBtn.disabled = true;
    submitBtn.textContent = t('auth.sending');

    try {
      await sendMagicLink(email);
      form.setAttribute('hidden', '');
      successText.textContent = t('auth.check_email', { email: sanitizeText(email) });
      successMsg.removeAttribute('hidden');
    } catch (err) {
      showToast(t('errors.generic'), 'error');
      submitBtn.disabled = false;
      submitBtn.textContent = t('auth.submit');
    }
  });

  return () => {};
}
