import {
  Chart,
  LineElement,
  PointElement,
  LineController,
  LinearScale,
  CategoryScale,
  Legend,
  Tooltip,
  Filler,
} from 'chart.js';

Chart.register(LineElement, PointElement, LineController, LinearScale, CategoryScale, Legend, Tooltip, Filler);

import { t } from '../utils/i18n.js';

let chartInstance = null;

export function renderChart(canvasId, metrics, filter = '30d') {
  const canvas = document.getElementById(canvasId);
  if (!canvas) return;

  const filtered = filter === 'custom' ? metrics : filterByRange(metrics, filter);
  const sorted = [...filtered].sort((a, b) => new Date(a.date) - new Date(b.date));

  const labels = sorted.map(m => formatDate(m.date));
  const weightData = sorted.map(m => m.weight ?? null);
  const fatData = sorted.map(m => m.body_fat ?? null);
  const muscleData = sorted.map(m => m.muscle_mass ?? null);

  const isDark = document.documentElement.getAttribute('data-theme') === 'dark' ||
    (!document.documentElement.getAttribute('data-theme') &&
      window.matchMedia('(prefers-color-scheme: dark)').matches);

  const gridColor = isDark ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.06)';
  const tickColor = isDark ? '#94a3b8' : '#666666';

  if (chartInstance) {
    chartInstance.destroy();
    chartInstance = null;
  }

  const ctx = canvas.getContext('2d');
  chartInstance = new Chart(ctx, {
    type: 'line',
    data: {
      labels,
      datasets: [
        {
          label: t('chart.weight'),
          data: weightData,
          borderColor: '#3b82f6',
          backgroundColor: 'rgba(59,130,246,0.08)',
          tension: 0.3,
          fill: false,
          pointRadius: sorted.length > 30 ? 2 : 4,
          spanGaps: true,
        },
        {
          label: t('chart.fat'),
          data: fatData,
          borderColor: '#ef4444',
          backgroundColor: 'rgba(239,68,68,0.08)',
          tension: 0.3,
          fill: false,
          pointRadius: sorted.length > 30 ? 2 : 4,
          spanGaps: true,
        },
        {
          label: t('chart.muscle'),
          data: muscleData,
          borderColor: '#10b981',
          backgroundColor: 'rgba(16,185,129,0.08)',
          tension: 0.3,
          fill: false,
          pointRadius: sorted.length > 30 ? 2 : 4,
          spanGaps: true,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      interaction: { mode: 'index', intersect: false },
      plugins: {
        legend: {
          position: 'bottom',
          labels: { color: tickColor, usePointStyle: true, padding: 16 },
        },
        tooltip: { mode: 'index', intersect: false },
      },
      scales: {
        x: {
          ticks: { color: tickColor, maxTicksLimit: 8 },
          grid: { color: gridColor },
        },
        y: {
          beginAtZero: false,
          ticks: { color: tickColor },
          grid: { color: gridColor },
        },
      },
    },
  });
}

export function destroyChart() {
  if (chartInstance) {
    chartInstance.destroy();
    chartInstance = null;
  }
}

function filterByRange(metrics, filter) {
  const days = { '7d': 7, '30d': 30, '3m': 90, '1y': 365 }[filter] ?? 30;
  const cutoff = new Date();
  cutoff.setDate(cutoff.getDate() - days);
  return metrics.filter(m => new Date(m.date) >= cutoff);
}

function formatDate(dateStr) {
  const [year, month, day] = dateStr.split('-');
  return `${day}/${month}/${year.slice(2)}`;
}
