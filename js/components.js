window.toBengaliNumerals = (n) => {
    if (n === undefined || n === null) return "";
    return n.toString().replace(/\d/g, d => "০১২৩৪৫৬৭৮৯"[d]);
};

// Hijri Date Formatter (Bengali)
window.formatHijriDate = (hijriObj) => {
    if (!hijriObj) return "";
    const monthsBn = [
        "",
        "মুহাররম",
        "সফর",
        "রবিউল আউয়াল",
        "রবিউস সানি",
        "জমাদিউল আউয়াল",
        "জমাদিউস সানি",
        "রজব",
        "শাবান",
        "রমজান",
        "শাওয়াল",
        "জিলকদ",
        "জিলহজ"
    ];
    let monthNum = parseInt(hijriObj.month?.number || 0);
    if (!monthNum && hijriObj.month?.en) {
        const en = hijriObj.month.en.toLowerCase();
        if (en.includes('muharram')) monthNum = 1;
        else if (en.includes('safar')) monthNum = 2;
        else if (en.includes('awwal') && en.includes('rabi')) monthNum = 3;
        else if (en.includes('thani') && en.includes('rabi')) monthNum = 4;
        else if (en.includes('awwal') || en.includes('ula')) monthNum = 5;
        else if (en.includes('thani') || en.includes('akhira')) monthNum = 6;
        else if (en.includes('rajab')) monthNum = 7;
        else if (en.includes('sha') && en.includes('ban')) monthNum = 8;
        else if (en.includes('ramadan') || en.includes('ramadhan')) monthNum = 9;
        else if (en.includes('shawwal')) monthNum = 10;
        else if (en.includes('qi') || en.includes('qa')) monthNum = 11;
        else if (en.includes('hijjah')) monthNum = 12;
    }
    const monthName = (monthNum >= 1 && monthNum <= 12) ? monthsBn[monthNum] : (hijriObj.month?.en || "");
    const day = window.toBengaliNumerals(hijriObj.day || "");
    const year = window.toBengaliNumerals(hijriObj.year || "");
    return `${day} ${monthName}, ${year} হিজরি`;
};

// Instant Hijri Date (Offline / Synchronous)
window.getInstantHijriDate = () => {
    const cached = localStorage.getItem('deen_hijri_date');
    if (cached && !cached.includes('Rabī') && !cached.includes('undefined')) return cached;

    const monthsBn = [
        "",
        "মুহাররম",
        "সফর",
        "রবিউল আউয়াল",
        "রবিউস সানি",
        "জমাদিউল আউয়াল",
        "জমাদিউস সানি",
        "রজব",
        "শাবান",
        "রমজান",
        "শাওয়াল",
        "জিলকদ",
        "জিলহজ"
    ];

    try {
        const formatter = new Intl.DateTimeFormat('en-u-ca-islamic-umalqura-nu-latn', {
            day: 'numeric',
            month: 'numeric',
            year: 'numeric'
        });
        const parts = formatter.formatToParts(new Date());
        let d = '', m = '', y = '';
        for (const p of parts) {
            if (p.type === 'day') d = p.value;
            if (p.type === 'month') m = p.value;
            if (p.type === 'year') y = p.value;
        }
        const mNum = parseInt(m, 10);
        if (mNum >= 1 && mNum <= 12 && d && y) {
            const result = `${window.toBengaliNumerals(d)} ${monthsBn[mNum]}, ${window.toBengaliNumerals(y)} হিজরি`;
            localStorage.setItem('deen_hijri_date', result);
            return result;
        }
    } catch (e) {}

    // Kuwait algorithmic fallback
    try {
        const date = new Date();
        let day = date.getDate();
        let month = date.getMonth();
        let year = date.getFullYear();
        let m = month + 1;
        let y = year;
        if (m < 3) { y -= 1; m += 12; }
        const a = Math.floor(y / 100);
        const b = 2 - a + Math.floor(a / 4);
        const jd = Math.floor(365.25 * (y + 4716)) + Math.floor(30.6001 * (m + 1)) + day + b - 1524;
        const z = jd - 1948084;
        const hy = Math.floor((30 * z + 10646) / 10631);
        const hm = Math.min(12, Math.ceil((z - 29 - (hy - 1) * 354 - Math.floor((3 + 11 * hy) / 30)) / 29.5) + 1);
        const hd = Math.floor(z - Math.floor(29.5001 * (hm - 1)) - (hy - 1) * 354 - Math.floor((3 + 11 * hy) / 30) + 1);
        const result = `${window.toBengaliNumerals(hd)} ${monthsBn[hm] || ''}, ${window.toBengaliNumerals(hy)} হিজরি`;
        localStorage.setItem('deen_hijri_date', result);
        return result;
    } catch (err) {}

    return "২৪ রবিউস সানি, ১৪৪৮ হিজরি";
};

// Recent Search Helper
window.initRecentSearch = (inputId, storageKey) => {
    const input = document.getElementById(inputId);
    if (!input) return;

    const wrapper = input.parentElement;
    const recentContainer = document.createElement('div');
    recentContainer.id = `${inputId}-recent`;
    recentContainer.className = "hidden absolute top-full left-0 right-0 mt-2 bg-white dark:bg-slate-900 border border-emerald-50 dark:border-slate-800 rounded-2xl shadow-xl z-50 p-4";
    wrapper.appendChild(recentContainer);

    const updateRecentUI = () => {
        const searches = JSON.parse(localStorage.getItem(storageKey) || '[]');
        if (searches.length === 0) {
            recentContainer.innerHTML = '<p class="text-xs text-slate-400 text-center py-2">কোনো সাম্প্রতিক অনুসন্ধান নেই</p>';
            return;
        }

        recentContainer.innerHTML = `
            <div class="flex justify-between items-center mb-3">
                <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">সাম্প্রতিক অনুসন্ধান</span>
                <button id="${inputId}-clear-recent" class="text-[10px] font-bold text-red-400 hover:text-red-500 uppercase tracking-widest">মুছে ফেলুন</button>
            </div>
            <div class="flex flex-wrap gap-2">
                ${searches.map(s => `
                    <button class="recent-item px-3 py-1.5 bg-slate-50 dark:bg-slate-800 rounded-full text-xs font-medium text-slate-600 dark:text-slate-300 hover:bg-emerald-50 dark:hover:bg-emerald-900/30 hover:text-primary transition-all">
                        ${s}
                    </button>
                `).join('')}
            </div>
        `;

        const clearBtn = document.getElementById(`${inputId}-clear-recent`);
        if (clearBtn) {
            clearBtn.onclick = (e) => {
                e.stopPropagation();
                localStorage.setItem(storageKey, '[]');
                updateRecentUI();
            };
        }

        recentContainer.querySelectorAll('.recent-item').forEach(item => {
            item.onclick = () => {
                input.value = item.innerText.trim();
                input.dispatchEvent(new Event('input'));
                recentContainer.classList.add('hidden');
            };
        });
    };

    input.onfocus = () => {
        updateRecentUI();
        recentContainer.classList.remove('hidden');
    };

    // Close on click outside
    document.addEventListener('click', (e) => {
        if (!wrapper.contains(e.target)) recentContainer.classList.add('hidden');
    });

    input.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' && input.value.trim()) {
            let searches = JSON.parse(localStorage.getItem(storageKey) || '[]');
            const query = input.value.trim();
            searches = [query, ...searches.filter(s => s !== query)].slice(0, 5);
            localStorage.setItem(storageKey, JSON.stringify(searches));
            recentContainer.classList.add('hidden');
        }
    });
};

// Bookmark Helpers (Global)
window.toggleBookmark = (data) => {
    let bookmarks = JSON.parse(localStorage.getItem('deen_bookmarks') || '[]');
    const index = bookmarks.findIndex(b => b.key === data.key);
    let added = false;
    
    if (index === -1) {
        bookmarks.push(data);
        localStorage.setItem('deen_bookmarks', JSON.stringify(bookmarks));
        showToast('বুকমার্ক করা হয়েছে!');
        added = true;
    } else {
        bookmarks.splice(index, 1);
        localStorage.setItem('deen_bookmarks', JSON.stringify(bookmarks));
        showToast('বুকমার্ক সরানো হয়েছে');
        added = false;
    }
    window.updateBookmarkBadge();
    return added;
};

window.isBookmarked = (key) => {
    const bookmarks = JSON.parse(localStorage.getItem('deen_bookmarks') || '[]');
    return bookmarks.some(b => b.key === key);
};

window.updateBookmarkBadge = () => {
    const countBadge = document.getElementById('navbar-bookmark-count');
    if (!countBadge) return;
    const bookmarks = JSON.parse(localStorage.getItem('deen_bookmarks') || '[]');
    if (bookmarks.length > 0) {
        countBadge.innerText = window.toBengaliNumerals(bookmarks.length);
        countBadge.classList.remove('hidden');
    } else {
        countBadge.classList.add('hidden');
    }
};

window.copyToClipboard = (text) => {
    if (!text) return;
    navigator.clipboard.writeText(text).then(() => {
        showToast('কপি করা হয়েছে!');
    }).catch(err => {
        console.error('Copy failed:', err);
    });
};

// --- Font Size Manager ---
window.fontSizeManager = {
    arabic: parseInt(localStorage.getItem('fontSize_arabic')) || 32,
    bengali: parseInt(localStorage.getItem('fontSize_bengali')) || 18,

    init() {
        this.apply();
        this.injectSettings();
    },

    set(type, value) {
        this[type] = parseInt(value);
        localStorage.setItem(`fontSize_${type}`, this[type]);
        this.apply();
        this.updateLabels();
    },

    reset() {
        this.arabic = 32;
        this.bengali = 18;
        localStorage.setItem('fontSize_arabic', 32);
        localStorage.setItem('fontSize_bengali', 18);
        this.apply();
        this.updateLabels();
        
        const sA = document.getElementById('slider-arabic');
        const sB = document.getElementById('slider-bengali');
        if (sA) sA.value = 32;
        if (sB) sB.value = 18;
        showToast('ডিফল্ট সাইজ সেট করা হয়েছে');
    },

    apply() {
        const styleId = 'deen-font-sizes';
        let style = document.getElementById(styleId);
        if (!style) {
            style = document.createElement('style');
            style.id = styleId;
            document.head.appendChild(style);
        }
        style.innerHTML = `
            .font-arabic { font-size: ${this.arabic}px !important; line-height: 2.2 !important; }
            .font-bengali-content { font-size: ${this.bengali}px !important; line-height: 1.8 !important; }
            
            .deen-range {
                -webkit-appearance: none;
                width: 100%;
                height: 6px;
                background: #e2e8f0;
                border-radius: 5px;
                outline: none;
            }
            .dark .deen-range { background: #1e293b; }
            .deen-range::-webkit-slider-thumb {
                -webkit-appearance: none;
                appearance: none;
                width: 20px;
                height: 20px;
                background: #059669;
                cursor: pointer;
                border-radius: 50%;
                border: 2px solid white;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
        `;
    },

    updateLabels() {
        const aLabel = document.getElementById('label-arabic-size');
        const bLabel = document.getElementById('label-bengali-size');
        if (aLabel) aLabel.innerText = window.toBengaliNumerals(this.arabic);
        if (bLabel) bLabel.innerText = window.toBengaliNumerals(this.bengali);
    },

    injectSettings() {
        const allowedPages = ['surah.html', 'hadith-view.html'];
        const path = window.location.pathname;
        const page = path.split('/').pop() || 'index.html';
        if (!allowedPages.includes(page)) return;

        const settingsHTML = `
        <div id="settings-drawer" class="fixed top-0 right-0 h-full w-80 bg-white dark:bg-slate-900 z-[200] shadow-[-10px_0_30px_rgba(0,0,0,0.1)] transform translate-x-full transition-transform duration-500 ease-in-out border-l border-emerald-50 dark:border-slate-800">
            <div class="p-8">
                <div class="flex justify-between items-center mb-10">
                    <h3 class="text-xl font-bold text-slate-800 dark:text-white">পঠন সেটিংস</h3>
                    <button id="close-drawer" class="text-slate-400 hover:text-red-500 transition-colors">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
                    </button>
                </div>

                <div class="space-y-10">
                    <div>
                        <div class="flex justify-between items-center mb-4">
                            <span class="text-sm font-bold text-slate-500 uppercase tracking-widest">আরবি ফন্ট সাইজ</span>
                            <span id="label-arabic-size" class="text-sm font-bold text-primary bg-emerald-50 dark:bg-emerald-900/30 px-3 py-1 rounded-lg">${window.toBengaliNumerals(this.arabic)}</span>
                        </div>
                        <input type="range" min="20" max="64" value="${this.arabic}" class="deen-range" id="slider-arabic" oninput="window.fontSizeManager.set('arabic', this.value)">
                    </div>

                    <div>
                        <div class="flex justify-between items-center mb-4">
                            <span class="text-sm font-bold text-slate-500 uppercase tracking-widest">বাংলা ফন্ট সাইজ</span>
                            <span id="label-bengali-size" class="text-sm font-bold text-primary bg-emerald-50 dark:bg-emerald-900/30 px-3 py-1 rounded-lg">${window.toBengaliNumerals(this.bengali)}</span>
                        </div>
                        <input type="range" min="14" max="36" value="${this.bengali}" class="deen-range" id="slider-bengali" oninput="window.fontSizeManager.set('bengali', this.value)">
                    </div>

                    <button onclick="window.fontSizeManager.reset()" class="w-full py-4 bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 rounded-2xl font-bold hover:bg-red-50 dark:hover:bg-red-900/20 hover:text-red-500 transition-all flex items-center justify-center space-x-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" /></svg>
                        <span>রিসেট করুন</span>
                    </button>
                </div>
            </div>
        </div>

        <div id="drawer-backdrop" class="fixed inset-0 bg-transparent z-[190] hidden"></div>

        <button id="settings-toggle" class="fixed bottom-24 right-8 w-14 h-14 bg-white dark:bg-slate-900 text-primary rounded-2xl shadow-xl flex items-center justify-center border border-emerald-50 dark:border-slate-800 hover:scale-110 active:scale-95 transition-all z-[150]">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /></svg>
        </button>
        `;

        const div = document.createElement('div');
        div.innerHTML = settingsHTML;
        document.body.appendChild(div);

        const toggle = document.getElementById('settings-toggle');
        const drawer = document.getElementById('settings-drawer');
        const backdrop = document.getElementById('drawer-backdrop');
        const closeBtn = document.getElementById('close-drawer');

        const openDrawer = () => {
            drawer.classList.remove('translate-x-full');
            backdrop.classList.remove('hidden');
        };

        const closeDrawer = () => {
            drawer.classList.add('translate-x-full');
            backdrop.classList.add('hidden');
        };

        if (toggle) toggle.onclick = openDrawer;
        if (closeBtn) closeBtn.onclick = closeDrawer;
        if (backdrop) backdrop.onclick = closeDrawer;
    }
};

function showToast(message) {
    let toast = document.getElementById('deen-toast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'deen-toast';
        document.body.appendChild(toast);
    }
    toast.className = "fixed bottom-24 left-1/2 transform -translate-x-1/2 bg-slate-900 dark:bg-slate-100 text-white dark:text-slate-900 px-6 py-3 rounded-full shadow-2xl z-[300] font-bold text-sm animate-bounce-in opacity-100 transition-opacity duration-500";
    toast.innerText = message;
    
    clearTimeout(window.toastTimeout);
    window.toastTimeout = setTimeout(() => {
        toast.classList.add('opacity-0');
    }, 2000);
}

// Add toast animation style
const toastStyle = document.createElement('style');
toastStyle.innerHTML = `
    @keyframes bounce-in {
        0% { transform: translate(-50%, 20px); opacity: 0; }
        60% { transform: translate(-50%, -5px); opacity: 1; }
        100% { transform: translate(-50%, 0); opacity: 1; }
    }
    .animate-bounce-in { animation: bounce-in 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
`;
document.head.appendChild(toastStyle);

// --- Universal Command Palette (Ctrl + K) ---
const commandPaletteIndex = [
    // Tools & Main Sections
    { title: "সীরাতুন্নবী (ﷺ) বিশ্বকোষ (মানচিত্র, বংশলতিকা, পরিবার, সাহাবী ও গাযওয়া)", category: "প্রধান পাতা", url: "seerah.html", keywords: "seerah sirat prophet muhammad map genealogy family companions sahaba battles ghazwa badr uhud" },
    { title: "আল-কুরআন (১১৪টি সূরা ও ৩০ পারা)", category: "প্রধান পাতা", url: "quran.html", keywords: "quran quranul karim koran surah juz para" },
    { title: "হাদিস গ্রন্থসমূহ (বুখারী, মুসলিম, তিরমিযী...)", category: "প্রধান পাতা", url: "hadith.html", keywords: "hadith bukhari muslim tirmizi nasai abu dawood ibn majah" },
    { title: "কিবলা কম্পাস (ডিজিটাল দিক নির্ণয়)", category: "টুলস ও ইবাদত", url: "qibla.html", keywords: "qibla compass kaaba mecca direction kaba kibla" },
    { title: "দৈনন্দিন দো'আ ও জিকির (হিসনুল মুসলিম)", category: "টুলস ও ইবাদত", url: "dua.html", keywords: "dua hisnul muslim zikr azkar rabbana shokal shondha" },
    { title: "আল্লাহর ৯৯টি গুণবাচক নাম (আসমাউল হুসনা)", category: "টুলস ও ইবাদত", url: "allah-names.html", keywords: "allah 99 names asmaul husna sifat ar-rahman ar-rahim" },
    { title: "নামাজ শিক্ষা ও সহীহ পদ্ধতি", category: "টুলস ও ইবাদত", url: "namaz.html", keywords: "namaz salah prayer shikkha wudu tayammum rakat ruku sajdah" },
    { title: "সালাতের সময়সূচি ও সেহরি-ইফতার", category: "টুলস ও ইবাদত", url: "salat.html", keywords: "salat prayer times fajr dhuhr asr maghrib isha sehri iftar" },
    { title: "যাকাত ক্যালকুলেটর (সহজ হিসাব)", category: "টুলস ও ইবাদত", url: "zakat.html", keywords: "zakat calculator nisab gold silver cash calculation" },
    { title: "ডিজিটাল তাসবীহ ও জিকির কাউন্টার", category: "টুলস ও ইবাদত", url: "tasbih.html", keywords: "tasbih zikr counter subhanallah alhamdulillah allahuakbar" },
    { title: "রোজা (সাওম) - নিয়ম, দোয়া ও মাসআলা", category: "ইসলামের স্তম্ভ", url: "roja.html", keywords: "roja fast fasting ramadan sehri iftar kaza kaffara" },
    { title: "হজ ও উমরাহ পূর্ণাঙ্গ গাইড", category: "ইসলামের স্তম্ভ", url: "hajj.html", keywords: "hajj umrah makkah talbiyah tawaf saee arafat mina" },
    { title: "ইসলামের ৫টি কালিমা", category: "ইসলামের স্তম্ভ", url: "kalima.html", keywords: "kalima tayyiba shahadat tamjid tawheed radde kufr" },
    { title: "মিডিয়া ও ইসলামিক ভিডিও লেকচার", category: "মিডিয়া", url: "media.html", keywords: "media video lecture nobi jiboni quran recitation" },
    { title: "ইসলামিক প্রবন্ধ ও আর্টিকেল", category: "প্রবন্ধ", url: "articles/index.html", keywords: "articles probondho ramadan manners purity salah" },
    { title: "মুসলিম কমিউনিটি ও প্রশ্নোত্তর (মাসআলা)", category: "কমিউনিটি", url: "community.html", keywords: "community forum masala faq ask question" },
    { title: "আপনার বুকমার্কসমূহ", category: "টুলস", url: "bookmarks.html", keywords: "bookmarks saved favorites verses hadith" },

    // Important Surahs
    { title: "সূরা ১: আল-ফাতিহা (Al-Fatihah)", category: "কুরআন সূরা", url: "surah.html?id=1", keywords: "fatihah 1 quran fatiha" },
    { title: "সূরা ২: আল-বাকারা (Al-Baqarah)", category: "কুরআন সূরা", url: "surah.html?id=2", keywords: "baqarah 2 bakara ayatul kursi" },
    { title: "সূরা ৩: আল-ইমরান (Ali 'Imran)", category: "কুরআন সূরা", url: "surah.html?id=3", keywords: "imran ali imran 3" },
    { title: "সূরা ১৮: আল-কাহফ (Al-Kahf)", category: "কুরআন সূরা", url: "surah.html?id=18", keywords: "kahf kahaf 18 jummah" },
    { title: "সূরা ৩৬: ইয়াসীন (Ya-Sin)", category: "কুরআন সূরা", url: "surah.html?id=36", keywords: "yasin yaseen 36 quran heart" },
    { title: "সূরা ৫৫: আর-রাহমান (Ar-Rahman)", category: "কুরআন সূরা", url: "surah.html?id=55", keywords: "rahman rahman 55" },
    { title: "সূরা ৫৬: আল-ওয়াকিয়াহ (Al-Waqi'ah)", category: "কুরআন সূরা", url: "surah.html?id=56", keywords: "waqiah waqia 56" },
    { title: "সূরা ৬৭: আল-মুলক (Al-Mulk)", category: "কুরআন সূরা", url: "surah.html?id=67", keywords: "mulk tabarakal lazi 67" },
    { title: "সূরা ১১২: আল-ইখলাস (Al-Ikhlas)", category: "কুরআন সূরা", url: "surah.html?id=112", keywords: "ikhlas qul huwallah 112" },
    { title: "সূরা ১১৩: আল-ফালাক্ব (Al-Falaq)", category: "কুরআন সূরা", url: "surah.html?id=113", keywords: "falaq falaq 113" },
    { title: "সূরা ১১৪: আন-নাস (An-Nas)", category: "কুরআন সূরা", url: "surah.html?id=114", keywords: "nas naas 114" }
];

window.initCommandPalette = (basePath) => {
    let modal = document.getElementById('deen-command-palette');
    if (modal) return;

    modal = document.createElement('div');
    modal.id = 'deen-command-palette';
    modal.className = "fixed inset-0 z-[500] hidden bg-slate-900/60 dark:bg-black/80 backdrop-blur-sm flex items-start justify-center pt-20 px-4 transition-all duration-200";
    modal.innerHTML = `
        <div class="bg-white dark:bg-slate-900 w-full max-w-2xl rounded-2xl shadow-2xl border border-stone-200/90 dark:border-slate-800/80 overflow-hidden transform transition-all flex flex-col max-h-[80vh]">
            <!-- Search Input Header -->
            <div class="p-4 border-b border-slate-100 dark:border-slate-800 flex items-center space-x-3">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-primary shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
                <input type="text" id="palette-search-input" placeholder="সূরা, দো'আ, কিবলা, নামাজ, হাদিস বা বিষয় খুঁজুন..." class="w-full bg-transparent text-slate-800 dark:text-white placeholder-slate-400 focus:outline-none text-base font-medium">
                <kbd class="hidden sm:inline-block px-2 py-1 text-[11px] bg-slate-100 dark:bg-slate-800 text-slate-400 rounded-lg font-mono">ESC</kbd>
            </div>

            <!-- Results List -->
            <div id="palette-results" class="overflow-y-auto p-3 space-y-1.5 flex-grow">
                <!-- Dynamically populated -->
            </div>

            <!-- Footer Shortcuts -->
            <div class="p-3 bg-slate-50 dark:bg-slate-800/50 border-t border-slate-100 dark:border-slate-800 flex justify-between items-center text-[11px] text-slate-400">
                <div class="flex items-center space-x-3">
                    <span><kbd class="font-mono bg-white dark:bg-slate-800 px-1.5 py-0.5 rounded shadow-sm">↑</kbd> <kbd class="font-mono bg-white dark:bg-slate-800 px-1.5 py-0.5 rounded shadow-sm">↓</kbd> নেভিগেশন</span>
                    <span><kbd class="font-mono bg-white dark:bg-slate-800 px-1.5 py-0.5 rounded shadow-sm">↵</kbd> খুলুন</span>
                </div>
                <span>DeenIslam কুইক সার্চ</span>
            </div>
        </div>
    `;
    document.body.appendChild(modal);

    const input = document.getElementById('palette-search-input');
    const resultsContainer = document.getElementById('palette-results');
    let selectedIndex = 0;
    let currentResults = [];

    const renderPaletteResults = (query = '') => {
        const q = query.trim().toLowerCase();
        currentResults = commandPaletteIndex.filter(item => {
            if (!q) return true;
            return item.title.toLowerCase().includes(q) ||
                   item.category.toLowerCase().includes(q) ||
                   item.keywords.toLowerCase().includes(q);
        });

        if (currentResults.length === 0) {
            resultsContainer.innerHTML = `
                <div class="py-12 text-center text-slate-400 text-sm">
                    <p>কোনো ফলাফল পাওয়া যায়নি</p>
                    <p class="text-xs mt-1 text-slate-500">অন্য কোনো শব্দ লিখে চেষ্টা করুন</p>
                </div>
            `;
            return;
        }

        selectedIndex = 0;
        resultsContainer.innerHTML = currentResults.map((item, idx) => `
            <a href="${basePath}${item.url}" class="palette-item block p-3 rounded-2xl transition-all flex items-center justify-between group ${idx === 0 ? 'bg-emerald-50 dark:bg-emerald-950/40 text-primary' : 'hover:bg-slate-50 dark:hover:bg-slate-800/60'}" data-index="${idx}">
                <div class="flex items-center space-x-3">
                    <div class="w-8 h-8 rounded-xl bg-slate-100 dark:bg-slate-800 group-hover:bg-emerald-100 dark:group-hover:bg-emerald-900/50 flex items-center justify-center text-primary text-xs font-bold shrink-0">
                        ${idx === 0 ? '→' : '•'}
                    </div>
                    <div>
                        <h4 class="font-bold text-sm text-slate-800 dark:text-white group-hover:text-primary transition-colors">${item.title}</h4>
                        <span class="text-[10px] text-slate-400">${item.category}</span>
                    </div>
                </div>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-slate-300 group-hover:text-primary transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" /></svg>
            </a>
        `).join('');
    };

    window.openCommandPalette = () => {
        modal.classList.remove('hidden');
        renderPaletteResults();
        input.value = '';
        setTimeout(() => input.focus(), 50);
    };

    window.closeCommandPalette = () => {
        modal.classList.add('hidden');
    };

    modal.addEventListener('click', (e) => {
        if (e.target === modal) closeCommandPalette();
    });

    input.addEventListener('input', (e) => {
        renderPaletteResults(e.target.value);
    });

    document.addEventListener('keydown', (e) => {
        // Toggle palette on Ctrl+K or Cmd+K
        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
            e.preventDefault();
            if (modal.classList.contains('hidden')) {
                openCommandPalette();
            } else {
                closeCommandPalette();
            }
        }

        // Open on "/" when not inside an input/textarea
        if (e.key === '/' && !['INPUT', 'TEXTAREA', 'SELECT'].includes(document.activeElement.tagName)) {
            e.preventDefault();
            openCommandPalette();
        }

        // Handle Escape
        if (e.key === 'Escape' && !modal.classList.contains('hidden')) {
            closeCommandPalette();
        }

        // Arrow navigation
        if (!modal.classList.contains('hidden') && currentResults.length > 0) {
            const items = resultsContainer.querySelectorAll('.palette-item');
            if (e.key === 'ArrowDown') {
                e.preventDefault();
                selectedIndex = (selectedIndex + 1) % currentResults.length;
                updateSelection(items);
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                selectedIndex = (selectedIndex - 1 + currentResults.length) % currentResults.length;
                updateSelection(items);
            } else if (e.key === 'Enter') {
                e.preventDefault();
                if (currentResults[selectedIndex]) {
                    window.location.href = basePath + currentResults[selectedIndex].url;
                }
            }
        }
    });

    function updateSelection(items) {
        items.forEach((el, i) => {
            if (i === selectedIndex) {
                el.classList.add('bg-emerald-50', 'dark:bg-emerald-950/40', 'text-primary');
                el.scrollIntoView({ block: 'nearest' });
            } else {
                el.classList.remove('bg-emerald-50', 'dark:bg-emerald-950/40', 'text-primary');
            }
        });
    }
};

document.addEventListener('DOMContentLoaded', () => {
    console.log('DeenIslam Components Loaded - v2.0.0');

    // Global UI Styles & Waveform Animations
    if (!document.getElementById('deen-global-ui-style')) {
        const globalUiStyle = document.createElement('style');
        globalUiStyle.id = 'deen-global-ui-style';
        globalUiStyle.innerHTML = `
            @keyframes wave-bounce {
                0%, 100% { height: 6px; }
                50% { height: 28px; }
            }
            .wave-bar-active {
                animation: wave-bounce 1s ease-in-out infinite;
            }
            .wave-bar-active:nth-child(2n) { animation-delay: 0.15s; }
            .wave-bar-active:nth-child(3n) { animation-delay: 0.35s; }
            .wave-bar-active:nth-child(4n) { animation-delay: 0.2s; }
            .wave-bar-active:nth-child(5n) { animation-delay: 0.45s; }

            html { scroll-behavior: smooth; }
            ::-webkit-scrollbar { width: 8px; height: 8px; }
            ::-webkit-scrollbar-track { background: transparent; }
            ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 9999px; }
            .dark ::-webkit-scrollbar-thumb { background: #334155; }
            ::-webkit-scrollbar-thumb:hover { background: #94a3b8; }
        `;
        document.head.appendChild(globalUiStyle);
    }

    if (window.fontSizeManager) window.fontSizeManager.init();

    const path = window.location.pathname;
    const isSubDir = path.includes('/articles/');
    const basePath = isSubDir ? '../' : '';
    const currentPage = path.split('/').pop() || 'index.html';

    // Initialize command palette
    window.initCommandPalette(basePath);

    // 1. Inject Navbar
    const navbarPlaceholder = document.getElementById('navbar-placeholder');
    if (navbarPlaceholder) {
        const isIbadahActive = ['salat.html', 'qibla.html', 'dua.html', 'allah-names.html', 'namaz.html', 'zakat.html', 'tasbih.html', 'roja.html', 'hajj.html', 'kalima.html', 'media.html', 'community.html'].includes(currentPage) || isSubDir;
        const isOthersActive = ['community.html', 'about.html', 'credits.html'].includes(currentPage);

        navbarPlaceholder.innerHTML = `
        <header class="sticky top-0 z-50 w-full bg-white/95 dark:bg-[#0b1120]/95 backdrop-blur-md border-b border-stone-200/80 dark:border-slate-800 transition-colors duration-200">
            <nav class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex justify-between items-center gap-4 bg-transparent">
                <!-- Brand Logo -->
                <a href="${basePath}index.html" class="flex items-center space-x-2.5 shrink-0 group">
                    <div class="w-9 h-9 bg-emerald-600 group-hover:bg-emerald-700 rounded-xl flex items-center justify-center text-white shadow-sm transition-all group-hover:scale-105">
                        <span class="text-base select-none">🌙</span>
                    </div>
                    <div class="flex flex-col">
                        <span class="text-xl font-black text-slate-800 dark:text-white tracking-tight group-hover:text-primary transition-colors leading-tight">DeenIslam</span>
                        <span class="text-[10px] text-emerald-700 dark:text-emerald-400 font-semibold tracking-wider leading-none hidden sm:block">দ্বীন ইসলাম</span>
                    </div>
                </a>
                
                <!-- Desktop Nav Menu (5 Clean Top-Level Items) -->
                <div class="hidden lg:flex items-center justify-center">
                    <ul class="flex items-center gap-1 xl:gap-2 text-sm font-semibold whitespace-nowrap">
                        <li>
                            <a href="${basePath}index.html" class="px-3.5 py-2 rounded-xl transition-colors ${(currentPage === 'index.html' || currentPage === '') && !isSubDir ? 'text-primary font-bold bg-emerald-50/80 dark:bg-emerald-950/40' : 'text-slate-600 hover:text-primary hover:bg-stone-100/70 dark:text-slate-300 dark:hover:text-primary dark:hover:bg-slate-800/60'}">
                                হোম
                            </a>
                        </li>
                        <li>
                            <a href="${basePath}quran.html" class="px-3.5 py-2 rounded-xl transition-colors ${currentPage === 'quran.html' ? 'text-primary font-bold bg-emerald-50/80 dark:bg-emerald-950/40' : 'text-slate-600 hover:text-primary hover:bg-stone-100/70 dark:text-slate-300 dark:hover:text-primary dark:hover:bg-slate-800/60'}">
                                আল-কুরআন
                            </a>
                        </li>
                        <li>
                            <a href="${basePath}hadith.html" class="px-3.5 py-2 rounded-xl transition-colors ${currentPage === 'hadith.html' ? 'text-primary font-bold bg-emerald-50/80 dark:bg-emerald-950/40' : 'text-slate-600 hover:text-primary hover:bg-stone-100/70 dark:text-slate-300 dark:hover:text-primary dark:hover:bg-slate-800/60'}">
                                হাদিস
                            </a>
                        </li>
                        <li>
                            <a href="${basePath}seerah.html" class="px-3.5 py-2 rounded-xl transition-colors ${currentPage === 'seerah.html' ? 'text-primary font-bold bg-emerald-50/80 dark:bg-emerald-950/40' : 'text-slate-600 hover:text-primary hover:bg-stone-100/70 dark:text-slate-300 dark:hover:text-primary dark:hover:bg-slate-800/60'}">
                                সীরাত (ﷺ)
                            </a>
                        </li>

                        <!-- All Ibadah, Tools & Portal Resources Dropdown -->
                        <li class="relative group">
                            <button class="flex items-center space-x-1.5 px-3.5 py-2 rounded-xl transition-colors ${isIbadahActive ? 'text-primary font-bold bg-emerald-50/80 dark:bg-emerald-950/40' : 'text-slate-600 hover:text-primary hover:bg-stone-100/70 dark:text-slate-300 dark:hover:text-primary dark:hover:bg-slate-800/60'}">
                                <span>ইবাদত ও সেবাসমূহ</span>
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 transform group-hover:rotate-180 transition-transform duration-200 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" /></svg>
                            </button>
                            <div class="absolute left-1/2 -translate-x-1/2 mt-2 w-[30rem] bg-white dark:bg-[#0f172a] border border-stone-200/90 dark:border-slate-800 rounded-2xl shadow-xl p-3 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-150 z-50">
                                <div class="grid grid-cols-2 gap-1">
                                    <a href="${basePath}salat.html" class="flex items-center space-x-2.5 px-3 py-2 text-xs font-semibold ${currentPage === 'salat.html' ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40' : 'text-slate-700 dark:text-slate-300 hover:bg-emerald-50/70 dark:hover:bg-emerald-950/30 hover:text-primary'} rounded-xl transition-colors">
                                        <span class="text-base">🕰️</span>
                                        <span>সালাতের সময়সূচি</span>
                                    </a>
                                    <a href="${basePath}qibla.html" class="flex items-center space-x-2.5 px-3 py-2 text-xs font-semibold ${currentPage === 'qibla.html' ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40' : 'text-slate-700 dark:text-slate-300 hover:bg-emerald-50/70 dark:hover:bg-emerald-950/30 hover:text-primary'} rounded-xl transition-colors">
                                        <span class="text-base">🧭</span>
                                        <span>কিবলা কম্পাস</span>
                                    </a>
                                    <a href="${basePath}dua.html" class="flex items-center space-x-2.5 px-3 py-2 text-xs font-semibold ${currentPage === 'dua.html' ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40' : 'text-slate-700 dark:text-slate-300 hover:bg-emerald-50/70 dark:hover:bg-emerald-950/30 hover:text-primary'} rounded-xl transition-colors">
                                        <span class="text-base">🤲</span>
                                        <span>দৈনন্দিন দো'আ</span>
                                    </a>
                                    <a href="${basePath}allah-names.html" class="flex items-center space-x-2.5 px-3 py-2 text-xs font-semibold ${currentPage === 'allah-names.html' ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40' : 'text-slate-700 dark:text-slate-300 hover:bg-emerald-50/70 dark:hover:bg-emerald-950/30 hover:text-primary'} rounded-xl transition-colors">
                                        <span class="text-base">🌟</span>
                                        <span>আল্লাহর ৯৯ নাম</span>
                                    </a>
                                    <a href="${basePath}namaz.html" class="flex items-center space-x-2.5 px-3 py-2 text-xs font-semibold ${currentPage === 'namaz.html' ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40' : 'text-slate-700 dark:text-slate-300 hover:bg-emerald-50/70 dark:hover:bg-emerald-950/30 hover:text-primary'} rounded-xl transition-colors">
                                        <span class="text-base">🕌</span>
                                        <span>নামাজ শিক্ষা গাইড</span>
                                    </a>
                                    <a href="${basePath}zakat.html" class="flex items-center space-x-2.5 px-3 py-2 text-xs font-semibold ${currentPage === 'zakat.html' ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40' : 'text-slate-700 dark:text-slate-300 hover:bg-emerald-50/70 dark:hover:bg-emerald-950/30 hover:text-primary'} rounded-xl transition-colors">
                                        <span class="text-base">💎</span>
                                        <span>যাকাত ক্যালকুলেটর</span>
                                    </a>
                                    <a href="${basePath}tasbih.html" class="flex items-center space-x-2.5 px-3 py-2 text-xs font-semibold ${currentPage === 'tasbih.html' ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40' : 'text-slate-700 dark:text-slate-300 hover:bg-emerald-50/70 dark:hover:bg-emerald-950/30 hover:text-primary'} rounded-xl transition-colors">
                                        <span class="text-base">📿</span>
                                        <span>ডিজিটাল তাসবীহ</span>
                                    </a>
                                    <a href="${basePath}roja.html" class="flex items-center space-x-2.5 px-3 py-2 text-xs font-semibold ${currentPage === 'roja.html' ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40' : 'text-slate-700 dark:text-slate-300 hover:bg-emerald-50/70 dark:hover:bg-emerald-950/30 hover:text-primary'} rounded-xl transition-colors">
                                        <span class="text-base">🌙</span>
                                        <span>রোজা ও সেহরি-ইফতার</span>
                                    </a>
                                    <a href="${basePath}hajj.html" class="flex items-center space-x-2.5 px-3 py-2 text-xs font-semibold ${currentPage === 'hajj.html' ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40' : 'text-slate-700 dark:text-slate-300 hover:bg-emerald-50/70 dark:hover:bg-emerald-950/30 hover:text-primary'} rounded-xl transition-colors">
                                        <span class="text-base">🕋</span>
                                        <span>হজ ও উমরাহ গাইড</span>
                                    </a>
                                    <a href="${basePath}kalima.html" class="flex items-center space-x-2.5 px-3 py-2 text-xs font-semibold ${currentPage === 'kalima.html' ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40' : 'text-slate-700 dark:text-slate-300 hover:bg-emerald-50/70 dark:hover:bg-emerald-950/30 hover:text-primary'} rounded-xl transition-colors">
                                        <span class="text-base">☝️</span>
                                        <span>ইসলামের ৫ কালিমা</span>
                                    </a>
                                </div>
                                <div class="mt-2 pt-2 border-t border-stone-100 dark:border-slate-800 grid grid-cols-3 gap-1">
                                    <a href="${basePath}media.html" class="flex items-center justify-center space-x-1.5 px-2.5 py-1.5 text-xs font-semibold ${currentPage === 'media.html' ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40' : 'text-slate-600 dark:text-slate-300 hover:bg-stone-100 dark:hover:bg-slate-800'} rounded-lg transition-colors">
                                        <span>🎬</span>
                                        <span>মিডিয়া</span>
                                    </a>
                                    <a href="${basePath}articles/index.html" class="flex items-center justify-center space-x-1.5 px-2.5 py-1.5 text-xs font-semibold ${isSubDir ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40' : 'text-slate-600 dark:text-slate-300 hover:bg-stone-100 dark:hover:bg-slate-800'} rounded-lg transition-colors">
                                        <span>📝</span>
                                        <span>প্রবন্ধ</span>
                                    </a>
                                    <a href="${basePath}community.html" class="flex items-center justify-center space-x-1.5 px-2.5 py-1.5 text-xs font-semibold ${currentPage === 'community.html' ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40' : 'text-slate-600 dark:text-slate-300 hover:bg-stone-100 dark:hover:bg-slate-800'} rounded-lg transition-colors">
                                        <span>💬</span>
                                        <span>কমিউনিটি</span>
                                    </a>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>

                <!-- Right Side Actions (Compact & Uncluttered) -->
                <div class="flex items-center space-x-2 shrink-0">
                    <!-- Quick Search Button -->
                    <button onclick="window.openCommandPalette()" class="flex items-center space-x-2 px-3 py-1.5 rounded-xl bg-stone-100/90 dark:bg-slate-800/80 hover:bg-emerald-50 dark:hover:bg-emerald-950/40 border border-stone-200/80 dark:border-slate-700 text-slate-500 dark:text-slate-300 hover:text-primary transition-all text-xs font-medium" title="অনুসন্ধান (Ctrl+K)">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
                        <span class="hidden sm:inline text-xs text-slate-500 dark:text-slate-400">অনুসন্ধান</span>
                        <kbd class="hidden md:inline-block px-1.5 py-0.5 text-[10px] bg-white dark:bg-slate-700 text-slate-400 rounded font-mono border border-stone-200 dark:border-slate-600">⌘K</kbd>
                    </button>

                    <!-- Bookmarks -->
                    <a href="${basePath}bookmarks.html" class="p-2 rounded-xl text-slate-600 dark:text-slate-300 hover:text-primary hover:bg-emerald-50 dark:hover:bg-emerald-950/30 transition-all relative border border-transparent hover:border-emerald-200/60 ${currentPage === 'bookmarks.html' ? 'text-primary bg-emerald-50 dark:bg-emerald-950/40 border-emerald-200' : ''}" title="বুকমার্ক">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="${currentPage === 'bookmarks.html' ? 'currentColor' : 'none'}" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z" /></svg>
                        <span id="navbar-bookmark-count" class="hidden absolute -top-1 -right-1 bg-primary text-white text-[9px] font-extrabold w-4 h-4 rounded-full flex items-center justify-center shadow-xs"></span>
                    </a>

                    <!-- Theme Toggle -->
                    <button class="theme-toggle p-2 rounded-xl bg-stone-100/90 dark:bg-slate-800/80 border border-stone-200/80 dark:border-slate-700 text-slate-600 dark:text-slate-300 hover:text-primary hover:bg-emerald-50 dark:hover:bg-emerald-950/30 transition-all" title="থিম পরিবর্তন">
                        <svg class="theme-toggle-dark-icon hidden w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z"></path></svg>
                        <svg class="theme-toggle-light-icon hidden w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z" fill-rule="evenodd" clip-rule="evenodd"></path></svg>
                    </button>

                    <!-- Mobile Menu Button -->
                    <button id="mobile-menu-btn" class="lg:hidden text-slate-600 dark:text-slate-300 p-2 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-800 border border-stone-200 dark:border-slate-700" aria-label="Menu">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16m-7 6h7" /></svg>
                    </button>
                </div>
            </nav>

            <!-- Mobile Drawer Menu -->
            <div id="mobile-menu" class="hidden lg:hidden border-t border-stone-200/80 dark:border-slate-800 bg-white dark:bg-[#0b1120] px-4 sm:px-6 py-4 space-y-2 shadow-lg overflow-y-auto max-h-[80vh]">
                <a href="${basePath}index.html" class="block p-2.5 rounded-xl ${(currentPage === 'index.html' || currentPage === '') && !isSubDir ? 'text-primary font-bold bg-emerald-50 dark:bg-emerald-900/20' : 'font-medium dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800'}">হোম</a>
                <a href="${basePath}salat.html" class="block p-2.5 rounded-xl ${currentPage === 'salat.html' ? 'text-primary font-bold bg-emerald-50 dark:bg-emerald-900/20' : 'font-medium dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800'}">সালাতের সময়সূচি</a>
                <a href="${basePath}quran.html" class="block p-2.5 rounded-xl ${currentPage === 'quran.html' ? 'text-primary font-bold bg-emerald-50 dark:bg-emerald-900/20' : 'font-medium dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800'}">পবিত্র কুরআন</a>
                <a href="${basePath}hadith.html" class="block p-2.5 rounded-xl ${currentPage === 'hadith.html' ? 'text-primary font-bold bg-emerald-50 dark:bg-emerald-900/20' : 'font-medium dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800'}">সহীহ হাদিস</a>
                <a href="${basePath}seerah.html" class="block p-2.5 rounded-xl ${currentPage === 'seerah.html' ? 'text-primary font-bold bg-emerald-50 dark:bg-emerald-900/20' : 'font-medium dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800'}">সীরাতুন্নবী (ﷺ) বিশ্বকোষ</a>
                
                <!-- Mobile Ibadah & Tools -->
                <div>
                    <button id="mobile-ibadah-btn" class="w-full flex justify-between items-center p-3 rounded-2xl font-medium dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 transition-all">
                        <span class="flex items-center space-x-2">
                            <span>ইবাদত ও টুলস</span>
                            <span class="px-2 py-0.5 text-[10px] bg-primary/10 text-primary rounded-full font-bold">নতুন</span>
                        </span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 transform transition-transform" id="mobile-ibadah-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" /></svg>
                    </button>
                    <div id="mobile-ibadah-menu" class="hidden pl-4 space-y-1 mt-1 border-l-2 border-emerald-100 dark:border-slate-800 ml-2">
                        <a href="${basePath}qibla.html" class="block p-2.5 rounded-xl text-xs font-semibold ${currentPage === 'qibla.html' ? 'text-primary font-bold' : 'dark:text-slate-300'}">🧭 কিবলা কম্পাস</a>
                        <a href="${basePath}dua.html" class="block p-2.5 rounded-xl text-xs font-semibold ${currentPage === 'dua.html' ? 'text-primary font-bold' : 'dark:text-slate-300'}">🤲 দো'আ ও জিকির</a>
                        <a href="${basePath}allah-names.html" class="block p-2.5 rounded-xl text-xs font-semibold ${currentPage === 'allah-names.html' ? 'text-primary font-bold' : 'dark:text-slate-300'}">🌟 আল্লাহর ৯৯ নাম</a>
                        <a href="${basePath}namaz.html" class="block p-2.5 rounded-xl text-xs font-semibold ${currentPage === 'namaz.html' ? 'text-primary font-bold' : 'dark:text-slate-300'}">🕌 নামাজ শিক্ষা</a>
                        <a href="${basePath}zakat.html" class="block p-2.5 rounded-xl text-xs font-semibold ${currentPage === 'zakat.html' ? 'text-primary font-bold' : 'dark:text-slate-300'}">💎 যাকাত ক্যালকুলেটর</a>
                        <a href="${basePath}tasbih.html" class="block p-2.5 rounded-xl text-xs font-semibold ${currentPage === 'tasbih.html' ? 'text-primary font-bold' : 'dark:text-slate-300'}">📿 ডিজিটাল তাসবীহ</a>
                        <a href="${basePath}roja.html" class="block p-2.5 rounded-xl text-xs font-semibold ${currentPage === 'roja.html' ? 'text-primary font-bold' : 'dark:text-slate-300'}">🌙 রোজা ও সেহরি-ইফতার</a>
                        <a href="${basePath}hajj.html" class="block p-2.5 rounded-xl text-xs font-semibold ${currentPage === 'hajj.html' ? 'text-primary font-bold' : 'dark:text-slate-300'}">🕋 হজ ও উমরাহ</a>
                        <a href="${basePath}kalima.html" class="block p-2.5 rounded-xl text-xs font-semibold ${currentPage === 'kalima.html' ? 'text-primary font-bold' : 'dark:text-slate-300'}">☝️ ইসলামের ৫ কালিমা</a>
                    </div>
                </div>

                <a href="${basePath}media.html" class="block p-3 rounded-2xl ${currentPage === 'media.html' ? 'text-primary font-bold bg-emerald-50 dark:bg-emerald-900/20' : 'font-medium dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800'}">মিডিয়া</a>
                <a href="${basePath}articles/index.html" class="block p-3 rounded-2xl ${isSubDir || currentPage === 'articles' ? 'text-primary font-bold bg-emerald-50 dark:bg-emerald-900/20' : 'font-medium dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800'}">প্রবন্ধ</a>

                <div>
                    <button id="mobile-other-btn" class="w-full flex justify-between items-center p-3 rounded-2xl font-medium dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 transition-all">
                        <span>অন্যান্য</span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 transform transition-transform" id="mobile-other-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" /></svg>
                    </button>
                    <div id="mobile-other-menu" class="hidden pl-6 space-y-1 mt-1">
                        <a href="${basePath}community.html" class="block p-2.5 rounded-xl text-xs ${currentPage === 'community.html' ? 'text-primary font-bold' : 'dark:text-slate-400 font-medium'}">কমিউনিটি ও প্রশ্নোত্তর</a>
                        <a href="${basePath}about.html" class="block p-2.5 rounded-xl text-xs ${currentPage === 'about.html' ? 'text-primary font-bold' : 'dark:text-slate-400 font-medium'}">আমাদের সম্পর্কে</a>
                        <a href="${basePath}credits.html" class="block p-2.5 rounded-xl text-xs ${currentPage === 'credits.html' ? 'text-primary font-bold' : 'dark:text-slate-400 font-medium'}">কৃতজ্ঞতা স্বীকার</a>
                    </div>
                </div>
                <a href="${basePath}donation.html" class="block p-3 mt-4 bg-primary text-white text-center rounded-2xl font-bold shadow-lg">দান করুন</a>
            </div>
        </header>
        `;

        // Update Footer Hijri Date immediately
        const instantHijri = (window.getInstantHijriDate && window.getInstantHijriDate()) || localStorage.getItem('deen_hijri_date') || "২৪ রবিউস সানি, ১৪৪৮ হিজরি";
        const footHijri = document.getElementById('footer-hijri-date');
        if (footHijri) footHijri.innerText = instantHijri;

        // Mobile dropdown toggles
        const mobileIbadahBtn = document.getElementById('mobile-ibadah-btn');
        const mobileIbadahMenu = document.getElementById('mobile-ibadah-menu');
        const mobileIbadahIcon = document.getElementById('mobile-ibadah-icon');
        if (mobileIbadahBtn && mobileIbadahMenu) {
            mobileIbadahBtn.onclick = () => {
                mobileIbadahMenu.classList.toggle('hidden');
                mobileIbadahIcon.classList.toggle('rotate-180');
            };
        }

        const mobileOtherBtn = document.getElementById('mobile-other-btn');
        const mobileOtherMenu = document.getElementById('mobile-other-menu');
        const mobileOtherIcon = document.getElementById('mobile-other-icon');
        if (mobileOtherBtn && mobileOtherMenu) {
            mobileOtherBtn.onclick = () => {
                mobileOtherMenu.classList.toggle('hidden');
                mobileOtherIcon.classList.toggle('rotate-180');
            };
        }

        // Theme toggle logic
        const themeToggles = document.querySelectorAll('.theme-toggle');
        const updateIcons = () => {
            const isDark = document.documentElement.classList.contains('dark');
            document.querySelectorAll('.theme-toggle-dark-icon').forEach(i => isDark ? i.classList.add('hidden') : i.classList.remove('hidden'));
            document.querySelectorAll('.theme-toggle-light-icon').forEach(i => isDark ? i.classList.remove('hidden') : i.classList.add('hidden'));
        };
        updateIcons();
        themeToggles.forEach(btn => {
            btn.onclick = () => {
                document.documentElement.classList.toggle('dark');
                localStorage.setItem('theme', document.documentElement.classList.contains('dark') ? 'dark' : 'light');
                updateIcons();
            };
        });

        // Mobile menu toggle
        const mBtn = document.getElementById('mobile-menu-btn');
        const mMenu = document.getElementById('mobile-menu');
        if (mBtn && mMenu) {
            mBtn.onclick = () => mMenu.classList.toggle('hidden');
        }

        // Initial bookmark count badge
        window.updateBookmarkBadge();
    }

    // 2. Inject Matching Full-Width Modern Footer
    const footerPlaceholder = document.getElementById('footer-placeholder');
    if (footerPlaceholder) {
        footerPlaceholder.innerHTML = `
        <footer class="mt-auto w-full bg-white dark:bg-[#080d1a] border-t border-stone-200/80 dark:border-slate-800/80 transition-colors duration-300">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 lg:py-16">
                
                <!-- Main Grid -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-12 gap-8 lg:gap-12 pb-12 border-b border-stone-200/80 dark:border-slate-800/80">
                    
                    <!-- Col 1: Brand & Bio (5 cols on lg) -->
                    <div class="lg:col-span-5 space-y-4">
                        <!-- Matching Brand Logo -->
                        <a href="${basePath}index.html" class="flex items-center space-x-3 group w-fit">
                            <div class="w-9 h-9 bg-emerald-600 group-hover:bg-emerald-700 rounded-xl flex items-center justify-center text-white shadow-sm transition-transform group-hover:scale-105">
                                <span class="text-base select-none">🌙</span>
                            </div>
                            <div class="flex flex-col">
                                <span class="text-2xl font-black text-slate-800 dark:text-white tracking-tight group-hover:text-primary transition-colors leading-tight">DeenIslam</span>
                                <span class="text-[10px] text-emerald-700 dark:text-emerald-400 font-semibold tracking-wider uppercase leading-none">দ্বীন ইসলাম • ইসলামিক নলেজ পোর্টাল</span>
                            </div>
                        </a>

                        <p class="text-slate-600 dark:text-slate-400 text-xs sm:text-sm leading-relaxed max-w-sm">
                            সহীহ কুরআন, বিশুদ্ধ হাদিস ও ইসলামিক জ্ঞানের আধুনিক ডিজিটাল প্ল্যাটফর্ম। আপনার প্রাত্যহিক দ্বীনি জীবনের নির্ভরযোগ্য সঙ্গী।
                        </p>

                        <!-- Live Hijri Badge in Footer -->
                        <div class="inline-flex items-center space-x-1.5 px-3 py-1.5 rounded-lg bg-emerald-50 dark:bg-emerald-950/40 text-emerald-800 dark:text-emerald-300 text-xs font-semibold border border-emerald-200/60 dark:border-emerald-800/40">
                            <span class="text-xs">🌙</span>
                            <span id="footer-hijri-date">২৪ রবিউস সানি, ১৪৪৮ হিজরি</span>
                        </div>

                        <div class="pt-1">
                            <span class="text-xs text-slate-400 dark:text-slate-500 font-medium">অফিশিয়াল ওয়েবসাইট: </span>
                            <a href="${basePath}index.html" class="text-xs font-bold text-primary dark:text-emerald-400 hover:underline">deenislam.org</a>
                        </div>
                    </div>

                    <!-- Col 2: Core Sections (2-3 cols on lg) -->
                    <div class="lg:col-span-2">
                        <h3 class="text-xs font-bold uppercase tracking-widest text-slate-400 dark:text-slate-500 mb-4">মূল পাতা</h3>
                        <ul class="space-y-2.5 text-xs font-semibold text-slate-600 dark:text-slate-400">
                            <li><a href="${basePath}index.html" class="hover:text-primary dark:hover:text-white transition-colors">হোম</a></li>
                            <li><a href="${basePath}quran.html" class="hover:text-primary dark:hover:text-white transition-colors">আল-কুরআন</a></li>
                            <li><a href="${basePath}hadith.html" class="hover:text-primary dark:hover:text-white transition-colors">সহীহ হাদিস</a></li>
                            <li><a href="${basePath}seerah.html" class="hover:text-primary dark:hover:text-white transition-colors">সীরাতুন্নবী (ﷺ)</a></li>
                            <li><a href="${basePath}salat.html" class="hover:text-primary dark:hover:text-white transition-colors">সালাতের সময়সূচি</a></li>
                            <li><a href="${basePath}namaz.html" class="hover:text-primary dark:hover:text-white transition-colors">নামাজ শিক্ষা</a></li>
                            <li><a href="${basePath}articles/index.html" class="hover:text-primary dark:hover:text-white transition-colors">ইসলামিক প্রবন্ধ</a></li>
                        </ul>
                    </div>

                    <!-- Col 3: Ibadah & Tools (3 cols on lg) -->
                    <div class="lg:col-span-3">
                        <h3 class="text-xs font-bold uppercase tracking-widest text-slate-400 dark:text-slate-500 mb-4">ইবাদত ও টুলস</h3>
                        <ul class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-1 gap-2.5 text-xs font-semibold text-slate-600 dark:text-slate-400">
                            <li><a href="${basePath}qibla.html" class="hover:text-primary dark:hover:text-white transition-colors flex items-center space-x-1.5"><span>🧭</span><span>কিবলা কম্পাস</span></a></li>
                            <li><a href="${basePath}tasbih.html" class="hover:text-primary dark:hover:text-white transition-colors flex items-center space-x-1.5"><span>📿</span><span>ডিজিটাল তাসবীহ</span></a></li>
                            <li><a href="${basePath}dua.html" class="hover:text-primary dark:hover:text-white transition-colors flex items-center space-x-1.5"><span>🤲</span><span>হিসনুল মুসলিম দো'আ</span></a></li>
                            <li><a href="${basePath}allah-names.html" class="hover:text-primary dark:hover:text-white transition-colors flex items-center space-x-1.5"><span>🌟</span><span>আল্লাহর ৯৯ নাম</span></a></li>
                            <li><a href="${basePath}zakat.html" class="hover:text-primary dark:hover:text-white transition-colors flex items-center space-x-1.5"><span>💎</span><span>যাকাত ক্যালকুলেটর</span></a></li>
                            <li><a href="${basePath}roja.html" class="hover:text-primary dark:hover:text-white transition-colors flex items-center space-x-1.5"><span>🌙</span><span>রোজা ও সেহরি-ইফতার</span></a></li>
                            <li><a href="${basePath}hajj.html" class="hover:text-primary dark:hover:text-white transition-colors flex items-center space-x-1.5"><span>🕋</span><span>হজ ও উমরাহ গাইড</span></a></li>
                        </ul>
                    </div>

                    <!-- Col 4: Community & Support (2 cols on lg) -->
                    <div class="lg:col-span-2">
                        <h3 class="text-xs font-bold uppercase tracking-widest text-slate-400 dark:text-slate-500 mb-4">যুক্ত হোন</h3>
                        <p class="text-xs text-slate-500 dark:text-slate-400 mb-3 font-mono">contact@deenislam.org</p>
                        
                        <div class="space-y-2.5">
                            <a href="https://www.facebook.com/groups/deenislam.org/" target="_blank" rel="noopener noreferrer" class="inline-flex items-center space-x-2 bg-[#1877F2] text-white px-3.5 py-2 rounded-xl font-bold text-xs hover:bg-[#166fe5] transition-all shadow-sm w-full justify-center">
                                <svg class="w-3.5 h-3.5" fill="currentColor" viewBox="0 0 24 24"><path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-0.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/></svg>
                                <span>ফেসবুক গ্রুপ</span>
                            </a>
                            <a href="${basePath}community.html" class="block text-center py-2 px-3 rounded-xl bg-stone-100/90 dark:bg-slate-800/80 text-slate-700 dark:text-slate-300 hover:text-primary dark:hover:text-primary text-xs font-semibold transition-all border border-stone-200 dark:border-slate-700">
                                প্রশ্নোত্তর ফোরাম →
                            </a>
                            <a href="${basePath}donation.html" class="block text-center py-2 px-3 rounded-xl bg-emerald-50 dark:bg-emerald-950/40 text-primary dark:text-emerald-400 hover:bg-emerald-600 hover:text-white dark:hover:bg-emerald-600 dark:hover:text-white text-xs font-bold transition-all border border-emerald-200/60 dark:border-emerald-800/60">
                                সদকা ও দান 💖
                            </a>
                        </div>
                    </div>

                </div>

                <!-- Bottom Bar -->
                <div class="pt-8 flex flex-col sm:flex-row justify-between items-center text-xs text-slate-500 dark:text-slate-400 gap-4">
                    <div class="flex items-center space-x-2">
                        <span>© 2026 DeenIslam.org</span>
                        <span>•</span>
                        <span>শুদ্ধ দ্বীনি জ্ঞানের উন্মুক্ত ভাণ্ডার</span>
                    </div>
                    <div class="flex flex-wrap justify-center items-center gap-4 text-xs font-medium">
                        <a href="${basePath}about.html" class="hover:text-primary transition-colors">আমাদের সম্পর্কে</a>
                        <span>•</span>
                        <a href="${basePath}credits.html" class="hover:text-primary transition-colors">কৃতজ্ঞতা স্বীকার</a>
                    </div>
                </div>

            </div>
        </footer>
        `;
    }
});
