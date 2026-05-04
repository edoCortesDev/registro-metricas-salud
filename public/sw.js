// Minimal service worker — enables PWA installability
const CACHE_NAME = 'body-metrics-v2';

self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', e => e.waitUntil(self.clients.claim()));

self.addEventListener('fetch', e => {
  // Only intercept same-origin requests (app assets).
  // Cross-origin requests (Supabase API, CDNs) go through the browser directly
  // so that custom headers like `apikey` and `Authorization` are never stripped.
  if (new URL(e.request.url).origin !== self.location.origin) return;

  e.respondWith(
    fetch(e.request).catch(() =>
      caches.match(e.request).then(cached => cached ?? new Response('', { status: 503 }))
    )
  );
});
