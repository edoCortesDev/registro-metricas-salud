import { updateProfile } from '../services/profileService.js';
import { signOut, updatePassword } from '../services/authService.js';
import { getState, setState, resetState } from '../store/appState.js';
import { applyTheme } from '../utils/theme.js';
import { loadLocale } from '../utils/i18n.js';
import { sanitizeNumber, sanitizeText } from '../utils/sanitize.js';
import { showToast } from '../components/toast.js';
import { t } from '../utils/i18n.js';

export async function mount(container) {
  const profile = getState('profile');
  const currentTheme = getState('theme') || 'auto';
  const currentLang = getState('language') || 'es';

  const section = document.createElement('section');
  section.className = 'settings';

  const titleEl = document.createElement('h1');
  titleEl.className = 'settings__title';
  titleEl.textContent = t('settings.title');
  section.appendChild(titleEl);

  // --- Theme ---
  const themeGroup = makeSettingsGroup(t('settings.theme_label'));
  const themeOptions = [
    { value: 'auto',  label: t('settings.theme_auto') },
    { value: 'light', label: t('settings.theme_light') },
    { value: 'dark',  label: t('settings.theme_dark') },
  ];

  const themeRadioGroup = document.createElement('div');
  themeRadioGroup.className = 'settings__radio-group';
  themeRadioGroup.setAttribute('role', 'radiogroup');
  themeRadioGroup.setAttribute('aria-label', t('settings.theme_label'));

  themeOptions.forEach(({ value, label }) => {
    const radioLabel = document.createElement('label');
    radioLabel.className = 'settings__radio-label';
    const radio = document.createElement('input');
    radio.type = 'radio';
    radio.name = 'theme';
    radio.value = value;
    radio.checked = value === currentTheme;
    radio.className = 'settings__radio';
    const span = document.createElement('span');
    span.textContent = label;
    radioLabel.appendChild(radio);
    radioLabel.appendChild(span);
    themeRadioGroup.appendChild(radioLabel);
  });

  themeGroup.content.appendChild(themeRadioGroup);
  section.appendChild(themeGroup.el);

  // --- Language ---
  const langGroup = makeSettingsGroup(t('settings.language_label'));
  const langSelect = document.createElement('select');
  langSelect.className = 'form__select';
  langSelect.setAttribute('aria-label', t('settings.language_label'));

  [{ value: 'es', label: 'Español' }, { value: 'de', label: 'Deutsch' }].forEach(({ value, label }) => {
    const opt = document.createElement('option');
    opt.value = value;
    opt.textContent = label;
    opt.selected = value === currentLang;
    langSelect.appendChild(opt);
  });

  langGroup.content.appendChild(langSelect);
  section.appendChild(langGroup.el);

  // --- Height ---
  const heightGroup = makeSettingsGroup(t('settings.height_label'));
  const heightForm = document.createElement('form');
  heightForm.className = 'settings__inline-form';
  heightForm.setAttribute('novalidate', '');

  const heightWrapper = document.createElement('div');
  heightWrapper.className = 'settings__input-wrapper';

  const heightInput = document.createElement('input');
  heightInput.type = 'number';
  heightInput.className = 'form__input';
  heightInput.min = '50';
  heightInput.max = '300';
  heightInput.step = '0.1';
  heightInput.value = profile?.height ?? '';
  heightInput.setAttribute('aria-label', t('settings.height_label'));
  heightInput.setAttribute('aria-describedby', 'settings-height-error');

  const heightUnit = document.createElement('span');
  heightUnit.className = 'settings__unit';
  heightUnit.textContent = 'cm';
  heightUnit.setAttribute('aria-hidden', 'true');

  const saveHeightBtn = document.createElement('button');
  saveHeightBtn.type = 'submit';
  saveHeightBtn.className = 'btn btn--primary btn--sm';
  saveHeightBtn.textContent = t('common.save');

  heightWrapper.appendChild(heightInput);
  heightWrapper.appendChild(heightUnit);

  const heightError = document.createElement('span');
  heightError.className = 'form__error';
  heightError.id = 'settings-height-error';
  heightError.setAttribute('aria-live', 'polite');

  heightForm.appendChild(heightWrapper);
  heightForm.appendChild(saveHeightBtn);
  heightForm.appendChild(heightError);
  heightGroup.content.appendChild(heightForm);
  section.appendChild(heightGroup.el);

  // --- Sex ---
  const sexGroup = makeSettingsGroup(t('settings.sex_label'));
  const sexSelect = document.createElement('select');
  sexSelect.className = 'form__select';
  sexSelect.setAttribute('aria-label', t('settings.sex_label'));

  [
    { value: '',       label: t('profile.sex_other') },
    { value: 'male',   label: t('profile.sex_male') },
    { value: 'female', label: t('profile.sex_female') },
  ].forEach(({ value, label }) => {
    const opt = document.createElement('option');
    opt.value = value;
    opt.textContent = label;
    opt.selected = (profile?.sex ?? '') === value;
    sexSelect.appendChild(opt);
  });

  const saveSexBtn = document.createElement('button');
  saveSexBtn.type = 'button';
  saveSexBtn.className = 'btn btn--primary btn--sm';
  saveSexBtn.textContent = t('common.save');

  const sexRow = document.createElement('div');
  sexRow.className = 'settings__inline-form';
  sexRow.appendChild(sexSelect);
  sexRow.appendChild(saveSexBtn);
  sexGroup.content.appendChild(sexRow);
  section.appendChild(sexGroup.el);

  // --- Security / Change password ---
  const securityGroup = makeSettingsGroup(t('settings.security'));
  const pwForm = document.createElement('form');
  pwForm.className = 'settings__inline-form settings__pw-form';
  pwForm.setAttribute('novalidate', '');

  const newPwInput = document.createElement('input');
  newPwInput.type = 'password';
  newPwInput.className = 'form__input';
  newPwInput.placeholder = t('settings.new_password');
  newPwInput.autocomplete = 'new-password';
  newPwInput.setAttribute('aria-label', t('settings.new_password'));
  newPwInput.setAttribute('aria-describedby', 'settings-pw-error');

  const confirmPwInput = document.createElement('input');
  confirmPwInput.type = 'password';
  confirmPwInput.className = 'form__input';
  confirmPwInput.placeholder = t('settings.confirm_new_password');
  confirmPwInput.autocomplete = 'new-password';
  confirmPwInput.setAttribute('aria-label', t('settings.confirm_new_password'));

  const updatePwBtn = document.createElement('button');
  updatePwBtn.type = 'submit';
  updatePwBtn.className = 'btn btn--primary btn--sm';
  updatePwBtn.textContent = t('settings.update_password');

  const pwError = document.createElement('span');
  pwError.className = 'form__error';
  pwError.id = 'settings-pw-error';
  pwError.setAttribute('aria-live', 'polite');

  pwForm.appendChild(newPwInput);
  pwForm.appendChild(confirmPwInput);
  pwForm.appendChild(updatePwBtn);
  pwForm.appendChild(pwError);
  securityGroup.content.appendChild(pwForm);
  section.appendChild(securityGroup.el);

  // --- Logout ---
  const logoutGroup = makeSettingsGroup('');
  const logoutBtn = document.createElement('button');
  logoutBtn.type = 'button';
  logoutBtn.className = 'btn btn--danger';
  logoutBtn.textContent = t('settings.logout');

  logoutGroup.content.appendChild(logoutBtn);
  section.appendChild(logoutGroup.el);

  container.appendChild(section);

  // Event: theme
  themeRadioGroup.addEventListener('change', e => {
    applyTheme(e.target.value);
  });

  // Event: language
  langSelect.addEventListener('change', async e => {
    await loadLocale(e.target.value);
    location.hash = '#/settings';
  });

  // Event: height
  heightForm.addEventListener('submit', async e => {
    e.preventDefault();
    heightError.textContent = '';
    heightInput.classList.remove('form__input--error');

    const height = sanitizeNumber(heightInput.value, { min: 50, max: 300 });
    if (!height) {
      heightError.textContent = t('onboarding.height_error');
      heightInput.classList.add('form__input--error');
      return;
    }

    saveHeightBtn.disabled = true;
    try {
      const updated = await updateProfile({ id: profile.id, height });
      setState('profile', updated);
      showToast(t('settings.height_saved'), 'success');
    } catch {
      showToast(t('errors.generic'), 'error');
    } finally {
      saveHeightBtn.disabled = false;
    }
  });

  // Event: sex
  saveSexBtn.addEventListener('click', async () => {
    saveSexBtn.disabled = true;
    try {
      const sex = sexSelect.value || null;
      const updated = await updateProfile({ id: profile.id, sex });
      setState('profile', updated);
      showToast(t('common.save') + ' ✓', 'success');
    } catch {
      showToast(t('errors.generic'), 'error');
    } finally {
      saveSexBtn.disabled = false;
    }
  });

  // Event: change password
  pwForm.addEventListener('submit', async e => {
    e.preventDefault();
    pwError.textContent = '';
    newPwInput.classList.remove('form__input--error');
    confirmPwInput.classList.remove('form__input--error');

    const newPw = newPwInput.value;
    const confirmPw = confirmPwInput.value;

    if (newPw.length < 8) {
      pwError.textContent = t('auth.password_min');
      newPwInput.classList.add('form__input--error');
      return;
    }
    if (newPw !== confirmPw) {
      pwError.textContent = t('auth.password_mismatch');
      confirmPwInput.classList.add('form__input--error');
      return;
    }

    updatePwBtn.disabled = true;
    try {
      await updatePassword(newPw);
      showToast(t('settings.password_updated'), 'success');
      newPwInput.value = '';
      confirmPwInput.value = '';
    } catch {
      showToast(t('errors.generic'), 'error');
    } finally {
      updatePwBtn.disabled = false;
    }
  });

  // Event: logout
  logoutBtn.addEventListener('click', async () => {
    logoutBtn.disabled = true;
    try {
      await signOut();
      resetState();
      location.hash = '#/auth';
    } catch {
      showToast(t('errors.generic'), 'error');
      logoutBtn.disabled = false;
    }
  });

  return () => {};
}

function makeSettingsGroup(label) {
  const el = document.createElement('div');
  el.className = 'settings__group';

  if (label) {
    const labelEl = document.createElement('div');
    labelEl.className = 'settings__group-label';
    labelEl.textContent = label;
    el.appendChild(labelEl);
  }

  const content = document.createElement('div');
  content.className = 'settings__group-content';
  el.appendChild(content);

  return { el, content };
}
