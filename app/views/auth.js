import { signIn, signUp, resetPassword } from '../services/authService.js';
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

  // ---- Main login/signup form ----
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

  // Forgot password link
  const forgotLink = document.createElement('button');
  forgotLink.type = 'button';
  forgotLink.className = 'btn btn--ghost auth__forgot';
  forgotLink.textContent = t('auth.forgot_password');

  form.appendChild(emailGroup);
  form.appendChild(passwordGroup);
  form.appendChild(confirmGroup);
  form.appendChild(submitBtn);
  form.appendChild(toggleBtn);
  form.appendChild(forgotLink);

  // ---- Forgot password mini-form ----
  const resetSection = document.createElement('div');
  resetSection.className = 'auth__reset-section';
  resetSection.setAttribute('hidden', '');

  const resetTitle = document.createElement('h2');
  resetTitle.className = 'auth__reset-title';
  resetTitle.textContent = t('auth.reset_title');

  const resetForm = document.createElement('form');
  resetForm.className = 'auth__form form';
  resetForm.setAttribute('novalidate', '');

  const resetEmailGroup = document.createElement('div');
  resetEmailGroup.className = 'form__group';

  const resetEmailLabel = document.createElement('label');
  resetEmailLabel.className = 'form__label form__label--required';
  resetEmailLabel.htmlFor = 'reset-email';
  resetEmailLabel.textContent = t('auth.email_label');

  const resetEmailInput = document.createElement('input');
  resetEmailInput.type = 'email';
  resetEmailInput.id = 'reset-email';
  resetEmailInput.className = 'form__input';
  resetEmailInput.placeholder = t('auth.email_placeholder');
  resetEmailInput.autocomplete = 'email';

  const resetEmailError = document.createElement('span');
  resetEmailError.className = 'form__error';
  resetEmailError.setAttribute('aria-live', 'polite');

  resetEmailGroup.appendChild(resetEmailLabel);
  resetEmailGroup.appendChild(resetEmailInput);
  resetEmailGroup.appendChild(resetEmailError);

  const resetSubmitBtn = document.createElement('button');
  resetSubmitBtn.type = 'submit';
  resetSubmitBtn.className = 'btn btn--primary btn--block';
  resetSubmitBtn.textContent = t('auth.send_reset');

  const backToLoginBtn = document.createElement('button');
  backToLoginBtn.type = 'button';
  backToLoginBtn.className = 'btn btn--ghost btn--block';
  backToLoginBtn.textContent = t('auth.back_to_login');

  resetForm.appendChild(resetEmailGroup);
  resetForm.appendChild(resetSubmitBtn);
  resetForm.appendChild(backToLoginBtn);

  resetSection.appendChild(resetTitle);
  resetSection.appendChild(resetForm);

  section.appendChild(header);
  section.appendChild(form);
  section.appendChild(resetSection);
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
      forgotLink.setAttribute('hidden', '');
    } else {
      confirmGroup.style.display = 'none';
      passwordInput.autocomplete = 'current-password';
      submitBtn.textContent = t('auth.signin');
      toggleBtn.textContent = t('auth.toggle_signup');
      forgotLink.removeAttribute('hidden');
    }
  });

  forgotLink.addEventListener('click', () => {
    form.setAttribute('hidden', '');
    resetSection.removeAttribute('hidden');
    resetEmailInput.value = emailInput.value;
    resetEmailInput.focus();
  });

  backToLoginBtn.addEventListener('click', () => {
    resetSection.setAttribute('hidden', '');
    form.removeAttribute('hidden');
    emailInput.focus();
  });

  resetForm.addEventListener('submit', async e => {
    e.preventDefault();
    resetEmailError.textContent = '';
    resetEmailInput.classList.remove('form__input--error');

    const email = sanitizeText(resetEmailInput.value.trim());
    if (!email || !isValidEmail(email)) {
      resetEmailError.textContent = t('auth.error_invalid_email');
      resetEmailInput.classList.add('form__input--error');
      return;
    }

    resetSubmitBtn.disabled = true;
    resetSubmitBtn.textContent = t('auth.sending');

    try {
      await resetPassword(email);
      showToast(t('auth.reset_sent'), 'success');
      resetSection.setAttribute('hidden', '');
      form.removeAttribute('hidden');
    } catch {
      showToast(t('errors.generic'), 'error');
    } finally {
      resetSubmitBtn.disabled = false;
      resetSubmitBtn.textContent = t('auth.send_reset');
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
