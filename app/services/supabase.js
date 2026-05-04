import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  // This runs immediately on module load — a missing env var here means the
  // .env file is not being read by Vite. Stop early with a clear message.
  throw new Error(
    `[supabase] Missing environment variables.\n` +
    `  VITE_SUPABASE_URL: ${supabaseUrl ? 'OK' : 'MISSING'}\n` +
    `  VITE_SUPABASE_ANON_KEY: ${supabaseAnonKey ? 'OK' : 'MISSING'}\n` +
    `  → Restart the Vite dev server: npm run dev`
  );
}

const supabase = createClient(supabaseUrl, supabaseAnonKey);

export default supabase;
