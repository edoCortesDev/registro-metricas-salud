import { getMealPlan, removeFromMealPlan, generateShoppingList } from '../services/recipesService.js';
import { getState, setState } from '../store/appState.js';
import { showToast } from '../components/toast.js';
import { t, formatNumber } from '../utils/i18n.js';

const MEAL_TYPES = ['breakfast', 'lunch', 'snack'];
const MEAL_TYPE_KEY = {
  breakfast: 'recipes.filter_breakfast',
  lunch:     'recipes.filter_lunch',
  snack:     'recipes.filter_snack',
};

export async function mount(container) {
  const lang = getState('language') || 'es';
  const locale = lang === 'de' ? 'de-DE' : 'es-ES';

  const section = document.createElement('section');
  section.className = 'meal-plan';

  const header = document.createElement('div');
  header.className = 'meal-plan__header';
  const title = document.createElement('h1');
  title.className = 'meal-plan__title';
  title.textContent = t('mealplan.title');
  header.appendChild(title);
  section.appendChild(header);

  const tableWrap = document.createElement('div');
  tableWrap.className = 'meal-plan__table';
  section.appendChild(tableWrap);

  const footer = document.createElement('div');
  footer.className = 'meal-plan__footer';
  const genShoppingBtn = document.createElement('button');
  genShoppingBtn.type = 'button';
  genShoppingBtn.className = 'btn btn--primary meal-plan__shopping-btn';
  genShoppingBtn.textContent = t('mealplan.generate_shopping');
  footer.appendChild(genShoppingBtn);
  section.appendChild(footer);

  container.appendChild(section);

  // Build 7 dates starting from today
  const today = new Date();
  const weekDates = Array.from({ length: 7 }, (_, i) => {
    const d = new Date(today);
    d.setDate(today.getDate() + i);
    return d;
  });
  const weekStart = today.toISOString().split('T')[0];

  let planItems = [];
  try {
    planItems = await getMealPlan(weekStart);
  } catch {
    showToast(t('errors.load_failed'), 'error');
  }

  function recipeName(item) {
    return lang === 'de'
      ? (item.recipes?.name_de || item.recipes?.name_es || '')
      : (item.recipes?.name_es || item.recipes?.name_de || '');
  }

  function renderTable() {
    while (tableWrap.firstChild) tableWrap.removeChild(tableWrap.firstChild);

    // Column-header row (desktop only, hidden on mobile via CSS)
    const colHeaderRow = document.createElement('div');
    colHeaderRow.className = 'meal-plan__row meal-plan__row--col-headers';
    colHeaderRow.setAttribute('aria-hidden', 'true');

    const corner = document.createElement('div');
    corner.className = 'meal-plan__cell meal-plan__cell--corner';
    colHeaderRow.appendChild(corner);

    MEAL_TYPES.forEach(mt => {
      const ch = document.createElement('div');
      ch.className = 'meal-plan__cell meal-plan__cell--col-header';
      ch.textContent = t(MEAL_TYPE_KEY[mt]);
      colHeaderRow.appendChild(ch);
    });
    tableWrap.appendChild(colHeaderRow);

    // One row per day
    weekDates.forEach(dateObj => {
      const dateStr = dateObj.toISOString().split('T')[0];

      const dayName = new Intl.DateTimeFormat(locale, { weekday: 'long' }).format(dateObj);
      const dayShort = new Intl.DateTimeFormat(locale, { day: 'numeric', month: 'short' }).format(dateObj);

      const dayItems = planItems.filter(p => p.date === dateStr && MEAL_TYPES.includes(p.meal_type));
      const totalCals = dayItems.reduce(
        (sum, p) => sum + (p.recipes?.calories_per_serving || 0) * (p.servings || 1),
        0
      );

      const row = document.createElement('div');
      row.className = 'meal-plan__row';
      row.dataset.date = dateStr;

      // Row header (day name + short date + total kcal)
      const rowHeader = document.createElement('div');
      rowHeader.className = 'meal-plan__cell meal-plan__cell--row-header';

      const nameEl = document.createElement('span');
      nameEl.className = 'meal-plan__day-name';
      nameEl.textContent = dayName.charAt(0).toUpperCase() + dayName.slice(1);

      const dateEl = document.createElement('span');
      dateEl.className = 'meal-plan__day-date';
      dateEl.textContent = dayShort;

      rowHeader.appendChild(nameEl);
      rowHeader.appendChild(dateEl);

      if (totalCals > 0) {
        const totalEl = document.createElement('span');
        totalEl.className = 'meal-plan__day-total';
        totalEl.textContent = `${formatNumber(totalCals, 0)} kcal`;
        rowHeader.appendChild(totalEl);
      }

      row.appendChild(rowHeader);

      // One data cell per meal type
      MEAL_TYPES.forEach(mealType => {
        const cell = document.createElement('div');
        cell.className = 'meal-plan__cell meal-plan__cell--data';
        cell.dataset.date = dateStr;
        cell.dataset.mealType = mealType;

        // Category label (visible only on mobile via CSS)
        const label = document.createElement('span');
        label.className = 'meal-plan__cell-label';
        label.textContent = t(MEAL_TYPE_KEY[mealType]);
        cell.appendChild(label);

        const item = planItems.find(p => p.date === dateStr && p.meal_type === mealType);

        if (item) {
          const name = recipeName(item);
          const cals = (item.recipes?.calories_per_serving || 0) * (item.servings || 1);

          const recipeEl = document.createElement('div');
          recipeEl.className = 'meal-plan__recipe';
          recipeEl.dataset.id = item.id;

          const removeBtn = document.createElement('button');
          removeBtn.type = 'button';
          removeBtn.className = 'meal-plan__remove-btn';
          removeBtn.dataset.id = item.id;
          removeBtn.setAttribute('aria-label', `${t('common.delete')} ${name}`);
          removeBtn.textContent = '✕';

          const nameEl = document.createElement('span');
          nameEl.className = 'meal-plan__recipe-name';
          nameEl.textContent = name;

          const calsEl = document.createElement('span');
          calsEl.className = 'meal-plan__recipe-cals';
          if (cals > 0) calsEl.textContent = `${formatNumber(cals, 0)} kcal`;

          recipeEl.appendChild(removeBtn);
          recipeEl.appendChild(nameEl);
          recipeEl.appendChild(calsEl);
          cell.appendChild(recipeEl);
        } else {
          const addBtn = document.createElement('button');
          addBtn.type = 'button';
          addBtn.className = 'meal-plan__add-btn';
          addBtn.dataset.date = dateStr;
          addBtn.dataset.mealType = mealType;
          addBtn.setAttribute(
            'aria-label',
            `${t('mealplan.add_recipe')} · ${t(MEAL_TYPE_KEY[mealType])} · ${dayName}`
          );
          addBtn.textContent = '+';
          cell.appendChild(addBtn);
        }

        row.appendChild(cell);
      });

      tableWrap.appendChild(row);
    });
  }

  renderTable();

  // Event delegation
  tableWrap.addEventListener('click', async e => {
    const removeBtn = e.target.closest('.meal-plan__remove-btn');
    if (removeBtn) {
      try {
        await removeFromMealPlan(removeBtn.dataset.id);
        planItems = planItems.filter(p => p.id !== removeBtn.dataset.id);
        renderTable();
      } catch {
        showToast(t('errors.generic'), 'error');
      }
      return;
    }

    const addBtn = e.target.closest('.meal-plan__add-btn');
    if (addBtn) {
      const { date, mealType } = addBtn.dataset;
      location.hash = `#/recipes?planDate=${date}&mealType=${mealType}`;
    }
  });

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
