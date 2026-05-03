import { getMetrics } from '../services/metricsService.js';
import { getState, setState, subscribe } from '../store/appState.js';
import { calculateBMI, getBMICategory } from '../utils/bmi.js';
import { generateInsights } from '../utils/insights.js';
import { renderChart, destroyChart } from '../components/chart.js';
import { showToast } from '../components/toast.js';
import { t } from '../utils/i18n.js';

const FILTERS = ['7d', '30d', '3m', '1y', 'custom'];

export async function mount(container) {
  const section = document.createElement('section');
  section.className = 'dashboard';

  const header = document.createElement('div');
  header.className = 'dashboard__header';

  const title = document.createElement('h1');
  title.className = 'dashboard__title';
  title.textContent = t('dashboard.title');

  const addBtn = document.createElement('a');
  addBtn.href = '#/add';
  addBtn.className = 'btn btn--primary btn--sm';
  addBtn.textContent = t('entry.add');

  header.appendChild(title);
  header.appendChild(addBtn);

  // Metric cards grid
  const metricsGrid = document.createElement('div');
  metricsGrid.className = 'dashboard__metrics';

  const weightCard = makeCard('card--primary', t('dashboard.weight'), '', 'kg', 'weight-value', 'weight-date');
  const bmiCard = makeCard('', t('dashboard.bmi'), '', '', 'bmi-value', 'bmi-category');
  const fatCard = makeCard('', t('dashboard.fat'), '', '%', 'fat-value', null);
  const muscleCard = makeCard('card--success', t('dashboard.muscle'), '', 'kg', 'muscle-value', null);

  metricsGrid.appendChild(weightCard);
  metricsGrid.appendChild(bmiCard);
  metricsGrid.appendChild(fatCard);
  metricsGrid.appendChild(muscleCard);

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

  // Custom range inputs
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
  emptyChart.textContent = t('dashboard.no_data');

  chartWrapper.appendChild(filtersEl);
  chartWrapper.appendChild(customRange);
  chartWrapper.appendChild(canvas);
  chartWrapper.appendChild(emptyChart);
  emptyChart.setAttribute('hidden', '');

  chartSection.appendChild(chartTitle);
  chartSection.appendChild(chartWrapper);

  // Insights section
  const insightsSection = document.createElement('div');
  insightsSection.className = 'dashboard__insights';
  insightsSection.id = 'dashboard-insights';

  section.appendChild(header);
  section.appendChild(metricsGrid);
  section.appendChild(chartSection);
  section.appendChild(insightsSection);
  container.appendChild(section);

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

  updateMetricCards(metrics);
  updateInsightsSection(metrics, insightsSection);

  if (metrics.length === 0) {
    emptyChart.removeAttribute('hidden');
    canvas.setAttribute('hidden', '');
  } else {
    renderChart('metrics-chart', metrics, activeFilter);
  }

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
      if (metrics.length > 0) renderChart('metrics-chart', metrics, activeFilter);
    }
  });

  applyBtn.addEventListener('click', () => {
    const from = fromInput.value;
    const to = toInput.value;
    if (!from || !to) { showToast(t('chart.error_range_required'), 'error'); return; }
    if (from > to) { showToast(t('chart.error_range_invalid'), 'error'); return; }
    const filtered = metrics.filter(m => m.date >= from && m.date <= to);
    if (filtered.length === 0) { showToast(t('chart.no_data_range'), 'info'); return; }
    renderChart('metrics-chart', filtered, 'custom');
  });

  const unsub = subscribe('metrics', newMetrics => {
    metrics = newMetrics;
    updateMetricCards(newMetrics);
    updateInsightsSection(newMetrics, insightsSection);
    if (newMetrics.length > 0) {
      canvas.removeAttribute('hidden');
      emptyChart.setAttribute('hidden', '');
      if (activeFilter !== 'custom') renderChart('metrics-chart', newMetrics, activeFilter);
    }
  });

  return () => {
    unsub();
    destroyChart();
  };
}

function makeCard(extraClass, label, value, unit, valueId, subtitleId) {
  const card = document.createElement('div');
  card.className = `card dashboard__metric-card ${extraClass}`.trim();

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

function updateMetricCards(metrics) {
  const latest = metrics[0];
  const profile = getState('profile');

  const weightEl = document.getElementById('weight-value');
  const weightDate = document.getElementById('weight-date');
  const bmiEl = document.getElementById('bmi-value');
  const bmiCat = document.getElementById('bmi-category');
  const fatEl = document.getElementById('fat-value');
  const muscleEl = document.getElementById('muscle-value');

  if (!latest) return;

  if (weightEl) weightEl.textContent = latest.weight != null ? latest.weight.toFixed(1) : '—';
  if (weightDate) weightDate.textContent = latest.date ? formatDate(latest.date) : '';
  if (fatEl) fatEl.textContent = latest.body_fat != null ? latest.body_fat.toFixed(1) : '—';
  if (muscleEl) muscleEl.textContent = latest.muscle_mass != null ? latest.muscle_mass.toFixed(1) : '—';

  if (bmiEl && profile?.height) {
    const bmi = calculateBMI(latest.weight, profile.height);
    bmiEl.textContent = bmi ? bmi.toFixed(1) : '—';
    if (bmiCat) {
      const cat = getBMICategory(bmi);
      bmiCat.textContent = cat ? t(`dashboard.bmi_${cat}`) : '';
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

function formatDate(dateStr) {
  const [year, month, day] = dateStr.split('-');
  return `${day}/${month}/${year}`;
}
