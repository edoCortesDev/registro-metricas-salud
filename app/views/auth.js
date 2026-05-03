import { signIn, signUp } from '../services/authService.js';
import { showToast } from '../components/toast.js';
import { sanitizeText } from '../utils/sanitize.js';
import { t } from '../utils/i18n.js';

function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

export async function mount(container) {
  let isSignup = false;

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

  // Email group
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

  // Password group
  const passwordGroup = document.createElement('div');
  passwordGroup.className = 'form__group';

  const passwordLabel = document.createElement('label');
  passwordLabel.className = 'form__label form__label--required';
  passwordLabel.htmlFor = 'auth-password';
  passwordLabel.textContent = t('auth.password');

  const passwordInput = document.createElement('input');
  passwordInput.type = 'password';
  passwordInput.id = 'auth-password';
  passwordInput.className = 'form__input';
  passwordInput.autocomplete = 'current-password';
  passwordInput.required = true;

  const passwordError = document.createElement('span');
  passwordError.className = 'form__error';
  passwordError.id = 'auth-password-error';
  passwordError.setAttribute('aria-live', 'polite');
  passwordInput.setAttribute('aria-describedby', 'auth-password-error');

  passwordGroup.appendChild(passwordLabel);
  passwordGroup.appendChild(passwordInput);
  passwordGroup.appendChild(passwordError);

  // Confirm password group (signup only)
  const confirmGroup = document.createElement('div');
  confirmGroup.className = 'form__group';
  confirmGroup.style.display = 'none';

  const confirmLabel = document.createElement('label');
  confirmLabel.className = 'form__label form__label--required';
  confirmLabel.htmlFor = 'auth-confirm';
  confirmLabel.textContent = t('auth.confirm_password');

  const confirmInput = document.createElement('input');
  confirmInput.type = 'password';
  confirmInput.id = 'auth-confirm';
  confirmInput.className = 'form__input';
  confirmInput.autocomplete = 'new-password';

  const confirmError = document.createElement('span');
  confirmError.className = 'form__error';
  confirmError.id = 'auth-confirm-error';
  confirmError.setAttribute('aria-live', 'polite');
  confirmInput.setAttribute('aria-describedby', 'auth-confirm-error');

  confirmGroup.appendChild(confirmLabel);
  confirmGroup.appendChild(confirmInput);
  confirmGroup.appendChild(confirmError);

  const submitBtn = document.createElement('button');
  submitBtn.type = 'submit';
  submitBtn.className = 'btn btn--primary btn--block';
  submitBtn.textContent = t('auth.signin');

  const toggleBtn = document.createElement('button');
  toggleBtn.type = 'button';
  toggleBtn.className = 'btn btn--ghost btn--block auth__toggle';
  toggleBtn.textContent = t('auth.toggle_signup');

  form.appendChild(emailGroup);
  form.appendChild(passwordGroup);
  form.appendChild(confirmGroup);
  form.appendChild(submitBtn);
  form.appendChild(toggleBtn);

  section.appendChild(header);
  section.appendChild(form);
  container.appendChild(section);

  emailInput.focus();

  function clearErrors() {
    emailError.textContent = '';
    passwordError.textContent = '';
    confirmError.textContent = '';
    emailInput.classList.remove('form__input--error');
    passwordInput.classList.remove('form__input--error');
    confirmInput.classList.remove('form__input--error');
  }

  toggleBtn.addEventListener('click', () => {
    isSignup = !isSignup;
    clearErrors();

    if (isSignup) {
      confirmGroup.style.display = '';
      passwordInput.autocomplete = 'new-password';
      submitBtn.textContent = t('auth.signup');
      toggleBtn.textContent = t('auth.toggle_signin');
    } else {
      confirmGroup.style.display = 'none';
      passwordInput.autocomplete = 'current-password';
      submitBtn.textContent = t('auth.signin');
      toggleBtn.textContent = t('auth.toggle_signup');
    }
  });

  form.addEventListener('submit', async e => {
    e.preventDefault();
    clearErrors();

    const email = sanitizeText(emailInput.value.trim());
    const password = passwordInput.value;
    const confirm = confirmInput.value;

    let valid = true;

    if (!email) {
      emailError.textContent = t('auth.error_required');
      emailInput.classList.add('form__input--error');
      emailInput.focus();
      valid = false;
    } else if (!isValidEmail(email)) {
      emailError.textContent = t('auth.error_invalid_email');
      emailInput.classList.add('form__input--error');
      emailInput.focus();
      valid = false;
    }

    if (!password) {
      passwordError.textContent = t('auth.error_required');
      passwordInput.classList.add('form__input--error');
      if (valid) passwordInput.focus();
      valid = false;
    } else if (password.length < 8) {
      passwordError.textContent = t('auth.password_min');
      passwordInput.classList.add('form__input--error');
      if (valid) passwordInput.focus();
      valid = false;
    }

    if (isSignup && valid && password !== confirm) {
      confirmError.textContent = t('auth.password_mismatch');
      confirmInput.classList.add('form__input--error');
      confirmInput.focus();
      valid = false;
    }

    if (!valid) return;

    submitBtn.disabled = true;
    submitBtn.textContent = t('auth.sending');

    try {
      if (isSignup) {
        await signUp(email, password);
      } else {
        await signIn(email, password);
      }
    } catch (err) {
      showToast(t('errors.generic'), 'error');
      submitBtn.disabled = false;
      submitBtn.textContent = isSignup ? t('auth.signup') : t('auth.signin');
    }
  });

  return () => {};
}
