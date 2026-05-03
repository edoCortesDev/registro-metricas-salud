import { deleteMetric } from '../services/metricsService.js';
import { getState, setState, subscribe } from '../store/appState.js';
import { createModal } from '../components/modal.js';
import { showToast } from '../components/toast.js';
import { t } from '../utils/i18n.js';

export async function mount(container) {
  const section = document.createElement('section');
  section.className = 'history';

  const header = document.createElement('div');
  header.className = 'history__header';

  const title = document.createElement('h1');
  title.className = 'history__title';
  title.textContent = t('history.title');

  header.appendChild(title);

  const listContainer = document.createElement('div');
  listContainer.className = 'history__list-container';

  section.appendChild(header);
  section.appendChild(listContainer);
  container.appendChild(section);

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

    metrics.forEach(entry => {
      list.appendChild(buildHistoryItem(entry));
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

        createModal({
          title: t('history.confirm_delete_title'),
          body: t('history.confirm_delete_body', { date: itemDate }),
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

  return () => unsub();
}

function buildHistoryItem(entry) {
  const li = document.createElement('li');
  li.className = 'history__item';
  li.dataset.id = entry.id;

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
  deleteBtn.textContent = t('common.delete');
  deleteBtn.setAttribute('aria-label', `${t('common.delete')} ${formatDate(entry.date)}`);

  actions.appendChild(editBtn);
  actions.appendChild(deleteBtn);
  itemHeader.appendChild(date);
  itemHeader.appendChild(actions);

  const metrics = document.createElement('div');
  metrics.className = 'history__item-metrics';

  const items = [
    { label: t('dashboard.weight'), value: entry.weight, unit: 'kg' },
    { label: t('dashboard.fat'), value: entry.body_fat, unit: '%' },
    { label: t('dashboard.muscle'), value: entry.muscle_mass, unit: 'kg' },
  ];

  items.forEach(({ label, value, unit }) => {
    if (value == null) return;
    const chip = document.createElement('span');
    chip.className = 'history__metric-chip';
    const lbl = document.createElement('span');
    lbl.className = 'history__metric-label';
    lbl.textContent = label;
    const val = document.createElement('span');
    val.className = 'history__metric-value';
    val.textContent = `${value.toFixed(1)} ${unit}`;
    chip.appendChild(lbl);
    chip.appendChild(val);
    metrics.appendChild(chip);
  });

  li.appendChild(itemHeader);
  li.appendChild(metrics);

  if (entry.notes) {
    const notes = document.createElement('p');
    notes.className = 'history__item-notes';
    notes.textContent = entry.notes;
    li.appendChild(notes);
  }

  return li;
}

function formatDate(dateStr) {
  const [year, month, day] = dateStr.split('-');
  return `${day}/${month}/${year}`;
}
