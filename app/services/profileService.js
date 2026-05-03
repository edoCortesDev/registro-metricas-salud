import supabase from './supabase.js';

export async function getProfile(userId) {
  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', userId)
    .single();

  // PGRST116 = no rows found — expected on first run
  if (error && error.code !== 'PGRST116') throw error;
  return data ?? null;
}

export async function createProfile({ id, height }) {
  const { data, error } = await supabase
    .from('profiles')
    .insert({ id, height })
    .select()
    .single();
  if (error) throw error;
  return data;
}

export async function updateProfile({ id, height }) {
  const { data, error } = await supabase
    .from('profiles')
    .update({ height })
    .eq('id', id)
    .select()
    .single();
  if (error) throw error;
  return data;
}
