import { createProfile } from '../services/profileService.js';
import { getState, setState } from '../store/appState.js';
import { sanitizeNumber } from '../utils/sanitize.js';
import { showToast } from '../components/toast.js';
import { t } from '../utils/i18n.js';

export async function mount(container) {
  const section = document.createElement('section');
  section.className = 'onboarding';

  const header = document.createElement('div');
  header.className = 'onboarding__header';

  const welcome = document.createElement('h1');
  welcome.className = 'onboarding__title';
  welcome.textContent = t('onboarding.title');

  const desc = document.createElement('p');
  desc.className = 'onboarding__description';
  desc.textContent = t('onboarding.description');

  header.appendChild(welcome);
  header.appendChild(desc);

  const form = document.createElement('form');
  form.className = 'onboarding__form form';
  form.setAttribute('novalidate', '');

  const heightGroup = document.createElement('div');
  heightGroup.className = 'form__group';

  const heightLabel = document.createElement('label');
  heightLabel.className = 'form__label form__label--required';
  heightLabel.htmlFor = 'onboarding-height';
  heightLabel.textContent = t('onboarding.height_label');

  const heightWrapper = document.createElement('div');
  heightWrapper.className = 'onboarding__input-wrapper';

  const heightInput = document.createElement('input');
  heightInput.type = 'number';
  heightInput.id = 'onboarding-height';
  heightInput.className = 'form__input';
  heightInput.min = '50';
  heightInput.max = '300';
  heightInput.step = '0.1';
  heightInput.placeholder = t('onboarding.height_placeholder');
  heightInput.required = true;
  heightInput.setAttribute('aria-describedby', 'onboarding-height-error onboarding-height-hint');

  const heightUnit = document.createElement('span');
  heightUnit.className = 'onboarding__unit';
  heightUnit.textContent = 'cm';
  heightUnit.setAttribute('aria-hidden', 'true');

  heightWrapper.appendChild(heightInput);
  heightWrapper.appendChild(heightUnit);

  const heightError = document.createElement('span');
  heightError.className = 'form__error';
  heightError.id = 'onboarding-height-error';
  heightError.setAttribute('aria-live', 'polite');

  const heightHint = document.createElement('span');
  heightHint.className = 'form__hint';
  heightHint.id = 'onboarding-height-hint';
  heightHint.textContent = t('onboarding.height_hint');

  heightGroup.appendChild(heightLabel);
  heightGroup.appendChild(heightWrapper);
  heightGroup.appendChild(heightError);
  heightGroup.appendChild(heightHint);

  const submitBtn = document.createElement('button');
  submitBtn.type = 'submit';
  submitBtn.className = 'btn btn--primary btn--block';
  submitBtn.textContent = t('onboarding.submit');

  form.appendChild(heightGroup);
  form.appendChild(submitBtn);

  section.appendChild(header);
  section.appendChild(form);
  container.appendChild(section);

  heightInput.focus();

  heightInput.addEventListener('blur', () => {
    const val = sanitizeNumber(heightInput.value, { min: 50, max: 300 });
    if (heightInput.value && !val) {
      heightError.textContent = t('onboarding.height_error');
      heightInput.classList.add('form__input--error');
    } else {
      heightError.textContent = '';
      heightInput.classList.remove('form__input--error');
    }
  });

  form.addEventListener('submit', async e => {
    e.preventDefault();
    heightError.textContent = '';
    heightInput.classList.remove('form__input--error');

    const height = sanitizeNumber(heightInput.value, { min: 50, max: 300 });
    if (!height) {
      heightError.textContent = t('onboarding.height_error');
      heightInput.classList.add('form__input--error');
      heightInput.focus();
      return;
    }

    submitBtn.disabled = true;
    submitBtn.textContent = t('common.saving');

    try {
      const user = getState('user');
      const profile = await createProfile({ id: user.id, height });
      setState('profile', profile);
      location.hash = '#/dashboard';
    } catch (err) {
      showToast(t('errors.generic'), 'error');
      submitBtn.disabled = false;
      submitBtn.textContent = t('onboarding.submit');
    }
  });

  return () => {};
}
