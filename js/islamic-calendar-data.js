/**
 * DeenIslam - Islamic Calendar & Hijri Events Dataset and Engine
 * Comprehensive Islamic calendar algorithms, Hijri-Gregorian converters,
 * sacred months, fasting guidelines, and recurring annual Islamic events.
 */

(function () {
    const ISLAMIC_MONTHS = [
        {
            number: 1,
            nameBn: "মুহাররম",
            nameAr: "المُحَرَّم",
            nameEn: "Muharram",
            isSacred: true,
            meaning: "পবিত্র ও নিষিদ্ধ মাস",
            significance: "হিজরি সনের প্রথম মাস। চার সম্মানিত মাসের অন্যতম। পবিত্র আশুরা (১০ মুহাররম) ও কারবালার ঐতিহাসিক ঘটনার মাস।"
        },
        {
            number: 2,
            nameBn: "সফর",
            nameAr: "صَفَر",
            nameEn: "Safar",
            isSacred: false,
            meaning: "শূন্যতা / গৃহত্যাগ",
            significance: "ইসলামে কোনো মাস বা দিনকে অশুভ মনে করা নিষিদ্ধ। কুসংস্কারমুক্ত ঈমানী জিন্দেগির শিক্ষা দেয় এই মাস।"
        },
        {
            number: 3,
            nameBn: "রবিউল আউয়াল",
            nameAr: "رَبِيع الأَوَّل",
            nameEn: "Rabi' al-Awwal",
            isSacred: false,
            meaning: "প্রথম বসন্ত",
            significance: "সাইয়্যিদুল মুরসালীন হযরত মুহাম্মদ (ﷺ)-এর শুভাগমন, ঐতিহাসিক হিজরত এবং ওফাতের বরকতময় মাস।"
        },
        {
            number: 4,
            nameBn: "রবিউস সানি",
            nameAr: "رَبِيع الآخِر",
            nameEn: "Rabi' al-Thani",
            isSacred: false,
            meaning: "দ্বিতীয় বসন্ত",
            significance: "ঈমান বৃদ্ধি, জ্ঞানার্জন এবং আত্মশুদ্ধির অনুশীলনের মাস।"
        },
        {
            number: 5,
            nameBn: "জমাদিউল আউয়াল",
            nameAr: "جُمَادَى الأُولَى",
            nameEn: "Jumada al-Awwal",
            isSacred: false,
            meaning: "প্রথম হিম / শীত",
            significance: "ঐতিহাসিক মুতার যুদ্ধ এবং ইসলামের বিস্তার সংক্রান্ত বহু গুরুত্বপূর্ণ ঘটনার সাক্ষী।"
        },
        {
            number: 6,
            nameBn: "জমাদিউস সানি",
            nameAr: "جُمَادَى الآخِرَة",
            nameEn: "Jumada al-Thani",
            isSacred: false,
            meaning: "দ্বিতীয় হিম / শীত",
            significance: "ইসলামের প্রথম খলিফা হযরত আবু বকর সিদ্দিক (রা.)-এর ওফাত ও ইয়ারমুকের যুদ্ধ।"
        },
        {
            number: 7,
            nameBn: "রজব",
            nameAr: "رَجَب",
            nameEn: "Rajab",
            isSacred: true,
            meaning: "মর্যাদাপূর্ণ / সম্মানিত",
            significance: "চার সম্মানিত মাসের একটি। পবিত্র শবে মেরাজ এবং আসন্ন মাহে রমজানের ইবাদতের পূর্বপ্রস্তুতির শুভ সূচনা।"
        },
        {
            number: 8,
            nameBn: "শাবান",
            nameAr: "شَعْبَان",
            nameEn: "Sha'ban",
            isSacred: false,
            meaning: "শাখা-প্রশাখা বিস্তার",
            significance: "নবীজী (ﷺ) এ মাসে সর্বাধিক নফল রোজা রাখতেন। শবে বরাত (লাইলাতুন নিসফি মিন শাবান) ও রমজানের চূড়ান্ত প্রস্তুতি।"
        },
        {
            number: 9,
            nameBn: "রমজান",
            nameAr: "رَمَضَان",
            nameEn: "Ramadan",
            isSacred: false,
            meaning: "দহন / আত্মশুদ্ধি",
            significance: "কুরআন অবতীর্ণ হওয়ার শ্রেষ্ঠ মাস। এক মাসব্যাপী ফরজ রোজা, তারাবিহ, ইতিকাফ এবং হাজার মাসের চেয়ে উত্তম 'লাইলাতুল কদর'।"
        },
        {
            number: 10,
            nameBn: "শাওয়াল",
            nameAr: "شَوَّال",
            nameEn: "Shawwal",
            isSacred: false,
            meaning: "উত্তোলন / সমৃদ্ধি",
            significance: "১লা শাওয়াল আনন্দ ও কৃতজ্ঞতার 'পবিত্র ঈদুল ফিতর'। পুরো বছর রোজা রাখার সমতুল্য সওয়াবের ৬টি সুন্নাত রোজা।"
        },
        {
            number: 11,
            nameBn: "জিলকদ",
            nameAr: "ذُو القَعْدَة",
            nameEn: "Dhu al-Qi'dah",
            isSacred: true,
            meaning: "বিশ্রামের মাস (যুদ্ধবিরতি)",
            significance: "চার সম্মানিত মাসের অন্যতম এবং হজের মাসসমূহের প্রথম। বায়তুল্লাহর উদ্দেশ্যে হজযাত্রীদের যাত্রা শুরু হয়।"
        },
        {
            number: 12,
            nameBn: "জিলহজ",
            nameAr: "ذُو الحِجَّة",
            nameEn: "Dhu al-Hijjah",
            isSacred: true,
            meaning: "পবিত্র হজের মাস",
            significance: "ইসলামের পঞ্চম স্তম্ভ পবিত্র হজ, আরাফার দিনের শ্রেষ্ঠ রোজা, ঈদুল আজহা (কোরবানি) ও তাশরিকের তাকবির।"
        }
    ];

    const ISLAMIC_ANNUAL_EVENTS = [
        {
            id: "hijri_new_year",
            month: 1,
            day: 1,
            titleBn: "পবিত্র হিজরি নববর্ষ",
            titleEn: "Islamic New Year (1st Muharram)",
            category: "নববর্ষ",
            badge: "🎉 নতুন হিজরি বছর",
            icon: "🌙",
            description: "নতুন হিজরি সনের প্রথম দিন। রাসূলুল্লাহ (ﷺ)-এর মদিনায় হিজরতের ঐতিহাসিক স্মৃতিবিজড়িত বর্ষগণনা।"
        },
        {
            id: "ashura_tasua",
            month: 1,
            day: 9,
            titleBn: "পবিত্র তাসুআ (আশুরার পূর্বের রোজা)",
            titleEn: "Tasu'a (9th Muharram)",
            category: "রোজা",
            badge: "🤲 মুস্তাহাব রোজা",
            icon: "✨",
            description: "রাসূলুল্লাহ (ﷺ) আশুরার সাথে মিলিয়ে ৯ ও ১০ অথবা ১০ ও ১১ মুহাররম রোজা রাখতে নির্দেশ দিয়েছেন।"
        },
        {
            id: "ashura",
            month: 1,
            day: 10,
            titleBn: "পবিত্র আশুরা",
            titleEn: "Day of Ashura (10th Muharram)",
            category: "ঐতিহাসিক ও রোজা",
            badge: "⭐ বিগত ১ বছরের পাপ মোচনকারী রোজা",
            icon: "🌟",
            description: "মুসা (আ.) ও বনী ইসরাঈলকে ফেরাউনের কবল থেকে মুক্তির দিন এবং কারবালার মর্মান্তিক শাহাদাতের স্মরণীয় দিন।"
        },
        {
            id: "seerah_un_nabi",
            month: 3,
            day: 12,
            titleBn: "সিরাতুন্নবী (ﷺ) / রাসূল (ﷺ)-এর শুভাগমন ও ওফাত",
            titleEn: "Milad un Nabi / Seerah (12th Rabi' al-Awwal)",
            category: "ঐতিহাসিক",
            badge: "📖 সিরাত চর্চা",
            icon: "🌸",
            description: "বিশ্বনবী হযরত মুহাম্মদ (ﷺ)-এর বরকতময় জীবন ও সিরাত অধ্যয়নের অনুপ্রেরণার দিন।"
        },
        {
            id: "shab_e_miraj",
            month: 7,
            day: 27,
            titleBn: "পবিত্র শবে মেরাজ (লাইলাতুল মেরাজ)",
            titleEn: "Shab-e-Miraj (27th Rajab)",
            category: "ঐতিহাসিক ও ইবাদত",
            badge: "🌌 উর্ধ্বাকাশ ভ্রমণ ও ৫ ওয়াক্ত সালাত",
            icon: "🚀",
            description: "রাসূলুল্লাহ (ﷺ)-এর মসজিদুল হারাম থেকে মসজিদুল আকসা ও সপ্তাকাশ ভ্রমণ করে পাঁচ ওয়াক্ত সালাতের উপহার প্রাপ্তি।"
        },
        {
            id: "shab_e_barat",
            month: 8,
            day: 15,
            titleBn: "পবিত্র শবে বরাত (লাইলাতুন নিসফি মিন শাবান)",
            titleEn: "Shab-e-Barat (15th Sha'ban)",
            category: "ইবাদত ও ক্ষমা",
            badge: "🤲 মাগফিরাত ও ক্ষমা",
            icon: "💫",
            description: "শাবান মাসের মধ্যবর্তী রজনী। আল্লাহর রহমত ও বান্দার পাপ মার্জনার বিশেষ রজনী।"
        },
        {
            id: "ramadan_start",
            month: 9,
            day: 1,
            titleBn: "পবিত্র মাহে রমজান শুরু (১ম রোজা)",
            titleEn: "First Day of Ramadan",
            category: "ফরজ ইবাদত",
            badge: "🌙 মাহে রমজান মোবারক",
            icon: "🕌",
            description: "রহমত, মাগফিরাত ও নাজাতের পবিত্র মাস। সুবহে সাদেক থেকে সূর্যাস্ত পর্যন্ত এক মাসব্যাপী ফরজ রোজা পালন শুরু।"
        },
        {
            id: "badr_day",
            month: 9,
            day: 17,
            titleBn: "ঐতিহাসিক বদর দিবস (১৭ রমজান)",
            titleEn: "Battle of Badr (17th Ramadan)",
            category: "ঐতিহাসিক",
            badge: "⚔️ হক ও বাতিলের চূড়ান্ত ফয়সালা",
            icon: "🛡️",
            description: "ইসলামের প্রথম প্রকাশ্য যুদ্ধ। ৩১৩ জন নিঃস্ব সাহাবীর মোকাবেলায় আল্লাহর পক্ষ থেকে ফেরেশতাদের মাধ্যমে বিজয় দান।"
        },
        {
            id: "mecca_conquest",
            month: 9,
            day: 20,
            titleBn: "ঐতিহাসিক মক্কা বিজয় (২০ রমজান)",
            titleEn: "Conquest of Mecca (20th Ramadan)",
            category: "ঐতিহাসিক",
            badge: "🕋 তাওহীদের বিজয় ও ক্ষমার পরাকাষ্ঠা",
            icon: "🚩",
            description: "রক্তপাতহীন মক্কা বিজয় এবং কা'বা ঘরকে ৩৬০টি মূর্তির অপবিত্রতা থেকে মুক্ত করে তাওহীদের পুনঃপ্রতিষ্ঠা।"
        },
        {
            id: "laylatul_qadr_27",
            month: 9,
            day: 27,
            titleBn: "পবিত্র শবে কদর (লাইলাতুল কদর - সম্ভাব্য প্রধান রাত)",
            titleEn: "Laylatul Qadr (27th Ramadan)",
            category: "শ্রেষ্ঠ রজনী",
            badge: "👑 হাজার মাসের চেয়ে শ্রেষ্ঠ রাত",
            icon: "✨",
            description: "রমজানের শেষ দশকের বিজোড় রাতগুলোর অন্যতম। এ রাতে ইবাদত ১,০০০ মাস (৮৩ বছর ৪ মাস) ইবাদতের চেয়েও শ্রেষ্ঠ।"
        },
        {
            id: "eid_ul_fitr",
            month: 10,
            day: 1,
            titleBn: "পবিত্র ঈদুল ফিতর (রোজার ঈদ)",
            titleEn: "Eid-ul-Fitr (1st Shawwal)",
            category: "ঈদ ও উৎসব",
            badge: "🎉 রোজা রাখা হারাম / আনন্দ উৎসব",
            icon: "🎁",
            description: "এক মাসের সিয়াম সাধনার পর বিশ্ব মুসলিমের পরম আনন্দের উৎসব। ফিতরা আদায় ও ঈদের সালাত আদায় করা ওয়াজিব।"
        },
        {
            id: "six_fasts_shawwal",
            month: 10,
            day: 2,
            titleBn: "শাওয়ালের ৬ রোজা শুরু",
            titleEn: "Six Sunnah Fasts of Shawwal",
            category: "সুন্নাত রোজা",
            badge: "💎 পুরো বছর রোজার সমান সওয়াব",
            icon: "🗓️",
            description: "রাসূল (ﷺ) বলেন: যে রমজানের রোজা রাখল অতঃপর শাওয়ালের ৬টি রোজা রাখল, সে যেন সারা বছরই রোজা রাখল। (সহীহ মুসলিম)"
        },
        {
            id: "ten_days_dhul_hijjah",
            month: 12,
            day: 1,
            titleBn: "জিলহজের প্রথম দশক শুরু",
            titleEn: "First 10 Days of Dhu al-Hijjah",
            category: "শ্রেষ্ঠ দিনসমূহ",
            badge: "🌿 বছরের শ্রেষ্ঠ ১০ দিন",
            icon: "💎",
            description: "রাসূল (ﷺ) বলেন: যিলহজের প্রথম ১০ দিনের সৎকাজের চেয়ে আল্লাহর কাছে অধিক প্রিয় অন্য কোনো দিনের আমল নেই। (বুখারী)"
        },
        {
            id: "hajj_days",
            month: 12,
            day: 8,
            titleBn: "পবিত্র হজের মূল কার্যক্রম শুরু (৮-১২ জিলহজ)",
            titleEn: "Hajj Pilgrimage Begins (8th Dhu al-Hijjah)",
            category: "ফরজ হজ",
            badge: "🕋 লাব্বাইকা আল্লাহুম্মা লাব্বাইক",
            icon: "🕋",
            description: "মিনায় অবস্থানের মধ্য দিয়ে শুরু হয় ইসলামের অন্যতম মহান ফরজ ইবাদত পবিত্র হজের মূল আনুষ্ঠানিকতা।"
        },
        {
            id: "arafah_day",
            month: 12,
            day: 9,
            titleBn: "পবিত্র ইয়াওমু আরাফাহ (আরাফার দিন ও রোজা)",
            titleEn: "Day of Arafah (9th Dhu al-Hijjah)",
            category: "শ্রেষ্ঠ দিন ও রোজা",
            badge: "⭐ আগের ও পরের ২ বছরের পাপ মোচনকারী রোজা",
            icon: "🤲",
            description: "হজের মূল দিন এবং সারা বছরের সর্বশ্রেষ্ঠ দিন। যারা হজে নন তাদের জন্য আরাফার রোজা রাখা অত্যন্ত মর্যাদাপূর্ণ সুন্নাত।"
        },
        {
            id: "eid_ul_adha",
            month: 12,
            day: 10,
            titleBn: "পবিত্র ঈদুল আজহা (কোরবানির ঈদ)",
            titleEn: "Eid-ul-Adha (10th Dhu al-Hijjah)",
            category: "ঈদ ও কোরবানি",
            badge: "🎉 রোজা রাখা হারাম / কোরবানি ওয়াজিব",
            icon: "🐑",
            description: "হযরত ইব্রাহিম (আ.) ও ইসমাইল (আ.)-এর মহান আত্মত্যাগের স্মরণে পশু কোরবানি ও তাকবিরের দিন।"
        },
        {
            id: "ayyam_at_tashreeq",
            month: 12,
            day: 11,
            titleBn: "আইয়ামে তাশরিক শুরু (১১, ১২ ও ১৩ জিলহজ)",
            titleEn: "Days of Tashreeq (11-13 Dhu al-Hijjah)",
            category: "তাকবির ও খাবার",
            badge: "🚫 রোজা রাখা সম্পূর্ণ হারাম",
            icon: "📢",
            description: "পানাহার ও আল্লাহর জিকিরের দিন। প্রত্যেক ফরজ সালাতের পর 'তাকবিরে তাশরিক' পাঠ করা ওয়াজিব। এ দিনগুলোতে রোজা রাখা হারাম।"
        }
    ];

    const FASTING_RULES = [
        {
            id: "ayyam_al_beed",
            titleBn: "আইয়ামে বিজ (প্রতি হিজরি মাসের ১৩, ১৪ ও ১৫ তারিখ)",
            titleEn: "Ayyam al-Beed (The White Days)",
            rulingBn: "মুস্তাহাব / সুন্নাত",
            hadithBn: "হযরত আবু হুরায়রা (রা.) বলেন, আমার প্রিয় বন্ধু (রাসূল ﷺ) আমাকে প্রতি মাসে তিনটি করে রোজা রাখার অসিয়ত করেছেন। (সহীহ বুখারী: ১৯৮১)",
            virtueBn: "প্রতি হিজরি মাসের পূর্ণিমার রাতে চাঁদ যখন সবচেয়ে উজ্জ্বল থাকে, তখন এ ৩টি রোজা রাখা সারা বছর রোজা রাখার সমান।"
        },
        {
            id: "monday_thursday",
            titleBn: "সাপ্তাহিক সোম ও বৃহস্পতিবারের রোজা",
            titleEn: "Mondays & Thursdays Sunnah Fasting",
            rulingBn: "মুস্তাহাব / সুন্নাত",
            hadithBn: "রাসূলুল্লাহ (ﷺ) বলেন, 'সোম ও বৃহস্পতিবার আল্লাহর দরবারে বান্দার আমল পেশ করা হয়। তাই আমি ভালোবাসি যে, রোজা অবস্থায় যেন আমার আমল পেশ করা হোক।' (তিরমিযী: ৭৪৭)",
            virtueBn: "সাপ্তাহিক গুনাহ মাফ এবং নবীজী (ﷺ)-এর অনুসরণের অপূর্ব সুযোগ।"
        },
        {
            id: "prohibited_days",
            titleBn: "যে দিনগুলোতে রোজা রাখা সম্পূর্ণ হারাম (নিষিদ্ধ)",
            titleEn: "Prohibited Days for Fasting",
            rulingBn: "হারাম (কবিরা গুনাহ)",
            hadithBn: "রাসূলুল্লাহ (ﷺ) দুই ঈদের দিনে (ঈদুল ফিতর ও ঈদুল আজহা) রোজা রাখতে নিষেধ করেছেন। (সহীহ বুখারী: ১৯৯০, মুসলিম: ১১৪০)",
            virtueBn: "১. ঈদুল ফিতরের দিন (১ শাওয়াল), ২. ঈদুল আজহার দিন (১০ জিলহজ), ৩. তাশরিকের ৩ দিন (১১, ১২ ও ১৩ জিলহজ)। মোট ৫ দিন রোজা রাখা হারাম।"
        }
    ];

    /**
     * Algorithmic Gregorian to Hijri conversion (Kuwait tabular base + manual offset)
     * @param {Date|string} dateInput 
     * @param {number} manualOffset in days (-2, -1, 0, 1, 2)
     * @returns {Object}
     */
    function gregorianToHijri(dateInput, manualOffset) {
        const d = dateInput ? new Date(dateInput) : new Date();
        const offset = (typeof manualOffset === 'number') ? manualOffset : getStoredOffset();

        // Apply offset days
        const targetDate = new Date(d.getTime() + offset * 86400000);

        let day = targetDate.getDate();
        let month = targetDate.getMonth(); // 0-based
        let year = targetDate.getFullYear();

        let m = month + 1;
        let y = year;
        if (m < 3) {
            y -= 1;
            m += 12;
        }

        const a = Math.floor(y / 100);
        const b = 2 - a + Math.floor(a / 4);
        const jd = Math.floor(365.25 * (y + 4716)) + Math.floor(30.6001 * (m + 1)) + day + b - 1524;

        const z = jd - 1948084;
        const hy = Math.floor((30 * z + 10646) / 10631);
        const hm = Math.min(12, Math.ceil((z - 29 - (hy - 1) * 354 - Math.floor((3 + 11 * hy) / 30)) / 29.5) + 1);
        const hd = Math.floor(z - Math.floor(29.5001 * (hm - 1)) - (hy - 1) * 354 - Math.floor((3 + 11 * hy) / 30) + 1);

        const monthObj = ISLAMIC_MONTHS.find(m => m.number === hm) || {
            number: hm,
            nameBn: "অজানা মাস",
            nameAr: "",
            nameEn: "",
            isSacred: false
        };

        const isWhiteDay = (hd === 13 || hd === 14 || hd === 15);
        const isProhibitedFasting = (hm === 10 && hd === 1) || (hm === 12 && (hd >= 10 && hd <= 13));
        const isFriday = targetDate.getDay() === 5;
        const isMonday = targetDate.getDay() === 1;
        const isThursday = targetDate.getDay() === 4;

        // Check if matching any major Islamic event
        const matchingEvents = ISLAMIC_ANNUAL_EVENTS.filter(ev => ev.month === hm && ev.day === hd);

        const toBn = window.toBengaliNumerals || ((n) => String(n));

        return {
            day: hd,
            month: hm,
            year: hy,
            dayBn: toBn(hd),
            yearBn: toBn(hy),
            monthNameBn: monthObj.nameBn,
            monthNameAr: monthObj.nameAr,
            monthNameEn: monthObj.nameEn,
            isSacredMonth: monthObj.isSacred,
            isWhiteDay: isWhiteDay,
            isProhibitedFasting: isProhibitedFasting,
            isFriday: isFriday,
            isMonday: isMonday,
            isThursday: isThursday,
            events: matchingEvents,
            gregorianDate: targetDate,
            formattedBn: `${toBn(hd)} ${monthObj.nameBn}, ${toBn(hy)} হিজরি`
        };
    }

    /**
     * Approximate Hijri to Gregorian conversion
     * @param {number} hYear 
     * @param {number} hMonth 1-12
     * @param {number} hDay 1-30
     * @param {number} manualOffset 
     * @returns {Date}
     */
    function hijriToGregorian(hYear, hMonth, hDay, manualOffset) {
        const offset = (typeof manualOffset === 'number') ? manualOffset : getStoredOffset();
        const z = Math.floor((11 * hYear + 3) / 30) + 354 * (hYear - 1) + Math.floor(29.5001 * (hMonth - 1)) + hDay + 1948084 - 1;
        const jd = z;

        const l = jd + 68569;
        const n = Math.floor((4 * l) / 146097);
        const l2 = l - Math.floor((146097 * n + 3) / 4);
        const i = Math.floor((4000 * (l2 + 1)) / 1461001);
        const l3 = l2 - Math.floor((1461 * i) / 4) + 31;
        const j = Math.floor((80 * l3) / 2447);
        const d = l3 - Math.floor((2447 * j) / 80);
        const l4 = Math.floor(j / 11);
        const m = j + 2 - 12 * l4;
        const y = 100 * (n - 49) + i + l4;

        const baseDate = new Date(Date.UTC(y, m - 1, d));
        // Remove offset so that gregorian matches when reversed
        return new Date(baseDate.getTime() - offset * 86400000);
    }

    /**
     * Get or set Hijri Offset (-2, -1, 0, +1, +2)
     */
    function getStoredOffset() {
        try {
            const val = localStorage.getItem('deen_hijri_offset');
            if (val !== null) {
                const parsed = parseInt(val, 10);
                if (!isNaN(parsed) && parsed >= -3 && parsed <= 3) return parsed;
            }
        } catch (e) {}
        return 0;
    }

    function setStoredOffset(offset) {
        try {
            localStorage.setItem('deen_hijri_offset', String(offset));
            localStorage.removeItem('deen_hijri_date'); // clear cached text so components.js updates
        } catch (e) {}
    }

    /**
     * Compute upcoming events sorted chronologically by days remaining
     * @param {Date} [baseDate]
     * @param {number} [manualOffset]
     */
    function getUpcomingEvents(baseDate, manualOffset) {
        const now = baseDate ? new Date(baseDate) : new Date();
        const currentHijri = gregorianToHijri(now, manualOffset);
        const currentHYear = currentHijri.year;

        const result = [];

        ISLAMIC_ANNUAL_EVENTS.forEach(ev => {
            // Find Gregorian equivalent in current Hijri year
            let eventGregorian = hijriToGregorian(currentHYear, ev.month, ev.day, manualOffset);
            
            // If already passed more than 1 day ago, target next Hijri year
            const diffTime = eventGregorian.getTime() - now.getTime();
            let targetHYear = currentHYear;
            if (diffTime < -86400000) {
                targetHYear = currentHYear + 1;
                eventGregorian = hijriToGregorian(targetHYear, ev.month, ev.day, manualOffset);
            }

            const diffMs = eventGregorian.getTime() - now.getTime();
            const daysRemaining = Math.ceil(diffMs / 86400000);

            result.push({
                ...ev,
                hijriYear: targetHYear,
                targetGregorianDate: eventGregorian,
                daysRemaining: daysRemaining,
                isToday: daysRemaining === 0,
                isPast: daysRemaining < 0
            });
        });

        // Sort by days remaining (closest upcoming first)
        result.sort((a, b) => a.daysRemaining - b.daysRemaining);
        return result;
    }

    /**
     * Generates day-by-day calendar data for an entire Hijri month
     * @param {number} hYear 
     * @param {number} hMonth 1-12
     * @param {number} [manualOffset]
     */
    function getMonthCalendar(hYear, hMonth, manualOffset) {
        const daysInMonth = (hMonth % 2 === 1 || (hMonth === 12 && ((11 * hYear + 14) % 30 < 11))) ? 30 : 29;
        const days = [];
        const toBn = window.toBengaliNumerals || ((n) => String(n));

        for (let d = 1; d <= daysInMonth; d++) {
            const gDate = hijriToGregorian(hYear, hMonth, d, manualOffset);
            const isWhiteDay = (d === 13 || d === 14 || d === 15);
            const isProhibited = (hMonth === 10 && d === 1) || (hMonth === 12 && (d >= 10 && d <= 13));
            const isFriday = gDate.getDay() === 5;
            const matchingEvents = ISLAMIC_ANNUAL_EVENTS.filter(ev => ev.month === hMonth && ev.day === d);

            days.push({
                hijriDay: d,
                hijriDayBn: toBn(d),
                hijriMonth: hMonth,
                hijriYear: hYear,
                gregorianDate: gDate,
                gregorianDay: gDate.getDate(),
                gregorianMonth: gDate.getMonth() + 1,
                gregorianDayOfWeek: gDate.getDay(),
                isWhiteDay,
                isProhibitedFasting: isProhibited,
                isFriday,
                events: matchingEvents
            });
        }

        return {
            year: hYear,
            month: hMonth,
            monthInfo: ISLAMIC_MONTHS.find(m => m.number === hMonth),
            totalDays: daysInMonth,
            days: days
        };
    }

    // Expose to window
    window.IslamicCalendarData = {
        MONTHS: ISLAMIC_MONTHS,
        EVENTS: ISLAMIC_ANNUAL_EVENTS,
        FASTING_RULES: FASTING_RULES,
        gregorianToHijri: gregorianToHijri,
        hijriToGregorian: hijriToGregorian,
        getStoredOffset: getStoredOffset,
        setStoredOffset: setStoredOffset,
        getUpcomingEvents: getUpcomingEvents,
        getMonthCalendar: getMonthCalendar
    };

})();
