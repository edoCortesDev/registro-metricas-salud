import { deleteMetric } from '../services/metricsService.js';
import { getState, setState, subscribe } from '../store/appState.js';
import { calculateBMI } from '../utils/bmi.js';
import { createModal } from '../components/modal.js';
import { showToast } from '../components/toast.js';
import { t, formatDate, formatNumber } from '../utils/i18n.js';

export async function mount(container) {
  const section = document.createElement('section');
  section.className = 'history';

  const header = document.createElement('div');
  header.className = 'history__header';

  const title = document.createElement('h1');
  title.className = 'history__title';
  title.textContent = t('history.title');

  const exportBtn = document.createElement('button');
  exportBtn.type = 'button';
  exportBtn.className = 'btn btn--secondary btn--sm';
  exportBtn.textContent = t('history.export_csv');

  header.appendChild(title);
  header.appendChild(exportBtn);

  const listContainer = document.createElement('div');
  listContainer.className = 'history__list-container';

  section.appendChild(header);
  section.appendChild(listContainer);
  container.appendChild(section);

  const profile = getState('profile');

  const renderList = (metrics) => {
    while (listContainer.firstChild) listContainer.removeChild(listContainer.firstChild);

    if (!metrics || metrics.length === 0) {
      const empty = document.createElement('div');
      empty.className = 'history__empty';
      empty.textContent = t('history.empty');
      listContainer.appendChild(empty);
      return;
    }

    const list = document.createElement('ul');
    list.className = 'history__list';

    const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    metrics.forEach((entry, index) => {
      list.appendChild(buildHistoryItem(entry, profile, index, prefersReduced));
    });

    listContainer.appendChild(list);

    list.addEventListener('click', async e => {
      const editBtn = e.target.closest('[data-action="edit"]');
      const deleteBtn = e.target.closest('[data-action="delete"]');

      if (editBtn) {
        location.hash = `#/add?id=${editBtn.dataset.id}`;
      }

      if (deleteBtn) {
        const id = deleteBtn.dataset.id;
        const itemDate = deleteBtn.dataset.date;
        const itemWeight = deleteBtn.dataset.weight;

        createModal({
          title: t('history.confirm_delete_title'),
          body: t('history.confirm_delete', { date: itemDate, weight: itemWeight }),
          confirmText: t('common.delete'),
          cancelText: t('common.cancel'),
          confirmDanger: true,
          onConfirm: async () => {
            try {
              await deleteMetric(id);
              const updated = getState('metrics').filter(m => m.id !== id);
              setState('metrics', updated);
              showToast(t('history.deleted'), 'success');
            } catch {
              showToast(t('errors.generic'), 'error');
            }
          },
        });
      }
    });
  };

  renderList(getState('metrics'));

  const unsub = subscribe('metrics', renderList);

  exportBtn.addEventListener('click', () => {
    exportCSV(getState('metrics'), profile);
  });

  return () => unsub();
}

const SWIPE_REVEAL_WIDTH = 160;
const SWIPE_THRESHOLD    = 80;

function buildHistoryItem(entry, profile, index = 0, prefersReduced = false) {
  const li = document.createElement('li');
  li.className = 'history__item history__item--animated';
  li.dataset.id = entry.id;
  if (!prefersReduced) {
    li.style.setProperty('--history-delay', `${Math.min(index * 80, 720)}ms`);
  }

  // ── Swipe-reveal buttons (behind the content on mobile) ─────────
  const swipeActions = document.createElement('div');
  swipeActions.className = 'history__swipe-actions';
  swipeActions.setAttribute('aria-hidden', 'true');

  const swipeEditBtn = document.createElement('button');
  swipeEditBtn.type = 'button';
  swipeEditBtn.className = 'history__swipe-btn history__swipe-btn--edit';
  swipeEditBtn.dataset.action = 'edit';
  swipeEditBtn.dataset.id = entry.id;
  swipeEditBtn.textContent = t('common.edit');

  const swipeDelBtn = document.createElement('button');
  swipeDelBtn.type = 'button';
  swipeDelBtn.className = 'history__swipe-btn history__swipe-btn--delete';
  swipeDelBtn.dataset.action = 'delete';
  swipeDelBtn.dataset.id = entry.id;
  swipeDelBtn.dataset.date = formatDate(entry.date);
  swipeDelBtn.dataset.weight = entry.weight != null ? entry.weight.toFixed(1) : '—';
  swipeDelBtn.textContent = t('common.delete');

  swipeActions.appendChild(swipeEditBtn);
  swipeActions.appendChild(swipeDelBtn);

  // ── Swipe content wrapper ────────────────────────────────────────
  const swipeContent = document.createElement('div');
  swipeContent.className = 'history__swipe-content';

  const itemHeader = document.createElement('div');
  itemHeader.className = 'history__item-header';

  const date = document.createElement('span');
  date.className = 'history__item-date';
  date.textContent = formatDate(entry.date);

  const actions = document.createElement('div');
  actions.className = 'history__item-actions';

  const editBtn = document.createElement('button');
  editBtn.type = 'button';
  editBtn.className = 'btn btn--sm btn--secondary';
  editBtn.dataset.action = 'edit';
  editBtn.dataset.id = entry.id;
  editBtn.textContent = t('common.edit');
  editBtn.setAttribute('aria-label', `${t('common.edit')} ${formatDate(entry.date)}`);

  const deleteBtn = document.createElement('button');
  deleteBtn.type = 'button';
  deleteBtn.className = 'btn btn--sm btn--danger';
  deleteBtn.dataset.action = 'delete';
  deleteBtn.dataset.id = entry.id;
  deleteBtn.dataset.date = formatDate(entry.date);
  deleteBtn.dataset.weight = entry.weight != null ? entry.weight.toFixed(1) : '—';
  deleteBtn.textContent = t('common.delete');
  deleteBtn.setAttribute('aria-label', `${t('common.delete')} ${formatDate(entry.date)}`);

  actions.appendChild(editBtn);
  actions.appendChild(deleteBtn);
  itemHeader.appendChild(date);
  itemHeader.appendChild(actions);

  const metrics = document.createElement('div');
  metrics.className = 'history__item-metrics';

  const bmi = profile?.height ? calculateBMI(entry.weight, profile.height) : null;

  if (bmi) {
    if (bmi < 25) swipeContent.classList.add('history__swipe-content--bmi-normal');
    else if (bmi < 30) swipeContent.classList.add('history__swipe-content--bmi-overweight');
    else swipeContent.classList.add('history__swipe-content--bmi-obese');
  }

  const metricItems = [
    { label: t('dashboard.weight'), value: entry.weight, unit: 'kg' },
    { label: t('dashboard.fat'), value: entry.body_fat, unit: '%' },
    { label: t('dashboard.muscle'), value: entry.muscle_mass, unit: 'kg' },
    { label: t('dashboard.bmi'), value: bmi, unit: '' },
  ];

  metricItems.forEach(({ label, value, unit }) => {
    if (value == null) return;
    const chip = document.createElement('span');
    chip.className = 'history__metric-chip';
    const lbl = document.createElement('span');
    lbl.className = 'history__metric-label';
    lbl.textContent = label;
    const val = document.createElement('span');
    val.className = 'history__metric-value';
    val.textContent = unit ? `${formatNumber(value)} ${unit}` : formatNumber(value);
    chip.appendChild(lbl);
    chip.appendChild(val);
    metrics.appendChild(chip);
  });

  swipeContent.appendChild(itemHeader);
  swipeContent.appendChild(metrics);

  if (entry.notes) {
    const notes = document.createElement('p');
    notes.className = 'history__item-notes';
    notes.textContent = entry.notes;
    swipeContent.appendChild(notes);
  }

  li.appendChild(swipeActions);
  li.appendChild(swipeContent);

  addSwipeBehavior(li, swipeContent);

  return li;
}

function addSwipeBehavior(li, content) {
  let startX = 0, startY = 0, baseX = 0, isRevealed = false, didSwipe = false;

  content.addEventListener('touchstart', e => {
    startX = e.touches[0].clientX;
    startY = e.touches[0].clientY;
    baseX  = isRevealed ? -SWIPE_REVEAL_WIDTH : 0;
    didSwipe = false;
    content.style.transition = 'none';
  }, { passive: true });

  content.addEventListener('touchmove', e => {
    const dx = e.touches[0].clientX - startX;
    const dy = e.touches[0].clientY - startY;
    if (!didSwipe && Math.abs(dy) > Math.abs(dx)) return;
    didSwipe = true;
    const newX = Math.max(-SWIPE_REVEAL_WIDTH, Math.min(0, baseX + dx));
    content.style.transform = `translateX(${newX}px)`;
  }, { passive: true });

  content.addEventListener('touchend', e => {
    if (!didSwipe) return;
    content.style.transition = '';
    const dx = e.changedTouches[0].clientX - startX;
    const finalX = baseX + dx;

    if (finalX < -SWIPE_THRESHOLD) {
      content.style.transform = `translateX(-${SWIPE_REVEAL_WIDTH}px)`;
      isRevealed = true;
    } else {
      content.style.transform = 'translateX(0)';
      isRevealed = false;
    }
  });

  // Close swipe when touching outside
  document.addEventListener('touchstart', e => {
    if (isRevealed && !li.contains(e.target)) {
      content.style.transition = '';
      content.style.transform = 'translateX(0)';
      isRevealed = false;
    }
  }, { passive: true });
}

function exportCSV(metrics, profile) {
  const heightCm = profile?.height ?? null;
  const headers = ['fecha', 'peso_kg', 'grasa_%', 'musculo_kg', 'imc', 'notas'];
  const rows = metrics.map(m => {
    const bmi = heightCm ? calculateBMI(m.weight, heightCm) : null;
    return [
      m.date,
      m.weight ?? '',
      m.body_fat ?? '',
      m.muscle_mass ?? '',
      bmi ? bmi.toFixed(1) : '',
      (m.notes ?? '').replace(/"/g, '""'),
    ].map(v => `"${v}"`).join(',');
  });

  const csv = [headers.join(','), ...rows].join('\n');
  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const today = new Date().toISOString().split('T')[0];

  const a = document.createElement('a');
  a.href = url;
  a.download = `metricas-${today}.csv`;
  a.click();
  URL.revokeObjectURL(url);
}

