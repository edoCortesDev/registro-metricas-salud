# Body Metrics Tracker

App web mobile-first para registrar y visualizar métricas corporales (peso, grasa corporal, masa muscular).

**Stack:** Vanilla JS · Vite · Supabase · Chart.js · BEM CSS

---

## Instalación y configuración

### 1. Clonar e instalar dependencias

```bash
npm install
```

### 2. Configurar Supabase

1. Crea un proyecto en [supabase.com](https://supabase.com)
2. Ve al **SQL Editor** y ejecuta el contenido de `sql/schema.sql`
3. En **Authentication → URL Configuration**, añade la URL de tu app a "Redirect URLs":
   - Desarrollo: `http://localhost:5173`
   - Producción: `https://tu-dominio.com`

### 3. Variables de entorno

```bash
cp .env.example .env
```

Edita `.env` con las credenciales de tu proyecto Supabase (Project Settings → API):

```
VITE_SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ...
```

> **Importante:** Usa solo la `anon key` (pública). Nunca pongas la `service_role key` en el frontend.

### 4. Ejecutar en desarrollo

```bash
npm run dev
```

Abre [http://localhost:5173](http://localhost:5173)

### 5. Compilar para producción

```bash
npm run build
npm run preview   # para previsualizar la build
```

---

## Despliegue

### Netlify / Vercel

1. Conecta tu repositorio
2. Build command: `npm run build`
3. Publish directory: `dist`
4. Añade las variables de entorno en el panel de la plataforma
5. Actualiza la Redirect URL en Supabase con tu dominio de producción

---

## Autenticación (Magic Link + MFA opcional)

El login funciona con **email + OTP (magic link)**:

1. El usuario introduce su correo
2. Supabase envía un email con un enlace
3. Al hacer clic, la app detecta la sesión automáticamente

### Activar MFA (TOTP)

En Supabase → Authentication → MFA, habilita TOTP. Los usuarios podrán activarlo desde su perfil.

---

## Arquitectura

```
app/
├── main.js           Entry point, router hash-based, init flow
├── store/            Estado global pub/sub (sin framework)
├── services/         Supabase CRUD + auth
├── utils/            BMI, insights, i18n, theme, sanitize
├── components/       Toast, Modal, Nav, Chart (reutilizables)
├── views/            Auth, Onboarding, Dashboard, AddEntry, History, Settings
└── i18n/             es.json, de.json

styles/
├── tokens.css        Variables CSS (colores, fuentes, radios)
├── reset.css / base.css / layout.css
├── components/       BEM CSS por componente
└── views/            BEM CSS por vista
```

### App Flow

```
Abrir app
  → main.js verifica sesión
  → Sin sesión   → #/auth
  → Con sesión   → ¿Tiene perfil?
                     No  → #/onboarding (crear perfil)
                     Sí  → #/dashboard
```

### Seguridad implementada

- `.textContent` siempre, nunca `.innerHTML` con datos del usuario
- Sanitización en `utils/sanitize.js`
- RLS en todas las tablas de Supabase (`user_id = auth.uid()`)
- Validación de inputs con rangos razonables
- Variables de entorno (nunca hardcoded en código)
- `anon key` solo (no `service_role key`)
