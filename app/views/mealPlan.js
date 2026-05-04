import { getMealPlan, removeFromMealPlan, generateShoppingList } from '../services/recipesService.js';
import { getState, setState } from '../store/appState.js';
import { showToast } from '../components/toast.js';
import { t, formatDate, formatNumber } from '../utils/i18n.js';

export async function mount(container) {
  const section = document.createElement('section');
  section.className = 'meal-plan';

  const header = document.createElement('div');
  header.className = 'meal-plan__header';

  const title = document.createElement('h1');
  title.className = 'meal-plan__title';
  title.textContent = t('mealplan.title');

  const genShoppingBtn = document.createElement('button');
  genShoppingBtn.type = 'button';
  genShoppingBtn.className = 'btn btn--secondary btn--sm';
  genShoppingBtn.textContent = t('mealplan.generate_shopping');

  header.appendChild(title);
  header.appendChild(genShoppingBtn);

  const daysContainer = document.createElement('div');
  daysContainer.className = 'meal-plan__days';

  section.appendChild(header);
  section.appendChild(daysContainer);
  container.appendChild(section);

  const today = new Date();
  const weekStart = today.toISOString().split('T')[0];
  const lang = getState('language') || 'es';

  let planItems = [];

  try {
    planItems = await getMealPlan(weekStart);
  } catch {
    showToast(t('errors.load_failed'), 'error');
  }

  function renderDays() {
    while (daysContainer.firstChild) daysContainer.removeChild(daysContainer.firstChild);

    for (let i = 0; i < 7; i++) {
      const d = new Date(today);
      d.setDate(today.getDate() + i);
      const dateStr = d.toISOString().split('T')[0];
      const dayItems = planItems.filter(p => p.date === dateStr);

      const dayEl = document.createElement('div');
      dayEl.className = 'meal-plan__day';

      const dayHeader = document.createElement('div');
      dayHeader.className = 'meal-plan__day-header';

      const dayLabel = document.createElement('span');
      dayLabel.className = 'meal-plan__day-label';
      dayLabel.textContent = formatDate(dateStr);

      const totalCals = dayItems.reduce((sum, p) => {
        return sum + ((p.recipes?.calories_per_serving || 0) * (p.servings || 1));
      }, 0);

      const totalEl = document.createElement('span');
      totalEl.className = 'meal-plan__day-total';
      if (totalCals > 0) {
        totalEl.textContent = `${t('mealplan.total_calories')}: ${formatNumber(totalCals, 0)} kcal`;
      }

      dayHeader.appendChild(dayLabel);
      dayHeader.appendChild(totalEl);
      dayEl.appendChild(dayHeader);

      if (dayItems.length === 0) {
        const emptyEl = document.createElement('p');
        emptyEl.className = 'meal-plan__day-empty';
        emptyEl.textContent = '—';
        dayEl.appendChild(emptyEl);
      } else {
        const list = document.createElement('ul');
        list.className = 'meal-plan__recipe-list';

        dayItems.forEach(item => {
          const recipeName = lang === 'de'
            ? (item.recipes?.name_de || item.recipes?.name_es || '')
            : (item.recipes?.name_es || item.recipes?.name_de || '');

          const li = document.createElement('li');
          li.className = 'meal-plan__recipe-item';

          const nameEl = document.createElement('span');
          nameEl.className = 'meal-plan__recipe-name';
          nameEl.textContent = recipeName;

          const calsEl = document.createElement('span');
          calsEl.className = 'meal-plan__recipe-cals';
          const itemCals = (item.recipes?.calories_per_serving || 0) * (item.servings || 1);
          if (itemCals > 0) calsEl.textContent = `${formatNumber(itemCals, 0)} kcal`;

          const removeBtn = document.createElement('button');
          removeBtn.type = 'button';
          removeBtn.className = 'btn btn--danger btn--sm meal-plan__remove-btn';
          removeBtn.dataset.id = item.id;
          removeBtn.textContent = '✕';
          removeBtn.setAttribute('aria-label', `${t('common.delete')} ${recipeName}`);

          li.appendChild(nameEl);
          li.appendChild(calsEl);
          li.appendChild(removeBtn);
          list.appendChild(li);
        });

        list.addEventListener('click', async e => {
          const btn = e.target.closest('.meal-plan__remove-btn');
          if (!btn) return;
          try {
            await removeFromMealPlan(btn.dataset.id);
            planItems = planItems.filter(p => p.id !== btn.dataset.id);
            renderDays();
          } catch {
            showToast(t('errors.generic'), 'error');
          }
        });

        dayEl.appendChild(list);
      }

      daysContainer.appendChild(dayEl);
    }
  }

  renderDays();

  genShoppingBtn.addEventListener('click', async () => {
    try {
      const list = await generateShoppingList(weekStart);
      setState('shoppingList', list);
      location.hash = '#/shopping-list';
    } catch {
      showToast(t('errors.generic'), 'error');
    }
  });
}
