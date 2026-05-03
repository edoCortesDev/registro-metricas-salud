// Minimal service worker — enables PWA installability
const CACHE_NAME = 'body-metrics-v1';

self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', e => e.waitUntil(self.clients.claim()));

// No caching strategy implemented in MVP — fetch from network only
self.addEventListener('fetch', e => {
  e.respondWith(fetch(e.request).catch(() => caches.match(e.request)));
});
