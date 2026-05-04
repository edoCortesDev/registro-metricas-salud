import supabase from './supabase.js';

export async function getRecipes(category = null) {
  let query = supabase.from('recipes').select('*').order('name_es');
  if (category) query = query.eq('category', category);
  const { data, error } = await query;
  if (error) throw error;
  return data || [];
}

export async function getRecipeById(id) {
  const { data, error } = await supabase
    .from('recipes')
    .select('*, recipe_ingredients(*)')
    .eq('id', id)
    .single();
  if (error) throw error;
  return data;
}

export async function getMealPlan(weekStart) {
  const weekEnd = getWeekEnd(weekStart);
  const { data, error } = await supabase
    .from('meal_plans')
    .select('*, recipes(id, name_es, name_de, calories, category)')
    .gte('date', weekStart)
    .lte('date', weekEnd)
    .order('date');
  if (error) throw error;
  return data || [];
}

export async function addToMealPlan(date, recipeId, servings = 1) {
  const { data, error } = await supabase
    .from('meal_plans')
    .insert({ date, recipe_id: recipeId, servings })
    .select('*, recipes(id, name_es, name_de, calories, category)')
    .single();
  if (error) throw error;
  return data;
}

export async function removeFromMealPlan(id) {
  const { error } = await supabase.from('meal_plans').delete().eq('id', id);
  if (error) throw error;
}

export async function generateShoppingList(weekStart) {
  const mealPlanItems = await getMealPlan(weekStart);
  if (mealPlanItems.length === 0) return [];

  const recipeIds = [...new Set(mealPlanItems.map(mp => mp.recipe_id))];
  const { data: ingredients, error } = await supabase
    .from('recipe_ingredients')
    .select('*')
    .in('recipe_id', recipeIds);
  if (error) throw error;

  const consolidated = {};
  (ingredients || []).forEach(ing => {
    const totalServings = mealPlanItems
      .filter(mp => mp.recipe_id === ing.recipe_id)
      .reduce((sum, mp) => sum + (mp.servings || 1), 0);
    const key = `${ing.name.toLowerCase()}|${ing.unit}`;
    if (!consolidated[key]) {
      consolidated[key] = { name: ing.name, quantity: 0, unit: ing.unit };
    }
    consolidated[key].quantity += (ing.quantity || 0) * totalServings;
  });

  return Object.values(consolidated);
}

export async function getWaterLog(date) {
  const { data, error } = await supabase
    .from('water_logs')
    .select('*')
    .eq('date', date)
    .maybeSingle();
  if (error) throw error;
  return data;
}

export async function updateWaterLog(date, glasses) {
  const { data, error } = await supabase
    .from('water_logs')
    .upsert({ date, glasses }, { onConflict: 'user_id,date' })
    .select()
    .single();
  if (error) throw error;
  return data;
}

function getWeekEnd(weekStart) {
  const d = new Date(weekStart + 'T00:00:00');
  d.setDate(d.getDate() + 6);
  return d.toISOString().split('T')[0];
}
