import { updateProfile } from '../services/profileService.js';
import { signOut } from '../services/authService.js';
import { getState, setState, resetState } from '../store/appState.js';
import { applyTheme } from '../utils/theme.js';
import { loadLocale } from '../utils/i18n.js';
import { sanitizeNumber } from '../utils/sanitize.js';
import { showToast } from '../components/toast.js';
import { t } from '../utils/i18n.js';

export async function mount(container) {
  const profile = getState('profile');
  const currentTheme = getState('theme') || 'auto';
  const currentLang = getState('language') || 'es';

  const section = document.createElement('section');
  section.className = 'settings';

  const title = document.createElement('h1');
  title.className = 'settings__title';
  title.textContent = t('settings.title');
  section.appendChild(title);

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
    // Reload to re-render all i18n strings
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
