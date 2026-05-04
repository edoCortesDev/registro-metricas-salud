import { getState } from '../store/appState.js';
import { t } from '../utils/i18n.js';
import { showToast } from '../components/toast.js';

const STORAGE_KEY = 'shopping-checked';
const GROUP_KEYWORDS = {
  vegetables: ['lechuga','tomate','cebolla','ajo','zanahoria','pimiento','espinaca','brócoli','pepino','apio','calabacín','champiñón','perejil','cilantro','salat','tomato','zwiebel','knoblauch','karotte','paprika','spinat','brokkoli','gurke','sellerie','zucchini','pilz','petersilie'],
  proteins: ['pollo','carne','pescado','atún','huevo','salmón','pavo','cerdo','ternera','tofu','lentejas','garbanzos','frijol','hähnchen','fleisch','fisch','thunfisch','ei','lachs','truthahn','schwein','kalb','linsen','kichererbsen','bohne'],
  dairy: ['leche','yogur','queso','mantequilla','crema','nata','milch','joghurt','käse','butter','sahne'],
};

function getGroup(name) {
  const lower = name.toLowerCase();
  for (const [group, keywords] of Object.entries(GROUP_KEYWORDS)) {
    if (keywords.some(kw => lower.includes(kw))) return group;
  }
  return 'others';
}

function loadChecked() {
  try { return JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}'); } catch { return {}; }
}

function saveChecked(checked) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(checked));
}

export async function mount(container) {
  const section = document.createElement('section');
  section.className = 'shopping-list';

  const header = document.createElement('div');
  header.className = 'shopping-list__header';

  const title = document.createElement('h1');
  title.className = 'shopping-list__title';
  title.textContent = t('shopping.title');

  const exportBtn = document.createElement('button');
  exportBtn.type = 'button';
  exportBtn.className = 'btn btn--secondary btn--sm';
  exportBtn.textContent = t('shopping.export');

  const backBtn = document.createElement('a');
  backBtn.href = '#/meal-plan';
  backBtn.className = 'btn btn--secondary btn--sm';
  backBtn.textContent = t('common.back');

  header.appendChild(backBtn);
  header.appendChild(title);
  header.appendChild(exportBtn);

  const content = document.createElement('div');
  content.className = 'shopping-list__content';

  section.appendChild(header);
  section.appendChild(content);
  container.appendChild(section);

  const items = getState('shoppingList') || [];
  let checked = loadChecked();

  if (items.length === 0) {
    const empty = document.createElement('p');
    empty.className = 'shopping-list__empty';
    empty.textContent = t('shopping.title');
    content.appendChild(empty);
    return;
  }

  const groups = { vegetables: [], proteins: [], dairy: [], others: [] };
  items.forEach(item => {
    const g = getGroup(item.name);
    groups[g].push(item);
  });

  const groupLabels = {
    vegetables: '🥦 Verduras / Gemüse',
    proteins:   '🥩 Proteínas / Proteine',
    dairy:      '🥛 Lácteos / Milchprodukte',
    others:     '🛒 Otros / Sonstiges',
  };

  Object.entries(groups).forEach(([groupKey, groupItems]) => {
    if (groupItems.length === 0) return;

    const groupEl = document.createElement('div');
    groupEl.className = 'shopping-list__group';

    const groupTitle = document.createElement('h2');
    groupTitle.className = 'shopping-list__group-title';
    groupTitle.textContent = groupLabels[groupKey];
    groupEl.appendChild(groupTitle);

    const list = document.createElement('ul');
    list.className = 'shopping-list__items';

    groupItems.forEach(item => {
      const itemKey = `${item.name}|${item.unit}`;
      const li = document.createElement('li');
      li.className = `shopping-list__item${checked[itemKey] ? ' shopping-list__item--checked' : ''}`;

      const checkbox = document.createElement('input');
      checkbox.type = 'checkbox';
      checkbox.className = 'shopping-list__checkbox';
      checkbox.id = `item-${itemKey.replace(/[^a-z0-9]/gi, '-')}`;
      checkbox.checked = !!checked[itemKey];
      checkbox.setAttribute('aria-label', item.name);

      const label = document.createElement('label');
      label.className = 'shopping-list__item-label';
      label.setAttribute('for', checkbox.id);

      const nameSpan = document.createElement('span');
      nameSpan.className = 'shopping-list__item-name';
      nameSpan.textContent = item.name;

      const qtySpan = document.createElement('span');
      qtySpan.className = 'shopping-list__item-qty';
      if (item.quantity) {
        qtySpan.textContent = `${Math.round(item.quantity * 10) / 10} ${item.unit || ''}`.trim();
      }

      label.appendChild(nameSpan);
      label.appendChild(qtySpan);
      li.appendChild(checkbox);
      li.appendChild(label);
      list.appendChild(li);

      checkbox.addEventListener('change', () => {
        if (checkbox.checked) {
          checked[itemKey] = true;
          li.classList.add('shopping-list__item--checked');
        } else {
          delete checked[itemKey];
          li.classList.remove('shopping-list__item--checked');
        }
        saveChecked(checked);
      });
    });

    groupEl.appendChild(list);
    content.appendChild(groupEl);
  });

  exportBtn.addEventListener('click', () => exportTxt(items));
}

function exportTxt(items) {
  const lines = items.map(item => {
    const qty = item.quantity ? `${Math.round(item.quantity * 10) / 10} ${item.unit || ''}`.trim() : '';
    return `- ${item.name}${qty ? `: ${qty}` : ''}`;
  });
  const text = lines.join('\n');
  const blob = new Blob([text], { type: 'text/plain;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const today = new Date().toISOString().split('T')[0];
  const a = document.createElement('a');
  a.href = url;
  a.download = `lista-compras-${today}.txt`;
  a.click();
  URL.revokeObjectURL(url);
}
