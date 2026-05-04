import { getMetrics } from '../services/metricsService.js';
import { getWaterLog, updateWaterLog } from '../services/recipesService.js';
import { getState, setState, subscribe } from '../store/appState.js';
import { calculateBMI, getBMICategory } from '../utils/bmi.js';
import { generateInsights } from '../utils/insights.js';
import { renderChart, destroyChart } from '../components/chart.js';
import { mountProfileMenu } from '../components/profileMenu.js';
import { showToast } from '../components/toast.js';
import { t, formatDate, formatNumber } from '../utils/i18n.js';

const FILTERS = ['7d', '30d', '3m', '1y', 'custom'];

export async function mount(container) {
  const section = document.createElement('section');
  section.className = 'dashboard';

  const header = document.createElement('div');
  header.className = 'dashboard__header';

  const title = document.createElement('h1');
  title.className = 'dashboard__title';
  title.textContent = t('dashboard.title');

  const profileMenuContainer = document.createElement('div');
  profileMenuContainer.className = 'dashboard__profile-menu';

  header.appendChild(title);
  header.appendChild(profileMenuContainer);

  // Metric cards grid
  const metricsGrid = document.createElement('div');
  metricsGrid.className = 'dashboard__metrics';

  const weightCard = makeCard('dashboard__metric-card--weight', t('dashboard.weight'), 'kg', 'weight-value', 'weight-trend', 'weight-date', '⚖️');
  const bmiCard    = makeCard('dashboard__metric-card--bmi', t('dashboard.bmi'), '', 'bmi-value', null, 'bmi-category', '📊');
  const fatCard    = makeCard('dashboard__metric-card--fat', t('dashboard.fat'), '%', 'fat-value', 'fat-trend', null, '🔥');
  const muscleCard = makeCard('dashboard__metric-card--muscle', t('dashboard.muscle'), 'kg', 'muscle-value', 'muscle-trend', null, '💪');

  metricsGrid.appendChild(weightCard);
  metricsGrid.appendChild(bmiCard);
  metricsGrid.appendChild(fatCard);
  metricsGrid.appendChild(muscleCard);

  // Last record line
  const lastRecordEl = document.createElement('p');
  lastRecordEl.className = 'dashboard__last-record';
  lastRecordEl.id = 'last-record-text';

  // Chart section
  const chartSection = document.createElement('div');
  chartSection.className = 'dashboard__chart-section';

  const chartTitle = document.createElement('h2');
  chartTitle.className = 'dashboard__section-title';
  chartTitle.textContent = t('dashboard.evolution');

  const chartWrapper = document.createElement('div');
  chartWrapper.className = 'chart-wrapper';

  // Filter buttons
  const filtersEl = document.createElement('div');
  filtersEl.className = 'chart-filters';

  FILTERS.forEach(f => {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = `chart-filter-btn${f === '30d' ? ' chart-filter-btn--active' : ''}`;
    btn.dataset.filter = f;
    btn.textContent = t(`chart.filter_${f}`);
    filtersEl.appendChild(btn);
  });

  // Custom range inputs (hidden unless custom filter is active)
  const customRange = document.createElement('div');
  customRange.className = 'chart-custom-range';
  customRange.setAttribute('hidden', '');

  const fromInput = document.createElement('input');
  fromInput.type = 'date';
  fromInput.className = 'chart-custom-range__input';
  fromInput.setAttribute('aria-label', t('chart.from'));

  const sep = document.createElement('span');
  sep.className = 'chart-custom-range__sep';
  sep.textContent = '—';
  sep.setAttribute('aria-hidden', 'true');

  const toInput = document.createElement('input');
  toInput.type = 'date';
  toInput.className = 'chart-custom-range__input';
  toInput.setAttribute('aria-label', t('chart.to'));

  const applyBtn = document.createElement('button');
  applyBtn.type = 'button';
  applyBtn.className = 'btn btn--primary btn--sm';
  applyBtn.textContent = t('chart.apply');

  customRange.appendChild(fromInput);
  customRange.appendChild(sep);
  customRange.appendChild(toInput);
  customRange.appendChild(applyBtn);

  const canvas = document.createElement('canvas');
  canvas.id = 'metrics-chart';
  canvas.setAttribute('aria-label', t('dashboard.chart_aria'));
  canvas.setAttribute('role', 'img');

  const emptyChart = document.createElement('div');
  emptyChart.className = 'chart-empty';
  emptyChart.setAttribute('hidden', '');

  chartWrapper.appendChild(filtersEl);
  chartWrapper.appendChild(customRange);
  chartWrapper.appendChild(canvas);
  chartWrapper.appendChild(emptyChart);

  chartSection.appendChild(chartTitle);
  chartSection.appendChild(chartWrapper);

  // Insights section
  const insightsSection = document.createElement('div');
  insightsSection.className = 'dashboard__insights';
  insightsSection.id = 'dashboard-insights';

  // Water log section
  const waterSection = document.createElement('div');
  waterSection.className = 'dashboard__water';

  const waterTitle = document.createElement('h2');
  waterTitle.className = 'dashboard__section-title';
  waterTitle.textContent = t('dashboard.water');

  const waterGoal = document.createElement('p');
  waterGoal.className = 'dashboard__water-goal';
  waterGoal.id = 'water-goal-text';

  const waterGlasses = document.createElement('div');
  waterGlasses.className = 'dashboard__water-glasses';

  for (let i = 0; i < 8; i++) {
    const glass = document.createElement('button');
    glass.type = 'button';
    glass.className = 'dashboard__water-glass';
    glass.dataset.index = String(i);
    glass.textContent = '🥛';
    glass.setAttribute('aria-label', `Vaso ${i + 1}`);
    waterGlasses.appendChild(glass);
  }

  waterSection.appendChild(waterTitle);
  waterSection.appendChild(waterGoal);
  waterSection.appendChild(waterGlasses);

  section.appendChild(header);
  section.appendChild(metricsGrid);
  section.appendChild(lastRecordEl);
  section.appendChild(chartSection);
  section.appendChild(insightsSection);
  section.appendChild(waterSection);
  container.appendChild(section);

  mountProfileMenu(profileMenuContainer);

  // --- Load data ---
  let metrics = getState('metrics');
  let activeFilter = '30d';

  if (!metrics || metrics.length === 0) {
    try {
      metrics = await getMetrics();
      setState('metrics', metrics);
    } catch {
      showToast(t('errors.load_failed'), 'error');
    }
  }

  const profile = getState('profile');

  updateMetricCards(metrics, profile);
  updateInsightsSection(metrics, insightsSection);
  renderChart('metrics-chart', metrics, activeFilter, profile);

  // Filter tab clicks
  filtersEl.addEventListener('click', e => {
    const btn = e.target.closest('.chart-filter-btn');
    if (!btn) return;

    activeFilter = btn.dataset.filter;
    filtersEl.querySelectorAll('.chart-filter-btn').forEach(b => {
      b.classList.toggle('chart-filter-btn--active', b === btn);
    });

    if (activeFilter === 'custom') {
      customRange.removeAttribute('hidden');
    } else {
      customRange.setAttribute('hidden', '');
      renderChart('metrics-chart', metrics, activeFilter, profile);
    }
  });

  applyBtn.addEventListener('click', () => {
    const from = fromInput.value;
    const to = toInput.value;
    if (!from || !to) { showToast(t('chart.error_range_required'), 'error'); return; }
    if (from > to) { showToast(t('chart.error_range_invalid'), 'error'); return; }
    const filtered = metrics.filter(m => m.date >= from && m.date <= to);
    if (filtered.length === 0) { showToast(t('chart.no_data_range'), 'info'); return; }
    renderChart('metrics-chart', filtered, 'custom', profile);
  });

  const unsub = subscribe('metrics', newMetrics => {
    metrics = newMetrics;
    updateMetricCards(newMetrics, profile);
    updateInsightsSection(newMetrics, insightsSection);
    if (activeFilter !== 'custom') renderChart('metrics-chart', newMetrics, activeFilter, profile);
  });

  // --- Water log ---
  const today = new Date().toISOString().split('T')[0];
  let glassCount = 0;

  function renderWaterGlasses() {
    waterGlasses.querySelectorAll('.dashboard__water-glass').forEach((btn, i) => {
      btn.classList.toggle('dashboard__water-glass--filled', i < glassCount);
    });
    const goalEl = document.getElementById('water-goal-text');
    if (goalEl) goalEl.textContent = t('dashboard.water_goal', { glasses: glassCount });
  }

  try {
    const log = await getWaterLog(today);
    glassCount = log?.glasses ?? 0;
  } catch {
    glassCount = 0;
  }
  renderWaterGlasses();

  waterGlasses.addEventListener('click', async e => {
    const btn = e.target.closest('.dashboard__water-glass');
    if (!btn) return;
    const idx = parseInt(btn.dataset.index, 10);
    glassCount = idx < glassCount ? idx : idx + 1;
    renderWaterGlasses();

    if (!prefersReducedMotion) {
      btn.classList.add('dashboard__water-glass--spring');
      btn.addEventListener('animationend', () => {
        btn.classList.remove('dashboard__water-glass--spring');
      }, { once: true });
    }

    try {
      await updateWaterLog(today, glassCount);
    } catch {
      // non-critical, state already updated visually
    }
  });

  return () => {
    unsub();
    destroyChart();
  };
}

function makeCard(modClass, label, unit, valueId, trendId, subtitleId, icon) {
  const card = document.createElement('div');
  card.className = `card dashboard__metric-card ${modClass}`.trim();

  if (icon) {
    const iconEl = document.createElement('span');
    iconEl.className = 'dashboard__card-icon';
    iconEl.setAttribute('aria-hidden', 'true');
    iconEl.textContent = icon;
    card.appendChild(iconEl);
  }

  const labelEl = document.createElement('div');
  labelEl.className = 'card__label';
  labelEl.textContent = label;

  const valueRow = document.createElement('div');
  valueRow.className = 'dashboard__metric-value-row';

  const valueEl = document.createElement('span');
  valueEl.className = 'card__value';
  valueEl.id = valueId;
  valueEl.textContent = '—';

  const unitEl = document.createElement('span');
  unitEl.className = 'card__unit';
  unitEl.textContent = unit;

  valueRow.appendChild(valueEl);
  valueRow.appendChild(unitEl);

  if (trendId) {
    const trendEl = document.createElement('span');
    trendEl.className = 'dashboard__trend';
    trendEl.id = trendId;
    trendEl.setAttribute('aria-hidden', 'true');
    valueRow.appendChild(trendEl);
  }

  card.appendChild(labelEl);
  card.appendChild(valueRow);

  if (subtitleId) {
    const sub = document.createElement('div');
    sub.className = 'card__subtitle';
    sub.id = subtitleId;
    card.appendChild(sub);
  }

  return card;
}

const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

function animateCounter(el, target, formatFn) {
  if (!el || target == null || isNaN(Number(target))) return;
  if (prefersReducedMotion) {
    el.textContent = formatFn ? formatFn(target) : formatNumber(target);
    return;
  }
  const duration = 800;
  const numTarget = Number(target);
  const start = performance.now();

  function step(now) {
    const elapsed = now - start;
    const progress = Math.min(elapsed / duration, 1);
    const eased = 1 - Math.pow(1 - progress, 3);
    el.textContent = (numTarget * eased).toFixed(1);
    if (progress < 1) {
      requestAnimationFrame(step);
    } else {
      el.textContent = formatFn ? formatFn(numTarget) : formatNumber(numTarget);
    }
  }

  requestAnimationFrame(step);
}

function fatThreshold(sex) {
  if (sex === 'male') return 25;
  if (sex === 'female') return 32;
  return 30;
}

function setTrend(elId, diff, invertPositive = false) {
  const el = document.getElementById(elId);
  if (!el) return;
  if (Math.abs(diff) < 0.5) {
    el.textContent = '→';
    el.className = 'dashboard__trend dashboard__trend--neutral';
  } else if (diff > 0) {
    el.textContent = '↑';
    el.className = invertPositive
      ? 'dashboard__trend dashboard__trend--good'
      : 'dashboard__trend dashboard__trend--bad';
  } else {
    el.textContent = '↓';
    el.className = invertPositive
      ? 'dashboard__trend dashboard__trend--bad'
      : 'dashboard__trend dashboard__trend--good';
  }
}

function updateMetricCards(metrics, profile) {
  const latest = metrics[0];
  const prev   = metrics[1] ?? null;

  const weightEl    = document.getElementById('weight-value');
  const weightDate  = document.getElementById('weight-date');
  const bmiEl       = document.getElementById('bmi-value');
  const bmiCat      = document.getElementById('bmi-category');
  const fatEl       = document.getElementById('fat-value');
  const muscleEl    = document.getElementById('muscle-value');
  const lastRecordEl = document.getElementById('last-record-text');

  if (!latest) return;

  // Weight
  if (weightEl) animateCounter(weightEl, latest.weight, formatNumber);
  if (weightDate) weightDate.textContent = latest.date ? formatDate(latest.date) : '';
  if (prev?.weight != null && latest.weight != null) {
    setTrend('weight-trend', latest.weight - prev.weight, false);
  }

  // BMI
  if (bmiEl && profile?.height) {
    const bmi = calculateBMI(latest.weight, profile.height);
    if (bmi) {
      animateCounter(bmiEl, bmi, formatNumber);
    } else {
      bmiEl.textContent = '—';
    }
    bmiEl.style.color = bmi >= 25 ? 'var(--color-danger)' : '';
    const bmiCard = bmiEl.closest('.dashboard__metric-card--bmi');
    if (bmiCard) bmiCard.classList.toggle('bmi--danger', !!bmi && bmi >= 25);
    if (bmiCat) {
      const cat = getBMICategory(bmi);
      bmiCat.textContent = cat ? t(`dashboard.bmi_${cat}`) : '';
    }
  }

  // Fat
  if (fatEl) {
    if (latest.body_fat != null) {
      animateCounter(fatEl, latest.body_fat, formatNumber);
    } else {
      fatEl.textContent = '—';
    }
    const threshold = fatThreshold(profile?.sex);
    fatEl.style.color = (latest.body_fat != null && latest.body_fat > threshold)
      ? 'var(--color-danger)' : '';
  }
  if (prev?.body_fat != null && latest.body_fat != null) {
    setTrend('fat-trend', latest.body_fat - prev.body_fat, false);
  }

  // Muscle
  if (muscleEl) {
    if (latest.muscle_mass != null) {
      animateCounter(muscleEl, latest.muscle_mass, formatNumber);
    } else {
      muscleEl.textContent = '—';
    }
  }
  if (prev?.muscle_mass != null && latest.muscle_mass != null) {
    setTrend('muscle-trend', latest.muscle_mass - prev.muscle_mass, true);
  }

  // Last record: X days ago
  if (lastRecordEl && latest.date) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const recDate = new Date(latest.date + 'T00:00:00');
    const diffDays = Math.round((today - recDate) / 86400000);
    if (diffDays === 0) {
      lastRecordEl.textContent = t('dashboard.last_record_today');
    } else if (diffDays === 1) {
      lastRecordEl.textContent = t('dashboard.last_record', { days: diffDays });
    } else {
      lastRecordEl.textContent = t('dashboard.last_record_plural', { days: diffDays });
    }
  }
}

function updateInsightsSection(metrics, container) {
  while (container.firstChild) container.removeChild(container.firstChild);

  const insights = generateInsights(metrics);
  if (insights.length === 0) return;

  const title = document.createElement('h2');
  title.className = 'dashboard__section-title';
  title.textContent = t('dashboard.insights');
  container.appendChild(title);

  const list = document.createElement('ul');
  list.className = 'dashboard__insights-list';

  insights.forEach(msg => {
    const li = document.createElement('li');
    li.className = 'dashboard__insight-item';
    li.textContent = msg;
    list.appendChild(li);
  });

  container.appendChild(list);
}

