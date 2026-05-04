// CSS imports — Vite bundles these
import '../styles/tokens.css';
import '../styles/reset.css';
import '../styles/base.css';
import '../styles/layout.css';
import '../styles/components/button.css';
import '../styles/components/form.css';
import '../styles/components/card.css';
import '../styles/components/modal.css';
import '../styles/components/toast.css';
import '../styles/components/nav.css';
import '../styles/components/chart.css';
import '../styles/components/profile-menu.css';
import '../styles/views/auth.css';
import '../styles/views/onboarding.css';
import '../styles/views/dashboard.css';
import '../styles/views/addEntry.css';
import '../styles/views/history.css';
import '../styles/views/settings.css';
import '../styles/views/recipes.css';
import '../styles/views/recipe-detail.css';
import '../styles/views/meal-plan.css';
import '../styles/views/shopping-list.css';

import { initTheme } from './utils/theme.js';
import { initI18n } from './utils/i18n.js';
import { onAuthStateChange, getSession } from './services/authService.js';
import { getProfile } from './services/profileService.js';
import { getState, setState } from './store/appState.js';
import { mountNav } from './components/nav.js';

import { mount as mountAuth } from './views/auth.js';
import { mount as mountOnboarding } from './views/onboarding.js';
import { mount as mountDashboard } from './views/dashboard.js';
import { mount as mountAddEntry } from './views/addEntry.js';
import { mount as mountHistory } from './views/history.js';
import { mount as mountSettings } from './views/settings.js';
import { mount as mountRecipes } from './views/recipes.js';
import { mount as mountRecipeDetail } from './views/recipeDetail.js';
import { mount as mountMealPlan } from './views/mealPlan.js';
import { mount as mountShoppingList } from './views/shoppingList.js';

const routes = {
  '#/auth':           { mount: mountAuth,          protected: false, hideNav: true },
  '#/onboarding':     { mount: mountOnboarding,    protected: true,  hideNav: true },
  '#/dashboard':      { mount: mountDashboard,     protected: true,  hideNav: false },
  '#/add':            { mount: mountAddEntry,      protected: true,  hideNav: false },
  '#/history':        { mount: mountHistory,       protected: true,  hideNav: false },
  '#/settings':       { mount: mountSettings,      protected: true,  hideNav: false },
  '#/recipes':        { mount: mountRecipes,       protected: true,  hideNav: false },
  '#/recipe-detail':  { mount: mountRecipeDetail,  protected: true,  hideNav: false },
  '#/meal-plan':      { mount: mountMealPlan,      protected: true,  hideNav: false },
  '#/shopping-list':  { mount: mountShoppingList,  protected: true,  hideNav: false },
};

const appView = document.getElementById('app-view');
const appNav  = document.getElementById('app-nav');

let currentDestroyFn = null;
let navController = null;

async function router() {
  const rawHash = location.hash || '#/';
  const hashBase = '#' + rawHash.replace('#', '').split('?')[0];
  const route = routes[hashBase];

  if (!route) {
    const defaultHash = getState('user') ? '#/dashboard' : '#/auth';
    location.hash = defaultHash;
    return;
  }

  if (route.protected && !getState('user')) {
    location.hash = '#/auth';
    return;
  }

  const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  if (currentDestroyFn) {
    currentDestroyFn();
    currentDestroyFn = null;
  }

  if (!prefersReduced && appView.firstChild) {
    appView.classList.add('view-exit');
    await new Promise(r => setTimeout(r, 200));
    appView.classList.remove('view-exit');
  }

  while (appView.firstChild) appView.removeChild(appView.firstChild);

  if (navController) {
    if (route.hideNav) navController.hide();
    else navController.show();
  }

  currentDestroyFn = await route.mount(appView) || (() => {});

  if (!prefersReduced) {
    appView.classList.add('view-enter');
    appView.addEventListener('animationend', () => appView.classList.remove('view-enter'), { once: true });
  }
}

async function init() {
  // 1. Theme first — prevents dark mode flash
  initTheme();

  // 2. i18n before any render
  await initI18n();

  // 3. Mount nav (hidden by default)
  navController = mountNav(appNav);
  navController.hide();

  // 4. Auth state listener — single source of truth for session changes
  const subscription = onAuthStateChange(async (session) => {
    if (!session) {
      if (location.hash !== '#/auth') location.hash = '#/auth';
      return;
    }

    try {
      const profile = await getProfile(session.user.id);
      setState('profile', profile);

      if (!profile) {
        location.hash = '#/onboarding';
      } else if (!location.hash || location.hash === '#/' || location.hash === '#/auth') {
        location.hash = '#/dashboard';
      }
    } catch {
      location.hash = '#/auth';
    }
  });

  // 5. Check existing session (page reload case)
  try {
    const session = await getSession();
    if (!session) {
      if (!location.hash || location.hash === '#/') location.hash = '#/auth';
    } else {
      setState('user', session.user);
      const profile = await getProfile(session.user.id);
      setState('profile', profile);

      if (!profile) {
        location.hash = '#/onboarding';
      } else if (!location.hash || location.hash === '#/' || location.hash === '#/auth') {
        location.hash = '#/dashboard';
      }
    }
  } catch {
    location.hash = '#/auth';
  }

  // 6. Start router
  window.addEventListener('hashchange', router);
  await router();
}

init();

// ── Ripple effect on .btn--primary clicks ────────────────────────
document.addEventListener('click', e => {
  const btn = e.target.closest('.btn--primary');
  if (!btn || window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  const rect = btn.getBoundingClientRect();
  const ripple = document.createElement('span');
  ripple.className = 'btn__ripple';
  ripple.style.setProperty('--ripple-x', `${e.clientX - rect.left}px`);
  ripple.style.setProperty('--ripple-y', `${e.clientY - rect.top}px`);
  btn.appendChild(ripple);
  ripple.addEventListener('animationend', () => ripple.remove(), { once: true });
});

if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js').catch(() => {});
  });
}
