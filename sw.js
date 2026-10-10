const CACHE_NAME = 'deenislam-v8';
const CORE_ASSETS = [
  './',
  './index.html',
  './quran.html',
  './surah.html',
  './hadith.html',
  './hadith-view.html',
  './salat.html',
  './namaz.html',
  './tasbih.html',
  './qibla.html',
  './dua.html',
  './allah-names.html',
  './zakat.html',
  './bookmarks.html',
  './media.html',
  './about.html',
  './credits.html',
  './community.html',
  './donation.html',
  './kalima.html',
  './roja.html',
  './hajj.html',
  './js/theme.js',
  './js/components.js',
  './favicon/deenislam.ico',
  './manifest.json'
];

// Install Event - Pre-cache core shell
self.addEventListener('install', (event) => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then(async (cache) => {
      // Use allSettled so a single missing file or CDN error never aborts installation
      const promises = CORE_ASSETS.map(url => 
        cache.add(url).catch(err => console.warn('PWA Asset caching skipped:', url, err))
      );
      await Promise.allSettled(promises);
    })
  );
});

// Activate Event - Clean up older caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key))
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch Event - Stale-While-Revalidate with Network Fallback
self.addEventListener('fetch', (event) => {
  const request = event.request;
  if (request.method !== 'GET') return;

  // For HTML navigation requests: Network first with Cache fallback
  if (request.mode === 'navigate') {
    event.respondWith(
      fetch(request)
        .then((networkResponse) => {
          if (networkResponse && networkResponse.status === 200) {
            const responseClone = networkResponse.clone();
            caches.open(CACHE_NAME).then((cache) => cache.put(request, responseClone));
          }
          return networkResponse;
        })
        .catch(() => caches.match(request).then((cached) => cached || caches.match('./index.html')))
    );
    return;
  }

  // For static assets (CSS, JS, Fonts, Icons, Images): Cache First with Background Update
  event.respondWith(
    caches.match(request).then((cachedResponse) => {
      const fetchPromise = fetch(request)
        .then((networkResponse) => {
          if (networkResponse && networkResponse.status === 200 && networkResponse.type === 'basic') {
            const responseClone = networkResponse.clone();
            caches.open(CACHE_NAME).then((cache) => cache.put(request, responseClone));
          }
          return networkResponse;
        })
        .catch(() => cachedResponse);

      return cachedResponse || fetchPromise;
    })
  );
});
