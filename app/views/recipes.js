import { getRecipes } from '../services/recipesService.js';
import { getState } from '../store/appState.js';
import { showToast } from '../components/toast.js';
import { t } from '../utils/i18n.js';

const CATEGORIES = ['all', 'breakfast', 'lunch', 'snack'];

export async function mount(container) {
  const section = document.createElement('section');
  section.className = 'recipes';

  const header = document.createElement('div');
  header.className = 'recipes__header';

  const title = document.createElement('h1');
  title.className = 'recipes__title';
  title.textContent = t('recipes.title');

  const mealPlanLink = document.createElement('a');
  mealPlanLink.href = '#/meal-plan';
  mealPlanLink.className = 'btn btn--secondary btn--sm recipes__plan-link';
  mealPlanLink.textContent = t('mealplan.title');

  header.appendChild(title);
  header.appendChild(mealPlanLink);

  const searchInput = document.createElement('input');
  searchInput.type = 'search';
  searchInput.className = 'recipes__search input';
  searchInput.placeholder = t('recipes.search');
  searchInput.setAttribute('aria-label', t('recipes.search'));

  const filters = document.createElement('div');
  filters.className = 'recipes__filters';

  CATEGORIES.forEach(cat => {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = `recipes__filter-btn${cat === 'all' ? ' recipes__filter-btn--active' : ''}`;
    btn.dataset.cat = cat;
    btn.textContent = t(`recipes.filter_${cat}`);
    filters.appendChild(btn);
  });

  const grid = document.createElement('div');
  grid.className = 'recipes__grid';

  section.appendChild(header);
  section.appendChild(searchInput);
  section.appendChild(filters);
  section.appendChild(grid);
  container.appendChild(section);

  let allRecipes = [];
  let activeCategory = 'all';
  let searchQuery = '';

  try {
    allRecipes = await getRecipes();
  } catch {
    showToast(t('errors.load_failed'), 'error');
  }

  const lang = getState('language') || 'es';

  function renderGrid() {
    while (grid.firstChild) grid.removeChild(grid.firstChild);

    const filtered = allRecipes.filter(r => {
      const name = lang === 'de' ? (r.name_de || r.name_es) : (r.name_es || r.name_de);
      const matchesCat = activeCategory === 'all' || r.category === activeCategory;
      const matchesSearch = name.toLowerCase().includes(searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    });

    if (filtered.length === 0) {
      const empty = document.createElement('div');
      empty.className = 'recipes__empty';
      empty.textContent = t('recipes.search');
      grid.appendChild(empty);
      return;
    }

    filtered.forEach(recipe => {
      const name = lang === 'de' ? (recipe.name_de || recipe.name_es) : (recipe.name_es || recipe.name_de);
      const card = document.createElement('a');
      card.href = `#/recipe-detail?id=${recipe.id}`;
      card.className = 'recipe-card';

      const cardName = document.createElement('div');
      cardName.className = 'recipe-card__name';
      cardName.textContent = name;

      const meta = document.createElement('div');
      meta.className = 'recipe-card__meta';

      const cat = document.createElement('span');
      cat.className = 'recipe-card__category';
      cat.textContent = t(`recipes.filter_${recipe.category || 'all'}`);

      const cals = document.createElement('span');
      cals.className = 'recipe-card__calories';
      if (recipe.calories_per_serving != null) {
        cals.textContent = `${recipe.calories_per_serving} kcal`;
      }

      meta.appendChild(cat);
      meta.appendChild(cals);
      card.appendChild(cardName);
      card.appendChild(meta);
      grid.appendChild(card);
    });
  }

  renderGrid();

  filters.addEventListener('click', e => {
    const btn = e.target.closest('.recipes__filter-btn');
    if (!btn) return;
    activeCategory = btn.dataset.cat;
    filters.querySelectorAll('.recipes__filter-btn').forEach(b => {
      b.classList.toggle('recipes__filter-btn--active', b === btn);
    });
    renderGrid();
  });

  searchInput.addEventListener('input', e => {
    searchQuery = e.target.value;
    renderGrid();
  });
}
