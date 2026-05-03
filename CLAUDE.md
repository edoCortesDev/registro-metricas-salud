# CLAUDE.md — Body Metrics Tracker (MVP v1)

Actúa como un equipo senior de frontend, backend y UX/UI.
Construye una aplicación web mobile-first usando HTML, CSS (BEM) y JavaScript vanilla basada en la siguiente especificación.

---

## 1. Product Vision

Aplicación web mobile-first para registrar y visualizar métricas corporales (peso, grasa, masa muscular, etc.) con enfoque en:

- Simplicidad
- Privacidad
- Claridad visual
- Evolución en el tiempo

Debe funcionar como:

- App personal
- Potencial SaaS en el futuro

---

## 2. User Definition

**Tipo de usuario:** Usuario individual autenticado — 1 cuenta = 1 perfil

**Idiomas soportados:**

- Español (`es`)
- Alemán (`de`)

**Selección de idioma:**

- Automática por `navigator.language`
- O manual por el usuario en Settings
- **Fallback:** Español (`es`) si el idioma del navegador no es soportado

---

## 3. Authentication & Security

**Auth via Supabase:**

- Email + OTP (magic link)
- MFA: TOTP via Supabase Authenticator (opcional para el usuario, recomendado activarlo)

**Reglas de sesión:**

- 1 usuario = 1 perfil
- Sesión persistente (localStorage gestionado por Supabase client)

**Seguridad obligatoria — la IA DEBE implementar:**

- Sanitización de inputs (XSS prevention)
- Validación en frontend y backend
- Row Level Security (RLS en Supabase): `user_id = auth.uid()`
- Protección contra:
  - XSS → usar `.textContent` en vez de `.innerHTML` siempre
  - CSRF → usar tokens implícitos de Supabase
  - Injection attacks → validar y escapar todos los inputs
  - Nunca usar `eval()` ni `innerHTML` con datos del usuario

---

## 4. Data Model (Supabase)

### Tabla: `profiles`

```sql
id         uuid PRIMARY KEY REFERENCES auth.users(id)
height     float         -- en cm, editable por el usuario
created_at timestamptz DEFAULT now()
```

### Tabla: `body_metrics`

```sql
id          uuid PRIMARY KEY DEFAULT gen_random_uuid()
user_id     uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE
date        date NOT NULL
weight      float NOT NULL      -- en kg
body_fat    float               -- porcentaje
muscle_mass float               -- en kg
notes       text
created_at  timestamptz DEFAULT now()

UNIQUE (user_id, date)          -- solo 1 registro por día
```

### Índices

```sql
CREATE INDEX idx_body_metrics_user_date ON body_metrics(user_id, date DESC);
```

### RLS Policies

```sql
-- profiles
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own profile"   ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- body_metrics
ALTER TABLE body_metrics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own metrics"   ON body_metrics FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own metrics" ON body_metrics FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own metrics" ON body_metrics FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own metrics" ON body_metrics FOR DELETE USING (auth.uid() = user_id);
```

---

## 5. Business Logic

**Reglas:**

- Un usuario puede: crear, editar y eliminar sus propios registros
- Solo 1 registro por día (constraint en DB + validación en frontend)
- La altura se edita en la pantalla de Settings
- La altura se usa para calcular el IMC

**Cálculo IMC — en `/utils/bmi.js`:**

```js
export function calculateBMI(weightKg, heightCm) {
  if (!heightCm || heightCm <= 0) return null;
  const heightM = heightCm / 100;
  return weightKg / (heightM * heightM);
}
```

---

## 6. First Run / Onboarding

Al detectar el **primer login** de un usuario:

1. Supabase crea el usuario en `auth.users`
2. La app detecta que no existe un registro en `profiles` para ese `user_id`
3. Se muestra una pantalla de onboarding simple con:
   - Campo: altura en cm (requerido para calcular IMC)
   - Botón "Comenzar"
4. Se crea el registro en `profiles`
5. Se redirige al Dashboard

Este flujo debe estar en `/views/onboarding.js` y validado en el App Flow principal.

---

## 7. UX / UI Specification

**Filosofía:** Minimalista, tipo dashboard moderno, sin ruido, mobile-first.

**Dark / Light Mode:**

- Automático: `prefers-color-scheme`
- Override manual por el usuario (guardado en `localStorage`)

### Pantallas

#### 1. Auth
- Login con email (magic link OTP)
- Input simple, feedback claro de envío
- Mensaje de confirmación: "Revisa tu correo"

#### 2. Onboarding (First Run)
- Formulario de altura
- Mensaje de bienvenida
- Solo se muestra una vez

#### 3. Dashboard (Home)
- Peso actual
- IMC actual (calculado)
- Fecha del último registro
- Gráfico principal (línea) con filtros de tiempo
- Sección de Insights (máximo 3 mensajes)

#### 4. Add / Edit Entry
- Formulario:
  - Peso en kg (requerido)
  - Grasa corporal en % (opcional)
  - Masa muscular en kg (opcional)
  - Notas (opcional)
  - Fecha (default: hoy)
- Validación en tiempo real
- Feedback claro en errores

#### 5. Historial
- Lista de registros ordenados por fecha (más reciente primero)
- Cada item: editable y eliminable
- Confirmación antes de eliminar

#### 6. Settings
- Idioma (es / de)
- Altura en cm
- Tema (auto / dark / light)

---

## 8. Design System

**CSS:**

- Metodología BEM obligatoria
- NO inline styles
- NO CSS en HTML (todo en archivos `.css`)

**Tokens en `:root`:**

```css
:root {
  --color-bg:        #ffffff;
  --color-bg-alt:    #f4f4f4;
  --color-text:      #111111;
  --color-text-muted:#666666;
  --color-primary:   #3b82f6;
  --color-secondary: #10b981;
  --color-danger:    #ef4444;
  --color-border:    #e5e7eb;
  --radius:          0.75rem;
  --font-base:       'Inter', system-ui, sans-serif;
}

[data-theme="dark"] {
  --color-bg:        #0f172a;
  --color-bg-alt:    #1e293b;
  --color-text:      #f1f5f9;
  --color-text-muted:#94a3b8;
  --color-border:    #334155;
}
```

---

## 9. Charts

- **Librería:** Chart.js (CDN o npm)
- **Tipo:** Line chart con múltiples datasets

**Datos a mostrar:**

- Peso (kg)
- Grasa corporal (%)
- Masa muscular (kg)

**Filtros de tiempo:**

- 7 días
- 30 días
- 3 meses
- 1 año
- Custom (rango libre con `<input type="date">` nativo × 2: desde / hasta)

**Implementación:** en `/components/chart.js`

---

## 10. Insights (lógica JS en cliente)

Mensajes generados automáticamente en el cliente, **sin llamadas externas**.

**Lógica:** Comparar el primer y último registro dentro de un rango de 30 días.

**Ejemplos de mensajes:**

- "Has bajado 2 kg en los últimos 30 días 💪"
- "Tu grasa corporal ha aumentado un 1.2% este mes"
- "Tu masa muscular se mantiene estable"

**Reglas de visualización:**

- Máximo 3 insights simultáneos
- Mostrados en el Dashboard, debajo de las métricas actuales
- Solo se muestran si hay al menos 2 registros con suficiente diferencia temporal
- Implementar en `/utils/insights.js`

---

## 11. Frontend Architecture (Vanilla JS)

### Estructura de carpetas

```
/app
  /components
    chart.js          ← Chart.js wrapper
    nav.js            ← Navegación / menú
    modal.js          ← Modal reutilizable
    toast.js          ← Notificaciones
  /views
    auth.js
    onboarding.js     ← First run
    dashboard.js
    addEntry.js
    history.js
    settings.js
  /services
    authService.js
    metricsService.js
    profileService.js
  /utils
    bmi.js            ← calculateBMI()
    insights.js       ← lógica de insights
    sanitize.js       ← escape / sanitización
    i18n.js           ← sistema de traducciones
    theme.js          ← dark/light mode
  /store
    appState.js       ← estado global simple (objeto JS con listeners pub/sub)
  /i18n
    es.json
    de.json
  main.js             ← entry point, router, init
```

### Principios

- Separación de responsabilidades
- Evitar lógica en el DOM
- Modularidad (ES Modules nativos)
- No usar frameworks
- No usar `innerHTML` con datos del usuario

---

## 12. Store (Estado Global)

El `/store/appState.js` gestiona el estado global de la app usando un patrón pub/sub simple:

```js
// Ejemplo de estructura
const state = {
  user: null,
  profile: null,
  metrics: [],
  theme: 'auto',
  language: 'es',
};

const listeners = {};

export function getState(key) { return state[key]; }
export function setState(key, value) {
  state[key] = value;
  (listeners[key] || []).forEach(fn => fn(value));
}
export function subscribe(key, fn) {
  listeners[key] = listeners[key] || [];
  listeners[key].push(fn);
}
```

---

## 13. Services Layer

```js
// authService.js   → login, logout, getSession, onAuthStateChange
// metricsService.js → getMetrics, addMetric, updateMetric, deleteMetric
// profileService.js → getProfile, createProfile, updateProfile
```

Cada service usa el cliente de Supabase e incluye manejo de errores.

---

## 14. Supabase Integration

```js
// /services/supabase.js → cliente singleton
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
);

export default supabase;
```

**Módulos a preparar:**

- `auth` → login, logout, MFA
- `database` → CRUD con RLS
- `storage` → preparado para futuro (ej: fotos de progreso). Bucket: `avatars`. No se implementa en MVP pero la estructura debe estar lista.
- `edge functions` → placeholder para lógica futura (ej: notificaciones, reportes)

---

## 15. App Flow

```
1. Usuario abre la app
2. main.js inicializa Supabase y verifica sesión activa
3a. Sin sesión    → vista Auth (login)
3b. Con sesión    → continúa
4. Verificar si existe registro en `profiles`
4a. No existe     → vista Onboarding (crear perfil + altura)
4b. Existe        → continúa
5. Vista Dashboard:
   - Carga último registro
   - Calcula IMC
   - Renderiza gráfico
   - Genera insights
6. Usuario navega a Add Entry → guarda en Supabase
7. Dashboard y gráfico se actualizan automáticamente
```

---

## 16. i18n (Internacionalización)

**Archivos:** `/i18n/es.json` y `/i18n/de.json`

**Estructura:**

```json
{
  "dashboard.title": "Panel principal",
  "dashboard.weight": "Peso",
  "dashboard.bmi": "IMC",
  "entry.add": "Añadir registro",
  "settings.language": "Idioma",
  "insights.weight_down": "Has bajado {value} kg en los últimos 30 días",
  ...
}
```

**Lógica en `/utils/i18n.js`:**

- Detectar `navigator.language`
- Fallback a `es` si el idioma no es soportado
- Función `t(key, params)` para interpolar variables
- Override manual guardado en `localStorage`

---

## 17. Non-Functional Requirements

- Responsive (mobile-first, breakpoint principal: 768px)
- Rápido: carga inicial < 2s
- Accesible: `<label>` en todos los inputs, atributos `aria-*` donde corresponda, contraste WCAG AA
- Sin dependencias de frameworks JS
- Offline básico: fuera del scope del MVP (preparar Service Worker como placeholder comentado)

---

## 18. Error Handling

- Errores de red: mensaje claro + opción de reintentar
- Inputs inválidos: feedback inline (debajo del campo)
- Errores de Supabase: capturar y mostrar mensaje amigable (no exponer detalles internos)
- Toast notifications para acciones exitosas y errores globales (`/components/toast.js`)

---

## 19. Security Implementation Details

La IA DEBE seguir estas reglas sin excepción:

- Usar `.textContent` siempre, **nunca** `.innerHTML` con datos del usuario
- Validar que peso, grasa y masa muscular sean números positivos y razonables
- Escapar todos los inputs antes de mostrarlos en el DOM
- RLS activo en todas las tablas: `user_id = auth.uid()`
- No exponer la Supabase Service Key en el frontend (solo `anon key`)
- Variables de entorno en `.env` (nunca hardcodeadas)
- Sanitización en `/utils/sanitize.js`:

```js
export function sanitizeText(input) {
  const div = document.createElement('div');
  div.textContent = input;
  return div.textContent;
}
```

---

## 20. Deliverables

La IA debe generar, en orden:

1. **Estructura completa del proyecto** (árbol de carpetas y archivos)
2. **Scripts SQL** para Supabase (tablas, índices, RLS policies)
3. **Código HTML** (estructura base, mobile-first)
4. **CSS completo** (BEM, tokens, dark/light mode)
5. **JavaScript modular** (todos los archivos de la arquitectura)
6. **Integración Supabase** (auth, CRUD, storage preparado)
7. **Sistema i18n** (es.json, de.json, utils/i18n.js)
8. **Chart rendering** (Chart.js, filtros de tiempo, custom range)
9. **Insights** (utils/insights.js con lógica JS pura)
10. **Manejo de estado** (store/appState.js)
11. **Instrucciones de instalación** (README.md paso a paso)
12. **Explicación breve de arquitectura**

---

## Checklist final antes de entregar

- [ ] No hay `innerHTML` con datos del usuario
- [ ] Todos los inputs están validados y sanitizados
- [ ] RLS activo en todas las tablas
- [ ] BEM en todo el CSS, sin inline styles
- [ ] i18n implementado con fallback a `es`
- [ ] Onboarding funcional en first run
- [ ] Insights con máximo 3 mensajes en el dashboard
- [ ] Dark/light mode funcional (auto + manual)
- [ ] Chart.js con todos los filtros incluyendo custom range
- [ ] `.env.example` incluido con variables necesarias

## 21. Cambio de Auth — Email + Password

Reemplazar el sistema de Magic Link OTP por Email + Password clásico.

**Motivo:** El plan gratuito de Supabase limita a 2 emails/hora,
lo que bloquea el desarrollo.

**Importante — NO requiere cambios en SQL:**
Supabase gestiona las contraseñas internamente en `auth.users`,
una tabla del sistema que ya existe. No hay que crear tablas nuevas.

**Cambios en Supabase (hacer manualmente antes de ejecutar el código):**
- Authentication → Providers → Email → activar "Email provider"
- Desactivar "Confirm email" para desarrollo (Authentication →
  Providers → Email → desactivar "Confirm email")

**Cambios en el código:**

`authService.js`:
- Eliminar `sendMagicLink(email)`
- Agregar `signIn(email, password)` usando `supabase.auth.signInWithPassword()`
- Agregar `signUp(email, password)` usando `supabase.auth.signUp()`

`views/auth.js`:
- El formulario tiene dos campos: email y password
- Un toggle entre modo "Iniciar sesión" y modo "Registrarse"
- En modo "Registrarse" agregar un tercer campo "Confirmar contraseña"
- Validar que password tenga mínimo 8 caracteres en frontend
- Validar que ambas contraseñas coincidan antes de llamar a signUp
- Usar `sanitizeText()` existente en ambos campos
- Mantener estructura BEM y sistema i18n existente
- NO modificar index.html — el formulario se genera dinámicamente

`i18n/es.json` y `i18n/de.json`:
- Agregar claves nuevas:
  - `auth.password`
  - `auth.confirm_password`
  - `auth.signin`
  - `auth.signup`
  - `auth.toggle_signup`
  - `auth.toggle_signin`
  - `auth.password_min`
  - `auth.password_mismatch`

## 22. Mejoras UI/UX — Sprint 2

### 22.1 Gráfico (components/chart.js)
- Agregar IMC como cuarta línea en el chart
- Ocultar los dos <input type="date"> del rango custom cuando el
  filtro activo NO es "Custom". Solo mostrarse al hacer click en "Custom"
- Mostrar mensaje vacío cuando hay menos de 2 registros:
  clave i18n: `chart.empty_state`
- Si el usuario no tiene altura configurada, omitir línea de IMC
  sin crashear

### 22.2 Dashboard (views/dashboard.js)
- IMC: mostrar en rojo (--color-danger) si BMI >= 25
- Grasa corporal: mostrar en rojo si supera umbral según sexo:
  - Hombre: > 25%
  - Mujer: > 32%
  - Sin sexo configurado: > 30%
- Flechas de tendencia al lado de cada métrica vs registro anterior:
  - Peso y grasa: ↑ rojo si aumentó, ↓ verde si bajó, → gris si diferencia < 0.5
  - Masa muscular: lógica invertida (↑ es positivo en verde)
- Mostrar "Último registro: hace X días" debajo de las métricas
  clave i18n: `dashboard.last_record`

### 22.3 Historial (views/history.js)
- Mostrar IMC calculado en cada fila
- Modal de confirmación de borrado con datos del registro:
  "¿Eliminar registro del {fecha}, {peso}kg?"
  clave i18n: `history.confirm_delete`

### 22.4 Menú de perfil (components/profileMenu.js)
- Botón circular en esquina superior derecha del dashboard
- Avatar: inicial del email en mayúscula como fallback
- Comportamiento según pantalla:
  - Móvil (< 768px): bottom sheet que sube desde abajo con overlay oscuro
  - Desktop (≥ 768px): dropdown flotante debajo del avatar
- Contenido del menú:
  - Nombre de usuario editable inline
  - Acceso a Settings
  - Cambiar contraseña
  - Cerrar sesión
- BEM: `.profile-menu`, `.profile-menu__avatar`,
  `.profile-menu__sheet`, `.profile-menu__item`
- CSS en styles/components/profile-menu.css
- Cerrar al hacer click fuera o en overlay

### 22.5 Auth — Recuperación de contraseña (views/auth.js)
- Link "¿Olvidaste tu contraseña?" debajo del formulario de login
- Al hacer click: campo email + botón "Enviar"
- Usar `supabase.auth.resetPasswordForEmail(email)`
- Claves i18n: `auth.forgot_password`, `auth.reset_sent`,
  `auth.back_to_login`

### 22.6 Cambiar contraseña (views/settings.js)
- Sección "Seguridad" en Settings:
  - Campo nueva contraseña (mín 8 caracteres)
  - Campo confirmar nueva contraseña
  - Botón "Actualizar contraseña"
- Usar `supabase.auth.updateUser({ password: newPassword })`

### 22.7 Perfil — Sexo del usuario
- Agregar campo `sex` a profiles:
```sql
  ALTER TABLE profiles ADD COLUMN sex text 
    CHECK (sex IN ('male', 'female', 'other'));
```
- Selector en onboarding: Hombre / Mujer / Prefiero no decir
- Selector en Settings para cambiarlo después
- Usar para calcular umbral de grasa en dashboard
- Claves i18n: `profile.sex`, `profile.sex_male`,
  `profile.sex_female`, `profile.sex_other`

### 22.8 Validación de registro duplicado (views/addEntry.js)
- Verificar si ya existe registro para la fecha antes de llamar addMetric
- Si existe: mensaje amigable con opción de editar ese registro
- No exponer error 23505 de Supabase al usuario
- Clave i18n: `entry.duplicate_date`

### 22.9 Exportar datos CSV (views/history.js)
- Botón "Exportar CSV" en la vista Historial
- Columnas: fecha, peso, grasa, masa muscular, IMC, notas
- Usar Blob + URL.createObjectURL — sin librerías externas
- Nombre del archivo: `metricas-{fecha-hoy}.csv`
- Clave i18n: `history.export_csv`

### 22.10 PWA — Instalable en móvil
- Crear `/public/manifest.json` con name, short_name,
  start_url, display standalone, theme_color #3b82f6
- Iconos en /public: icon-192.png e icon-512.png
- Service Worker mínimo en /public/sw.js solo para instalabilidad
- Agregar <link rel="manifest"> en index.html
- Registrar SW en main.js

### 22.11 Formato de fechas y números por idioma (utils/i18n.js)
- Usar Intl.DateTimeFormat para fechas:
  - es: 3 de mayo de 2026
  - de: 3. Mai 2026
- Usar Intl.NumberFormat para decimales:
  - es: 75.5 kg
  - de: 75,5 kg
- Crear funciones: `formatDate(date)` y `formatNumber(value, decimals)`
- Reemplazar todos los usos de fechas y números en todas las vistas

### 22.12 Animaciones entre vistas (main.js + styles/base.css)
- Fade in/out de 200ms al cambiar de vista
- Clases CSS: `.view-enter` y `.view-exit` con opacity transition
- Sin librerías de animación — solo CSS transitions
- Respetar prefers-reduced-motion: desactivar si el usuario lo tiene
  configurado en su sistema operativo

---

### SQL adicional — ejecutar en Supabase antes de implementar
```sql
ALTER TABLE profiles ADD COLUMN sex text 
  CHECK (sex IN ('male', 'female', 'other'));
```

### Archivos nuevos a crear
- `app/components/profileMenu.js`
- `styles/components/profile-menu.css`
- `public/manifest.json`
- `public/sw.js`
- `public/icon-192.png`
- `public/icon-512.png`