import supabase from './supabase.js';
import { setState } from '../store/appState.js';

export async function signIn(email, password) {
  const { error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) throw error;
}

export async function signUp(email, password) {
  const { error } = await supabase.auth.signUp({ email, password });
  if (error) throw error;
}

export async function getSession() {
  const { data: { session }, error } = await supabase.auth.getSession();
  if (error) throw error;
  return session;
}

export function onAuthStateChange(callback) {
  const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
    setState('user', session?.user ?? null);
    callback(session);
  });
  return subscription;
}

export async function signOut() {
  const { error } = await supabase.auth.signOut();
  if (error) throw error;
}
