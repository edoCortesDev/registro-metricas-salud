import { getRecipeById, addToMealPlan } from '../services/recipesService.js';
import { getState } from '../store/appState.js';
import { showToast } from '../components/toast.js';
import { t, formatNumber } from '../utils/i18n.js';

const MACRO_CLASSES = {
  'recipe.calories': 'recipe-detail__macro--calories',
  'recipe.protein':  'recipe-detail__macro--protein',
  'recipe.fat':      'recipe-detail__macro--fat',
  'recipe.carbs':    'recipe-detail__macro--carbs',
};

export async function mount(container) {
  const params = new URLSearchParams(location.hash.split('?')[1] || '');
  const id = params.get('id');

  if (!id) {
    location.hash = '#/recipes';
    return;
  }

  const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  const section = document.createElement('section');
  section.className = 'recipe-detail';

  const backBtn = document.createElement('a');
  backBtn.href = '#/recipes';
  backBtn.className = 'recipe-detail__back btn btn--secondary btn--sm';
  backBtn.textContent = t('common.back');

  const loadingEl = document.createElement('div');
  loadingEl.className = 'recipe-detail__loading';
  loadingEl.textContent = '…';

  section.appendChild(backBtn);
  section.appendChild(loadingEl);
  container.appendChild(section);

  let recipe;
  try {
    recipe = await getRecipeById(id);
  } catch {
    showToast(t('errors.load_failed'), 'error');
    location.hash = '#/recipes';
    return;
  }

  section.removeChild(loadingEl);

  // Add category class for CSS custom properties
  if (recipe.category) {
    section.classList.add(`recipe-detail--${recipe.category}`);
  }

  const lang = getState('language') || 'es';
  const name = lang === 'de' ? (recipe.name_de || recipe.name_es) : (recipe.name_es || recipe.name_de);
  const instructions = lang === 'de'
    ? (recipe.instructions_de || recipe.instructions_es)
    : (recipe.instructions_es || recipe.instructions_de);

  let servings = 1;

  // ── Header ───────────────────────────────────────────────────────
  const header = document.createElement('div');
  header.className = 'recipe-detail__header';

  const titleEl = document.createElement('h1');
  titleEl.className = 'recipe-detail__title';
  titleEl.textContent = name;

  if (recipe.category) {
    const catEl = document.createElement('span');
    catEl.className = 'recipe-detail__category';
    catEl.textContent = t(`recipes.filter_${recipe.category}`);
    header.appendChild(catEl);
  }

  header.appendChild(titleEl);

  // ── Macros ───────────────────────────────────────────────────────
  const macros = document.createElement('div');
  macros.className = 'recipe-detail__macros';

  [
    { key: 'recipe.calories', value: recipe.calories_per_serving, unit: 'kcal' },
    { key: 'recipe.protein',  value: recipe.protein,  unit: 'g' },
    { key: 'recipe.fat',      value: recipe.fat,      unit: 'g' },
    { key: 'recipe.carbs',    value: recipe.carbs,    unit: 'g' },
  ].forEach(({ key, value, unit }) => {
    if (value == null) return;

    const chip = document.createElement('div');
    const modClass = MACRO_CLASSES[key] || '';
    chip.className = `recipe-detail__macro ${modClass}`.trim();

    const lbl = document.createElement('span');
    lbl.className = 'recipe-detail__macro-label';
    lbl.textContent = t(key);

    const val = document.createElement('span');
    val.className = 'recipe-detail__macro-value';

    const numSpan = document.createElement('span');
    numSpan.className = 'recipe-detail__macro-number';

    const unitSpan = document.createElement('span');
    unitSpan.className = 'recipe-detail__macro-unit';
    unitSpan.textContent = unit;

    val.appendChild(numSpan);
    val.appendChild(unitSpan);
    chip.appendChild(lbl);
    chip.appendChild(val);
    macros.appendChild(chip);

    animateMacro(numSpan, value, prefersReduced);
  });

  // ── Servings control ─────────────────────────────────────────────
  const servingsRow = document.createElement('div');
  servingsRow.className = 'recipe-detail__servings-row';

  const servingsLabel = document.createElement('span');
  servingsLabel.className = 'recipe-detail__servings-label';
  servingsLabel.textContent = t('recipe.servings');

  const decreaseBtn = document.createElement('button');
  decreaseBtn.type = 'button';
  decreaseBtn.className = 'btn btn--secondary btn--sm recipe-detail__servings-btn';
  decreaseBtn.textContent = '−';
  decreaseBtn.setAttribute('aria-label', t('recipe.decrease_servings') || '−');

  const servingsDisplay = document.createElement('span');
  servingsDisplay.className = 'recipe-detail__servings-count';
  servingsDisplay.textContent = String(servings);

  const increaseBtn = document.createElement('button');
  increaseBtn.type = 'button';
  increaseBtn.className = 'btn btn--primary btn--sm recipe-detail__servings-btn';
  increaseBtn.textContent = '+';
  increaseBtn.setAttribute('aria-label', t('recipe.increase_servings') || '+');

  servingsRow.appendChild(servingsLabel);
  servingsRow.appendChild(decreaseBtn);
  servingsRow.appendChild(servingsDisplay);
  servingsRow.appendChild(increaseBtn);

  // ── Ingredients ──────────────────────────────────────────────────
  const ingredientsTitle = document.createElement('h2');
  ingredientsTitle.className = 'recipe-detail__section-title';
  ingredientsTitle.textContent = t('recipe.ingredients');

  const ingredientsList = document.createElement('ul');
  ingredientsList.className = 'recipe-detail__ingredients';

  const ingredients = recipe.recipe_ingredients || [];

  function renderIngredients(flash = false) {
    while (ingredientsList.firstChild) ingredientsList.removeChild(ingredientsList.firstChild);
    ingredients.forEach(ing => {
      const li = document.createElement('li');
      li.className = 'recipe-detail__ingredient';
      const ingName = lang === 'de'
        ? (ing.name_de || ing.name_es || '')
        : (ing.name_es || ing.name_de || '');
      const qty = ing.quantity != null ? formatNumber(ing.quantity * servings, 0) : '';
      li.textContent = `${ingName}${qty ? ` — ${qty} ${ing.unit || ''}`.trim() : ''}`;

      if (flash && !prefersReduced) {
        li.classList.add('recipe-detail__ingredient--flash');
        li.addEventListener('animationend', () => {
          li.classList.remove('recipe-detail__ingredient--flash');
        }, { once: true });
      }

      ingredientsList.appendChild(li);
    });
  }

  renderIngredients();

  decreaseBtn.addEventListener('click', () => {
    if (servings <= 1) return;
    servings--;
    servingsDisplay.textContent = String(servings);
    renderIngredients(true);
  });

  increaseBtn.addEventListener('click', () => {
    servings++;
    servingsDisplay.textContent = String(servings);
    renderIngredients(true);
  });

  // ── Instructions ─────────────────────────────────────────────────
  const instrTitle = document.createElement('h2');
  instrTitle.className = 'recipe-detail__section-title';
  instrTitle.textContent = t('recipe.instructions');

  const instrEl = document.createElement('p');
  instrEl.className = 'recipe-detail__instructions';
  instrEl.textContent = instructions || '';

  // ── Add to plan ──────────────────────────────────────────────────
  const planSection = document.createElement('div');
  planSection.className = 'recipe-detail__plan-section';

  const addToPlanBtn = document.createElement('button');
  addToPlanBtn.type = 'button';
  addToPlanBtn.className = 'btn btn--primary';
  addToPlanBtn.textContent = t('recipe.add_to_plan');

  const planPicker = document.createElement('div');
  planPicker.className = 'recipe-detail__plan-picker';
  planPicker.setAttribute('hidden', '');

  const dateInput = document.createElement('input');
  dateInput.type = 'date';
  dateInput.className = 'recipe-detail__date-input input';
  dateInput.value = new Date().toISOString().split('T')[0];
  dateInput.setAttribute('aria-label', t('entry.date_label'));

  const mealTypeSelect = document.createElement('select');
  mealTypeSelect.className = 'recipe-detail__meal-type-select input';
  mealTypeSelect.setAttribute('aria-label', t('mealplan.meal_type'));
  [
    { value: 'breakfast', label: t('recipes.filter_breakfast') },
    { value: 'lunch',     label: t('recipes.filter_lunch') },
    { value: 'snack',     label: t('recipes.filter_snack') },
  ].forEach(({ value, label }) => {
    const opt = document.createElement('option');
    opt.value = value;
    opt.textContent = label;
    mealTypeSelect.appendChild(opt);
  });

  const confirmPlanBtn = document.createElement('button');
  confirmPlanBtn.type = 'button';
  confirmPlanBtn.className = 'btn btn--primary btn--sm';
  confirmPlanBtn.textContent = t('common.confirm');

  planPicker.appendChild(dateInput);
  planPicker.appendChild(mealTypeSelect);
  planPicker.appendChild(confirmPlanBtn);

  let planPickerOpen = false;

  addToPlanBtn.addEventListener('click', () => {
    planPickerOpen = !planPickerOpen;
    if (planPickerOpen) {
      planPicker.removeAttribute('hidden');
    } else {
      planPicker.setAttribute('hidden', '');
    }
  });

  confirmPlanBtn.addEventListener('click', async () => {
    const date = dateInput.value;
    const mealType = mealTypeSelect.value;
    if (!date || !mealType) return;
    try {
      await addToMealPlan(date, recipe.id, servings, mealType);
      showToast(t('recipe.add_to_plan'), 'success');
      planPicker.setAttribute('hidden', '');
      planPickerOpen = false;
    } catch {
      showToast(t('errors.generic'), 'error');
    }
  });

  planSection.appendChild(addToPlanBtn);
  planSection.appendChild(planPicker);

  section.appendChild(header);
  section.appendChild(macros);
  section.appendChild(servingsRow);
  section.appendChild(ingredientsTitle);
  section.appendChild(ingredientsList);
  section.appendChild(instrTitle);
  section.appendChild(instrEl);
  section.appendChild(planSection);
}

function animateMacro(el, target, prefersReduced) {
  if (!el || target == null) return;
  if (prefersReduced) {
    el.textContent = formatNumber(Number(target), 0);
    return;
  }
  const numTarget = Number(target);
  const duration = 800;
  const start = performance.now();

  function step(now) {
    const elapsed = now - start;
    const progress = Math.min(elapsed / duration, 1);
    const eased = 1 - Math.pow(1 - progress, 3);
    el.textContent = Math.round(numTarget * eased);
    if (progress < 1) {
      requestAnimationFrame(step);
    } else {
      el.textContent = formatNumber(numTarget, 0);
    }
  }

  requestAnimationFrame(step);
}
