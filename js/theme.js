/**
 * DeenIslam Theme Initialization
 * Executed in <head> to prevent theme flashing (FOUC).
 * Palette synced with DeenIslam Android AppColors (Brand Ivory & Midnight Emerald-Obsidian).
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
        .dark body { background-color: #06130e !important; color: #f4f7f5 !important; }
        .dark .bg-white { background-color: #0b2018 !important; border-color: #1a3b2e !important; }
        .dark .bg-slate-50, .dark .bg-stone-50 { background-color: #06130e !important; }
        .dark .text-slate-900, .dark .text-slate-800 { color: #f4f7f5 !important; }
        .dark .text-slate-700, .dark .text-slate-600, .dark .text-slate-500 { color: #9ab3a8 !important; }
        .dark .border-slate-100, .dark .border-emerald-50, .dark .border-emerald-100 { border-color: #1a3b2e !important; }
        .dark header { background-color: rgba(6, 19, 14, 0.94) !important; border-color: #1a3b2e !important; }
        .dark header > nav, .dark nav { background-color: transparent !important; border-color: transparent !important; }
        .dark #mobile-menu { background-color: #06130e !important; border-color: #1a3b2e !important; }
        .dark footer { background-color: #04100c !important; border-color: #1a3b2e !important; }
        .dark .bg-emerald-50 { background-color: rgba(16, 185, 129, 0.12) !important; color: #34d399 !important; }
        .dark .bg-amber-50 { background-color: rgba(229, 184, 75, 0.12) !important; color: #e5b84b !important; }
        .dark .prose { color: #d1dfd8 !important; }
        .dark input, .dark select, .dark textarea { background-color: #102b20 !important; border-color: #1a3b2e !important; color: #f4f7f5 !important; }
        .dark .bg-slate-900 { background-color: #0b2018 !important; }
        .dark .bg-slate-950 { background-color: #06130e !important; }
        .dark .bg-islamic-pattern { background-image: radial-gradient(rgba(16, 185, 129, 0.06) 1px, transparent 1px) !important; }
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
