import { addMetric, updateMetric } from '../services/metricsService.js';
import { getState, setState } from '../store/appState.js';
import { createModal } from '../components/modal.js';
import { sanitizeNumber, sanitizeText } from '../utils/sanitize.js';
import { showToast } from '../components/toast.js';
import { t } from '../utils/i18n.js';

export async function mount(container) {
  const params = new URLSearchParams(location.hash.split('?')[1] || '');
  const editId = params.get('id');
  let existing = null;

  if (editId) {
    const metrics = getState('metrics');
    existing = metrics.find(m => m.id === editId) || null;
  }

  const section = document.createElement('section');
  section.className = 'entry';

  const header = document.createElement('div');
  header.className = 'entry__header';

  const backBtn = document.createElement('a');
  backBtn.href = editId ? '#/history' : '#/dashboard';
  backBtn.className = 'entry__back';
  backBtn.setAttribute('aria-label', t('common.back'));
  backBtn.textContent = '←';

  const title = document.createElement('h1');
  title.className = 'entry__title';
  title.textContent = editId ? t('entry.edit_title') : t('entry.add_title');

  header.appendChild(backBtn);
  header.appendChild(title);

  const form = document.createElement('form');
  form.className = 'entry__form form';
  form.setAttribute('novalidate', '');

  // Date
  const dateGroup = makeFormGroup('entry-date', t('entry.date_label'), 'date', {
    required: true,
    value: existing?.date || getTodayDate(),
  });

  // Weight
  const weightGroup = makeFormGroup('entry-weight', t('entry.weight_label'), 'number', {
    required: true,
    min: '20', max: '500', step: '0.1',
    placeholder: t('entry.weight_placeholder'),
    value: existing?.weight ?? '',
    unit: 'kg',
  });

  // Body fat
  const fatGroup = makeFormGroup('entry-fat', t('entry.fat_label'), 'number', {
    required: false,
    min: '1', max: '60', step: '0.1',
    placeholder: t('entry.fat_placeholder'),
    value: existing?.body_fat ?? '',
    unit: '%',
  });

  // Muscle mass
  const muscleGroup = makeFormGroup('entry-muscle', t('entry.muscle_label'), 'number', {
    required: false,
    min: '5', max: '150', step: '0.1',
    placeholder: t('entry.muscle_placeholder'),
    value: existing?.muscle_mass ?? '',
    unit: 'kg',
  });

  // Notes
  const notesGroup = makeTextareaGroup('entry-notes', t('entry.notes_label'), {
    placeholder: t('entry.notes_placeholder'),
    value: existing?.notes ?? '',
  });

  const actions = document.createElement('div');
  actions.className = 'form__actions';

  const cancelBtn = document.createElement('a');
  cancelBtn.href = editId ? '#/history' : '#/dashboard';
  cancelBtn.className = 'btn btn--secondary';
  cancelBtn.textContent = t('common.cancel');

  const submitBtn = document.createElement('button');
  submitBtn.type = 'submit';
  submitBtn.className = 'btn btn--primary';
  submitBtn.textContent = editId ? t('common.save') : t('entry.add');

  actions.appendChild(cancelBtn);
  actions.appendChild(submitBtn);

  form.appendChild(dateGroup.group);
  form.appendChild(weightGroup.group);
  form.appendChild(fatGroup.group);
  form.appendChild(muscleGroup.group);
  form.appendChild(notesGroup.group);
  form.appendChild(actions);

  section.appendChild(header);
  section.appendChild(form);
  container.appendChild(section);

  weightGroup.input.focus();

  form.addEventListener('submit', async e => {
    e.preventDefault();

    // Clear errors
    [dateGroup, weightGroup, fatGroup, muscleGroup].forEach(g => {
      g.error.textContent = '';
      g.input.classList.remove('form__input--error');
    });

    let valid = true;

    const dateVal = dateGroup.input.value;
    if (!dateVal) {
      dateGroup.error.textContent = t('entry.error_date_required');
      dateGroup.input.classList.add('form__input--error');
      valid = false;
    }

    const weight = sanitizeNumber(weightGroup.input.value, { min: 20, max: 500 });
    if (!weight) {
      weightGroup.error.textContent = t('entry.error_weight');
      weightGroup.input.classList.add('form__input--error');
      valid = false;
    }

    const bodyFat = fatGroup.input.value
      ? sanitizeNumber(fatGroup.input.value, { min: 1, max: 60 })
      : null;
    if (fatGroup.input.value && bodyFat === null) {
      fatGroup.error.textContent = t('entry.error_fat');
      fatGroup.input.classList.add('form__input--error');
      valid = false;
    }

    const muscleMass = muscleGroup.input.value
      ? sanitizeNumber(muscleGroup.input.value, { min: 5, max: 150 })
      : null;
    if (muscleGroup.input.value && muscleMass === null) {
      muscleGroup.error.textContent = t('entry.error_muscle');
      muscleGroup.input.classList.add('form__input--error');
      valid = false;
    }

    if (!valid) return;

    const payload = {
      date: dateVal,
      weight,
      body_fat: bodyFat,
      muscle_mass: muscleMass,
      notes: sanitizeText(notesGroup.textarea.value.trim()) || null,
    };

    // Check for duplicate date before submitting (new entries only)
    if (!editId) {
      const existingMetrics = getState('metrics');
      const duplicate = existingMetrics.find(m => m.date === dateVal);
      if (duplicate) {
        createModal({
          title: t('entry.add_title'),
          body: t('entry.duplicate_date'),
          confirmText: t('entry.edit_existing'),
          cancelText: t('common.cancel'),
          onConfirm: () => {
            location.hash = `#/add?id=${duplicate.id}`;
          },
        });
        return;
      }
    }

    submitBtn.disabled = true;
    submitBtn.textContent = t('common.saving');

    try {
      if (editId) {
        const updated = await updateMetric(editId, payload);
        const metrics = getState('metrics').map(m => m.id === editId ? updated : m);
        setState('metrics', metrics);
        showToast(t('entry.updated'), 'success');
        location.hash = '#/history';
      } else {
        const user = getState('user');
        const created = await addMetric({ ...payload, user_id: user.id });
        setState('metrics', [created, ...getState('metrics')]);
        showToast(t('entry.added'), 'success');
        const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        if (prefersReduced) {
          location.hash = '#/dashboard';
        } else {
          showSuccessAnimation(() => { location.hash = '#/dashboard'; });
        }
      }
    } catch (err) {
      showToast(t('errors.generic'), 'error');
      submitBtn.disabled = false;
      submitBtn.textContent = editId ? t('common.save') : t('entry.add');
    }
  });

  return () => {};
}

function makeFormGroup(id, label, type, opts = {}) {
  const group = document.createElement('div');
  group.className = 'form__group';

  const labelEl = document.createElement('label');
  labelEl.className = `form__label${opts.required ? ' form__label--required' : ''}`;
  labelEl.htmlFor = id;
  labelEl.textContent = label;

  const wrapper = document.createElement('div');
  wrapper.className = 'entry__input-wrapper';

  const input = document.createElement('input');
  input.type = type;
  input.id = id;
  input.className = 'form__input';
  input.setAttribute('aria-describedby', `${id}-error`);
  if (opts.required) input.required = true;
  if (opts.min) input.min = opts.min;
  if (opts.max) input.max = opts.max;
  if (opts.step) input.step = opts.step;
  if (opts.placeholder) input.placeholder = opts.placeholder;
  if (opts.value !== '' && opts.value != null) input.value = opts.value;

  wrapper.appendChild(input);

  if (opts.unit) {
    const unit = document.createElement('span');
    unit.className = 'entry__unit';
    unit.textContent = opts.unit;
    unit.setAttribute('aria-hidden', 'true');
    wrapper.appendChild(unit);
  }

  const error = document.createElement('span');
  error.className = 'form__error';
  error.id = `${id}-error`;
  error.setAttribute('aria-live', 'polite');

  group.appendChild(labelEl);
  group.appendChild(wrapper);
  group.appendChild(error);

  return { group, input, error };
}

function makeTextareaGroup(id, label, opts = {}) {
  const group = document.createElement('div');
  group.className = 'form__group';

  const labelEl = document.createElement('label');
  labelEl.className = 'form__label';
  labelEl.htmlFor = id;
  labelEl.textContent = label;

  const textarea = document.createElement('textarea');
  textarea.id = id;
  textarea.className = 'form__textarea';
  textarea.rows = 3;
  if (opts.placeholder) textarea.placeholder = opts.placeholder;
  if (opts.value) textarea.value = opts.value;

  group.appendChild(labelEl);
  group.appendChild(textarea);

  return { group, textarea };
}

function getTodayDate() {
  return new Date().toISOString().split('T')[0];
}

function showSuccessAnimation(onDone) {
  const overlay = document.createElement('div');
  overlay.className = 'success-overlay';

  const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  svg.setAttribute('class', 'success-checkmark');
  svg.setAttribute('viewBox', '0 0 52 52');
  svg.setAttribute('aria-hidden', 'true');

  const circle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
  circle.setAttribute('class', 'success-checkmark__circle');
  circle.setAttribute('cx', '26');
  circle.setAttribute('cy', '26');
  circle.setAttribute('r', '25');

  const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
  path.setAttribute('class', 'success-checkmark__check');
  path.setAttribute('d', 'M14.1 27.2l7.1 7.2 16.7-16.8');

  svg.appendChild(circle);
  svg.appendChild(path);
  overlay.appendChild(svg);
  document.body.appendChild(overlay);

  setTimeout(() => {
    overlay.remove();
    onDone();
  }, 750);
}
