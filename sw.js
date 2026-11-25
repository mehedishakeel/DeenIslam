const CACHE_NAME = 'deenislam-v17';
const CORE_ASSETS = [
  './',
  './index.html',
  './seerah.html',
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
  './muslim-names.html',
  './islamic-calendar.html',
  './quiz.html',
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
  './js/seerah-data.js',
  './js/muslim-names-data.js',
  './js/islamic-calendar-data.js',
  './js/quiz-data.js',
  './favicon/deenislam.ico',
  './manifest.json'
];

// Install Event - Pre-cache core shell
self.addEventListener('install', (event) => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then(async (cache) => {
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

// Fetch Event - Never intercept cross-origin or binary downloads (.apk/.zip/.mp3)
self.addEventListener('fetch', (event) => {
  const request = event.request;
  if (request.method !== 'GET') return;

  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return;
  if (/\.(apk|zip|pdf|mp3|ogg|wav)$/i.test(url.pathname)) return;

  const isCodeOrDoc =
    request.mode === 'navigate' ||
    url.pathname.endsWith('.html') ||
    url.pathname.endsWith('.js') ||
    url.pathname.endsWith('.css');

  if (isCodeOrDoc) {
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

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      for (const client of clientList) {
        if ('focus' in client) return client.focus();
      }
      if (clients.openWindow) return clients.openWindow('./salat.html');
    })
  );
});
