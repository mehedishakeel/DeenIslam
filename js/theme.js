/**
 * DeenIslam Theme Initialization
 * Executed in <head> to prevent theme flashing (FOUC).
 */
(function() {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark' || (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        document.documentElement.classList.add('dark');
    }

    // Inject Global Theme Styles immediately
    const style = document.createElement('style');
    style.innerHTML = `
        body { background-color: #fbfaf8; color: #0f172a; font-family: 'Noto Sans Bengali', sans-serif; }
        .dark body { background-color: #020617 !important; color: #f1f5f9 !important; }
        .dark .bg-white { background-color: #0f172a !important; border-color: #1e293b !important; }
        .dark .bg-slate-50 { background-color: #020617 !important; }
        .dark .text-slate-900, .dark .text-slate-800 { color: #f8fafc !important; }
        .dark .text-slate-700, .dark .text-slate-600, .dark .text-slate-500 { color: #94a3b8 !important; }
        .dark .border-slate-100, .dark .border-emerald-50, .dark .border-emerald-100 { border-color: #1e293b !important; }
        .dark nav { background-color: rgba(15, 23, 42, 0.85) !important; border-color: #1e293b !important; }
        .dark #mobile-menu { background-color: #0f172a !important; }
        .dark .bg-emerald-50 { background-color: rgba(16, 185, 129, 0.1) !important; color: #34d399 !important; }
        .dark .bg-amber-50 { background-color: rgba(245, 158, 11, 0.1) !important; color: #fbbf24 !important; }
        .dark .prose { color: #cbd5e1 !important; }
        .dark input { background-color: #1e293b !important; border-color: #334155 !important; color: white !important; }
        .dark .bg-slate-900 { background-color: #0b1120 !important; }
    `;
    document.head.appendChild(style);

    // Register Service Worker with path resilient to sub-directories and GitHub Pages repository subpaths
    if ('serviceWorker' in navigator) {
        window.addEventListener('load', () => {
            const isSubDir = window.location.pathname.includes('/articles/');
            const swPath = isSubDir ? '../sw.js' : './sw.js';
            navigator.serviceWorker.register(swPath)
                .then(reg => console.log('DeenIslam Service Worker registered:', reg.scope))
                .catch(err => console.warn('Service Worker registration skipped/failed:', err));
        });
    }
})();
