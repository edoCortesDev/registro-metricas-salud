// Minimal service worker — enables PWA installability
const CACHE_NAME = 'body-metrics-v1';

self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', e => e.waitUntil(self.clients.claim()));

// No caching strategy in MVP — network first, cache fallback, then 503
self.addEventListener('fetch', e => {
  e.respondWith(
    fetch(e.request).catch(() =>
      caches.match(e.request).then(cached => cached ?? new Response('', { status: 503 }))
    )
  );
});
