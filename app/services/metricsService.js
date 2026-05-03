import supabase from './supabase.js';

export async function getMetrics({ from, to } = {}) {
  let query = supabase
    .from('body_metrics')
    .select('*')
    .order('date', { ascending: false });

  if (from) query = query.gte('date', from);
  if (to) query = query.lte('date', to);

  const { data, error } = await query;
  if (error) throw error;
  return data || [];
}

export async function addMetric(payload) {
  const { data, error } = await supabase
    .from('body_metrics')
    .insert(payload)
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function updateMetric(id, payload) {
  const { data, error } = await supabase
    .from('body_metrics')
    .update(payload)
    .eq('id', id)
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function deleteMetric(id) {
  const { error } = await supabase
    .from('body_metrics')
    .delete()
    .eq('id', id);
  if (error) throw error;
}
