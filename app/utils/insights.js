import { t } from './i18n.js';

export function generateInsights(metrics) {
  if (!metrics || metrics.length < 2) return [];

  const cutoff = new Date();
  cutoff.setDate(cutoff.getDate() - 30);
  const recent = metrics
    .filter(m => new Date(m.date) >= cutoff)
    .sort((a, b) => new Date(a.date) - new Date(b.date));

  if (recent.length < 2) return [];

  const first = recent[0];
  const last = recent[recent.length - 1];
  const insights = [];

  if (first.weight != null && last.weight != null) {
    const diff = +(last.weight - first.weight).toFixed(1);
    if (Math.abs(diff) >= 0.5) {
      const key = diff < 0 ? 'insights.weight_down' : 'insights.weight_up';
      insights.push(t(key, { value: Math.abs(diff) }));
    } else {
      insights.push(t('insights.weight_stable'));
    }
  }

  if (insights.length < 3 && first.body_fat != null && last.body_fat != null) {
    const diff = +(last.body_fat - first.body_fat).toFixed(1);
    if (Math.abs(diff) >= 0.5) {
      const key = diff < 0 ? 'insights.fat_down' : 'insights.fat_up';
      insights.push(t(key, { value: Math.abs(diff) }));
    }
  }

  if (insights.length < 3 && first.muscle_mass != null && last.muscle_mass != null) {
    const diff = +(last.muscle_mass - first.muscle_mass).toFixed(1);
    if (Math.abs(diff) >= 0.3) {
      const key = diff > 0 ? 'insights.muscle_up' : 'insights.muscle_down';
      insights.push(t(key, { value: Math.abs(diff) }));
    } else {
      insights.push(t('insights.muscle_stable'));
    }
  }

  return insights.slice(0, 3);
}
