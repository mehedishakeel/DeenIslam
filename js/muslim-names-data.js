/**
 * DeenIslam - Authentic Muslim Names & Meanings Database
 * Curated from authentic Quran, Hadith, and Islamic history sources.
 */

window.muslimNamesData = {
    // Guidelines on Naming in Islam
    guidelines: [
        {
            title: "সন্তানের সুন্দর নাম রাখা পিতামাতার কর্তব্য",
            desc: "রাসূলুল্লাহ (ﷺ) বলেছেন: 'কিয়ামতের দিন তোমাদেরকে তোমাদের নিজেদের নাম ও তোমাদের পিতার নাম ধরে ডাকা হবে। সুতরাং তোমরা তোমাদের নামগুলো সুন্দর ও অর্থবহ রাখো।' (সুনানে আবু দাউদ: ৪৯৪৮, সহীহ)।"
        },
        {
            title: "আল্লাহর নিকট সর্বাধিক প্রিয় নাম",
            desc: "রাসূলুল্লাহ (ﷺ) বলেছেন: 'আল্লাহ তা'আলার নিকট তোমাদের সর্বাধিক প্রিয় নাম হলো আব্দুল্লাহ (আল্লাহর বান্দা) এবং আব্দুর রহমান (পরম করুণাময়ের বান্দা)।' (সহীহ মুসলিম: ২১৩২)।"
        },
        {
            title: "আকীকার দিনে নাম রাখার সুন্নাত",
            desc: "রাসূলুল্লাহ (ﷺ) নবজাতকের জন্মের সপ্তম দিনে মাথা মুণ্ডন, নাম রাখা ও আকীকা করার নির্দেশ দিয়েছেন। তবে জন্মের প্রথম দিনও নাম রাখা বৈধ। (জামে আত-তিরমিযী: ১৫২২)।"
        },
        {
            title: "নবী-রাসূল ও নেককার সাহাবীদের নামে নাম রাখা",
            desc: "রাসূলুল্লাহ (ﷺ) বলেছেন: 'তোমরা নবীদের নামে নাম রাখো।' (আবু দাউদ: ৪৯৫০)। সাহাবী ও পুণ্যবানদের নামে নাম রাখা মুস্তাহাব যাতে সন্তানের মধ্যে তাঁদের উত্তম চরিত্রের প্রভাব পড়ে।"
        },
        {
            title: "শিরকী ও নিষিদ্ধ নাম বর্জন",
            desc: "আল্লাহ ছাড়া অন্য কারো দাসত্ব প্রকাশক নাম (যেমন: আব্দুশ শামস, গোলাম রসূল, গোলাম নবী) এবং অহংকারসূচক নাম (যেমন: শাহেনশাহ, মালিকুল মুলক) রাখা সম্পূর্ণ হারাম ও নিষিদ্ধ।"
        }
    ],

    // Prohibited & Disliked Names Guide
    prohibitedNames: [
        { name: "গোলাম রসূল / গোলাম নবী", arabic: "غلام الرسول", reason: "আল্লাহ ছাড়া অন্য কারো দাসত্ব প্রকাশ পায়, যা তাওহীদের পরিপন্থী।" },
        { name: "আব্দুশ শামস / আব্দুল কা'বা", arabic: "عبد الشمس / عبد الكعبة", reason: "সূর্য বা কাবার বান্দা—সরাসরি শিরকী নাম।" },
        { name: "শাহেনশাহ / মালিকুল আমলাক", arabic: "شاهنشاه / ملك الأملاك", reason: "রাজাদের রাজা—এই গুণ কেবল মহান আল্লাহ তা'আলার জন্য নির্ধারিত।" },
        { name: "ফারআউন / কারুন / হামান / আবু জাহল", arabic: "فرعون / قارون / أبو جهل", reason: "অভিশপ্ত কাফের ও জালিমদের নাম ধারণ করা নিষিদ্ধ।" },
        { name: "বাররাহ (অতি নেককার)", arabic: "برّة", reason: "আত্মঅহংকার প্রকাশ পায়। রাসূল (ﷺ) বিবি বাররাহর নাম পরিবর্তন করে 'যয়নাব' রেখেছিলেন।" },
        { name: "হারব (যুদ্ধ) / মুররাহ (তিক্ত)", arabic: "حرب / مرّة", reason: "অশান্তি ও অশুভ অর্থ বহন করে। রাসূল (ﷺ) এ ধরনের নাম অপছন্দ করতেন।" }
    ],

    // Comprehensive Names List
    names: [
        // --- BOYS ---
        { id: 1, gender: "boy", letter: "অ", name: "আব্দুল্লাহ", arabic: "عَبْدُ اللَّه", english: "Abdullah", meaning: "আল্লাহর বান্দা বা দাস। আল্লাহর নিকট সর্বাধিক প্রিয় নাম।", tag: "beloved", ref: "সহীহ মুসলিম: ২১৩২" },
        { id: 2, gender: "boy", letter: "অ", name: "আব্দুর রহমান", arabic: "عَبْدُ الرَّحْمَٰن", english: "Abdur Rahman", meaning: "পরম করুণাময়ের বান্দা বা সেবক। আল্লাহর নিকট সবচেয়ে প্রিয় নাম।", tag: "beloved", ref: "সহীহ মুসলিম: ২১৩২" },
        { id: 3, gender: "boy", letter: "ম", name: "মুহাম্মদ", arabic: "مُحَمَّد", english: "Muhammad", meaning: "প্রশংসিত, যাঁর সর্বাধিক প্রশংসা করা হয়েছে। সর্বশ্রেষ্ঠ নবী ও রাসূল (ﷺ)।", tag: "prophet", ref: "সূরা আল-ইমরান: ১৪৪" },
        { id: 4, gender: "boy", letter: "আ", name: "আহমাদ", arabic: "أَحْمَد", english: "Ahmad", meaning: "সর্বাধিক প্রশংসাকারী। প্রিয়নবী (ﷺ)-এর পবিত্র আসমানী নাম।", tag: "prophet", ref: "সূরা আস-সফ: ৬" },
        { id: 5, gender: "boy", letter: "ই", name: "ইবরাহীম", arabic: "إِبْرَاهِيم", english: "Ibrahim", meaning: "জাতির পিতা, পরম দয়ালু পিতা। খলিলুল্লাহ হযরত ইবরাহীম (আ.)।", tag: "prophet", ref: "সূরা ইবরাহীম: ৩৫" },
        { id: 6, gender: "boy", letter: "ই", name: "ইউসুফ", arabic: "يُوسُف", english: "Yusuf", meaning: "সৌন্দর্যমণ্ডিত, আল্লাহ বৃদ্ধি করবেন। হযরত ইউসুফ (আ.)।", tag: "prophet", ref: "সূরা ইউসুফ: ৪" },
        { id: 7, gender: "boy", letter: "উ", name: "উমর", arabic: "عُمَر", english: "Umar", meaning: "দীর্ঘজীবী, আবাদকারী, সমৃদ্ধিশালী। ইসলামের দ্বিতীয় খলিফা হযরত উমর (রা.)।", tag: "sahabi", ref: "আমীরুল মু'মিনীন" },
        { id: 8, gender: "boy", letter: "আ", name: "আবু বকর", arabic: "أَبُو بَكْر", english: "Abu Bakr", meaning: "প্রভাতে আগমনকারী, প্রথম ইসলাম গ্রহণকারী। প্রথম খলিফা হযরত আবু বকর সিদ্দিক (রা.)।", tag: "sahabi", ref: "আশারায়ে মুবাশশারা" },
        { id: 9, gender: "boy", letter: "উ", name: "উসমান", arabic: "عُثْمَان", english: "Uthman", meaning: "দৃঢ়চেতা, প্রজ্ঞাবান, সাপের বাচ্চা। তৃতীয় খলিফা জুন-নুরাইন হযরত উসমান (রা.)।", tag: "sahabi", ref: "আশারায়ে মুবাশশারা" },
        { id: 10, gender: "boy", letter: "আ", name: "আলী", arabic: "عَلِيّ", english: "Ali", meaning: "উচ্চমর্যাদাসম্পন্ন, সমুন্নত, মহৎ। চতুর্থ খলিফা ও আসাদুল্লাহ হযরত আলী (রা.)।", tag: "sahabi", ref: "আশারায়ে মুবাশশারা" },
        { id: 11, gender: "boy", letter: "হ", name: "হাসান", arabic: "حَسَن", english: "Hasan", meaning: "সুন্দর, উত্তম, চরিত্রবান। রাসূল (ﷺ)-এর প্রিয় দৌহিত্র হযরত হাসান (রা.)।", tag: "sahabi", ref: "আহলে বাইত" },
        { id: 12, gender: "boy", letter: "হ", name: "হুসাইন", arabic: "حُسَيْن", english: "Husayn", meaning: "সুন্দরতম, লাবণ্যময়। কারবালার মহান শহীদ হযরত হুসাইন (রা.)।", tag: "sahabi", ref: "আহলে বাইত" },
        { id: 13, gender: "boy", letter: "হ", name: "হামযাহ", arabic: "حَمْزَة", english: "Hamzah", meaning: "সিংহ, সাহসী বীর। আল্লাহর সিংহ সাইয়্যিদুশ শুহাদা হযরত হামযাহ (রা.)।", tag: "sahabi", ref: "উহুদের শহীদ" },
        { id: 14, gender: "boy", letter: "ব", name: "বিলাল", arabic: "بِلَال", english: "Bilal", meaning: "তৃষ্ণা নিবারক, আর্দ্রতা, সজীবতা। ইসলামের প্রথম মুয়াযযিন হযরত বিলাল (রা.)।", tag: "sahabi", ref: "মুয়াযযিনুর রাসূল" },
        { id: 15, gender: "boy", letter: "খ", name: "খালিদ", arabic: "خَالِد", english: "Khalid", meaning: "চিরন্তন, অমর, দীর্ঘস্থায়ী। সাইফুল্লাহ হযরত খালিদ বিন ওয়ালিদ (রা.)।", tag: "sahabi", ref: "সাইফুল্লাহ (আল্লাহর তরবারি)" },
        { id: 16, gender: "boy", letter: "য", name: "যায়িদ", arabic: "زَيْد", english: "Zayd", meaning: "বৃদ্ধি, প্রাচুর্য, কল্যাণময়। কুরআনে নাম উল্লেখিত একমাত্র সাহাবী (রা.)।", tag: "sahabi", ref: "সূরা আল-আহযাব: ৩৭" },
        { id: 17, gender: "boy", letter: "ত", name: "তালহা", arabic: "طَلْحَة", english: "Talha", meaning: "জান্নাতের ফলবতী বৃক্ষ। জীবন্ত শহীদ হযরত তালহা বিন উবাইদুল্লাহ (রা.)।", tag: "sahabi", ref: "আশারায়ে মুবাশশারা" },
        { id: 18, gender: "boy", letter: "য", name: "যুবায়ের", arabic: "زُبَيْر", english: "Zubayr", meaning: "শক্তিশালী, নির্ভীক বীর। রাসূল (ﷺ)-এর হাওয়ারী হযরত যুবায়ের বিন আওয়াম (রা.)।", tag: "sahabi", ref: "আশারায়ে মুবাশশারা" },
        { id: 19, gender: "boy", letter: "স", name: "সা'দ", arabic: "سَعْد", english: "Sa'd", meaning: "সৌভাগ্যবান, আনন্দিত। বিখ্যাত সাহাবী হযরত সা'দ বিন আবি ওয়াক্কাস (রা.)।", tag: "sahabi", ref: "আশারায়ে মুবাশশারা" },
        { id: 20, gender: "boy", letter: "স", name: "সাঈদ", arabic: "سَعِيد", english: "Sa'eed", meaning: "সুখী, সৌভাগ্যবান, আনন্দচিত্ত। হযরত সাঈদ বিন যায়িদ (রা.)।", tag: "sahabi", ref: "আশারায়ে মুবাশশারা" },
        { id: 21, gender: "boy", letter: "স", name: "সালমান", arabic: "سَلْمَان", english: "Salman", meaning: "নিরাপদ, শান্তিকামী। প্রজ্ঞাবান সাহাবী হযরত সালমান ফারসী (রা.)।", tag: "sahabi", ref: "আসহাবে রাসুল" },
        { id: 22, gender: "boy", letter: "ম", name: "মুস'আব", arabic: "مُصْعَب", english: "Mus'ab", meaning: "দৃঢ়চেতা, আপসহীন। ইসলামের প্রথম দাঈ হযরত মুসআব বিন উমায়ের (রা.)।", tag: "sahabi", ref: "উহুদের শহীদ" },
        { id: 23, gender: "boy", letter: "আ", name: "আনাস", arabic: "أَنَس", english: "Anas", meaning: "ভালোবাসা, প্রীতি, অন্তরঙ্গ বন্ধু। রাসূল (ﷺ)-এর খাদেম হযরত আনাস (রা.)।", tag: "sahabi", ref: "আসহাবে রাসুল" },
        { id: 24, gender: "boy", letter: "ম", name: "মু'আয", arabic: "مُعَاذ", english: "Mu'adh", meaning: "আশ্রয়প্রাপ্ত, সংরক্ষিত। হালাল-হারামের সেরা জ্ঞানী হযরত মুয়ায বিন জাবাল (রা.)।", tag: "sahabi", ref: "আসহাবে রাসুল" },
        { id: 25, gender: "boy", letter: "ত", name: "তারিক", arabic: "طَارِق", english: "Tariq", meaning: "প্রভাতী নক্ষত্র, নিশাচর যাত্রী। স্পেন বিজয়ী সেনাপতি তারিক বিন যিয়াদ।", tag: "regular", ref: "সূরা আত-তারিক: ১" },
        { id: 26, gender: "boy", letter: "আ", name: "আইয়ুব", arabic: "أَيُّوب", english: "Ayyub", meaning: "ধৈর্যশীল, আল্লাহর দিকে প্রত্যাবর্তনকারী। হযরত আইয়ুব (আ.)।", tag: "prophet", ref: "সূরা আল-আম্বিয়া: ৮৩" },
        { id: 27, gender: "boy", letter: "ম", name: "মূসা", arabic: "مُوسَى", english: "Musa", meaning: "পানি থেকে উদ্ধারকৃত। কালিমুল্লাহ হযরত মূসা (আ.)।", tag: "prophet", ref: "আল-কুরআন" },
        { id: 28, gender: "boy", letter: "ঈ", name: "ঈসা", arabic: "عِيسَى", english: "Isa", meaning: "আল্লাহর সাহায্যপ্রাপ্ত। রুহুল্লাহ হযরত ঈসা (আ.)।", tag: "prophet", ref: "আল-কুরআন" },
        { id: 29, gender: "boy", letter: "ই", name: "ইদরীস", arabic: "إِدْرِيس", english: "Idris", meaning: "জ্ঞানপিপাসু, শিক্ষক, যিনি গভীর অধ্যয়ন করেন। হযরত ইদরীস (আ.)।", tag: "prophet", ref: "সূরা মারিয়াম: ৫৬" },
        { id: 30, gender: "boy", letter: "ই", name: "ইয়াহইয়া", arabic: "يَحْيَى", english: "Yahya", meaning: "চিরঞ্জীব, যে বেঁচে থাকে। হযরত ইয়াহইয়া (আ.)।", tag: "prophet", ref: "সূরা মারিয়াম: ৭" },
        { id: 31, gender: "boy", letter: "দ", name: "দাউদ", arabic: "دَاوُد", english: "Dawud", meaning: "প্রিয়তম বন্ধু। হযরত দাউদ (আ.)।", tag: "prophet", ref: "আল-কুরআন" },
        { id: 32, gender: "boy", letter: "স", name: "সুলাইমান", arabic: "سُلَيْمَان", english: "Sulayman", meaning: "শান্তির প্রতীক, নিরাপদ। হযরত সুলাইমান (আ.)।", tag: "prophet", ref: "আল-কুরআন" },
        { id: 33, gender: "boy", letter: "য", name: "যাকারিয়া", arabic: "زَكَرِيَّا", english: "Zakariyya", meaning: "আল্লাহকে সর্বদাই স্মরণকারী। হযরত যাকারিয়া (আ.)।", tag: "prophet", ref: "আল-কুরআন" },
        { id: 34, gender: "boy", letter: "ই", name: "ইসমাঈল", arabic: "إِسْمَاعِيل", english: "Isma'il", meaning: "আল্লাহ প্রার্থনা শুনেছেন। হযরত ইসমাঈল জবীহুল্লাহ (আ.)।", tag: "prophet", ref: "আল-কুরআন" },
        { id: 35, gender: "boy", letter: "ই", name: "ইসহাক", arabic: "إِسْحَاق", english: "Ishaq", meaning: "হাস্যোজ্জ্বল, আনন্দময়। হযরত ইসহাক (আ.)।", tag: "prophet", ref: "আল-কুরআন" },
        { id: 36, gender: "boy", letter: "ই", name: "ইয়াকুব", arabic: "يَعْقُوب", english: "Ya'qub", meaning: "অনুগামী, যিনি অনুসরণ করেন। হযরত ইয়াকুব (আ.)।", tag: "prophet", ref: "আল-কুরআন" },
        { id: 37, gender: "boy", letter: "ই", name: "ইউনূস", arabic: "يُونُس", english: "Yunus", meaning: "শান্তির পায়রা। জুন-নূন হযরত ইউনূস (আ.)।", tag: "prophet", ref: "সূরা ইউনূস" },
        { id: 38, gender: "boy", letter: "হ", name: "হারুন", arabic: "هَارُون", english: "Harun", meaning: "আলোকিত পর্বত, উচ্চমর্যাদাসম্পন্ন। হযরত হারুন (আ.)।", tag: "prophet", ref: "আল-কুরআন" },
        { id: 39, gender: "boy", letter: "স", name: "সালিহ", arabic: "صَالِح", english: "Salih", meaning: "সৎকর্মশীল, উপযুক্ত, ন্যায়পরায়ণ। হযরত সালিহ (আ.)।", tag: "prophet", ref: "আল-কুরআন" },
        { id: 40, gender: "boy", letter: "ন", name: "নূহ", arabic: "نُوح", english: "Nuh", meaning: "প্রশান্তি, স্বস্তি। আদি নবী হযরত নূহ (আ.)।", tag: "prophet", ref: "সূরা নূহ" },
        { id: 41, gender: "boy", letter: "আ", name: "আদম", arabic: "آدَم", english: "Adam", meaning: "মানবজাতির আদি পিতা, মাটির সৃষ্টি। হযরত আদম (আ.)।", tag: "prophet", ref: "আল-কুরআন" },
        { id: 42, gender: "boy", letter: "অ", name: "আব্দুল আযীয", arabic: "عَبْدُ الْعَزِيز", english: "Abdul Aziz", meaning: "পরাক্রমশালী ও পরাক্রমের মালিক আল্লাহর বান্দা।", tag: "beloved", ref: "আসমাউল হুসনা" },
        { id: 43, gender: "boy", letter: "অ", name: "আব্দুল মালিক", arabic: "عَبْدُ الْمَلِك", english: "Abdul Malik", meaning: "সার্বভৌম ক্ষমতার অধিকারী আল্লাহর বান্দা।", tag: "beloved", ref: "আসমাউল হুসনা" },
        { id: 44, gender: "boy", letter: "অ", name: "আব্দুল কারীম", arabic: "عَبْدُ الْكَرِيم", english: "Abdul Karim", meaning: "পরম দাতা ও মহাসম্মানি আল্লাহর বান্দা।", tag: "beloved", ref: "আসমাউল হুসনা" },
        { id: 45, gender: "boy", letter: "অ", name: "আব্দুল হামীদ", arabic: "عَبْدُ الْحَمِيد", english: "Abdul Hamid", meaning: "চির প্রশংসিত আল্লাহর বান্দা।", tag: "beloved", ref: "আসমাউল হুসনা" },
        { id: 46, gender: "boy", letter: "অ", name: "আব্দুল হাকিম", arabic: "عَبْدُ الْحَكِيم", english: "Abdul Hakim", meaning: "পরম প্রজ্ঞাবান মহাজ্ঞানী আল্লাহর বান্দা।", tag: "beloved", ref: "আসমাউল হুসনা" },
        { id: 47, gender: "boy", letter: "অ", name: "আব্দুল কুদ্দুস", arabic: "عَبْدُ الْقُدُّوس", english: "Abdul Quddus", meaning: "নিষ্কলঙ্ক ও পরম পবিত্র সত্তা আল্লাহর বান্দা।", tag: "beloved", ref: "আসমাউল হুসনা" },
        { id: 48, gender: "boy", letter: "স", name: "সাজিদ", arabic: "سَاجِد", english: "Sajid", meaning: "যে সিজদাহ করে, আল্লাহর প্রতি পূর্ণ বিনয়ী।", tag: "regular", ref: "আল-কুরআন" },
        { id: 49, gender: "boy", letter: "আ", name: "আবেদ", arabic: "عَابِد", english: "Abid", meaning: "একনিষ্ঠ ইবাদতকারী, আল্লাহর উপাসক।", tag: "regular", ref: "আল-কুরআন" },
        { id: 50, gender: "boy", letter: "শ", name: "শাকির", arabic: "شَاكِر", english: "Shakir", meaning: "কৃতজ্ঞচিত্ত, আল্লাহর নেয়ামতের শোকরগুজার।", tag: "regular", ref: "সূরা আল-ইনসান: ৩" },
        { id: 51, gender: "boy", letter: "ন", name: "নাঈম", arabic: "نَعِيم", english: "Na'im", meaning: "সুখ-স্বাচ্ছন্দ্য, জান্নাতী নিয়ামত ও শান্তি।", tag: "regular", ref: "সূরা আত-তাকাসুর: ৮" },
        { id: 52, gender: "boy", letter: "ফ", name: "ফাহিম", arabic: "فَهيم", english: "Fahim", meaning: "বুদ্ধিমান, বিচক্ষণ, যে গভীরভাবে উপলব্ধি করে।", tag: "regular", ref: "ইসলামিক ঐতিহ্য" },
        { id: 53, gender: "boy", letter: "ফ", name: "ফারহান", arabic: "فَرْحَان", english: "Farhan", meaning: "আনন্দিত, উৎফুল্ল, প্রফুল্লচিত্ত।", tag: "regular", ref: "আরবি শব্দকোষ" },
        { id: 54, gender: "boy", letter: "ও", name: "ওয়াসিম", arabic: "وَسِيم", english: "Wasim", meaning: "সুদর্শন, রূপবান, মার্জিত চেহারাযুক্ত।", tag: "regular", ref: "আরবি ঐতিহ্য" },
        { id: 55, gender: "boy", letter: "ত", name: "তাহমিদ", arabic: "تَحْمِيد", english: "Tahmid", meaning: "আলহামদুলিল্লাহ পাঠ, আল্লাহর প্রশংসা কীর্তন।", tag: "regular", ref: "হাদিস শরীফ" },
        { id: 56, gender: "boy", letter: "ত", name: "তাওহীদ", arabic: "تَوْحِيد", english: "Tawhid", meaning: "আল্লাহর একত্ববাদ ও নিরঙ্কুশ সার্বভৌমত্ব।", tag: "regular", ref: "ইসলামের মূল ভিত্তি" },
        { id: 57, gender: "boy", letter: "ত", name: "তানভীর", arabic: "تَنْوِير", english: "Tanvir", meaning: "আলোকোজ্জ্বল, আলোকময়, আলোকিতকরণ।", tag: "regular", ref: "আরবি সাহিত্য" },
        { id: 58, gender: "boy", letter: "র", name: "রায়হান", arabic: "رَيْحَان", english: "Rayhan", meaning: "জান্নাতী সুগন্ধি ফুল, আল্লাহর পবিত্র অনুগ্রহ।", tag: "regular", ref: "সূরা আর-রহমান: ১২" },
        { id: 59, gender: "boy", letter: "র", name: "রিদওয়ান", arabic: "رِضْوَان", english: "Ridwan", meaning: "আল্লাহর সন্তুষ্টি, জান্নাতের প্রধান প্রহরী ফেরেশতা।", tag: "regular", ref: "সূরা আত-তাওবাহ: ২১" },
        { id: 60, gender: "boy", letter: "র", name: "রাশাদ", arabic: "رَشَاد", english: "Rashad", meaning: "সুপথপ্রাপ্তি, ন্যায়নিষ্ঠা, সঠিক দিকনির্দেশনা।", tag: "regular", ref: "সূরা আল-বাকারা: ২৫৬" },
        { id: 61, gender: "boy", letter: "জ", name: "জাওয়াদ", arabic: "جَوَاد", english: "Jawad", meaning: "অত্যন্ত দানশীল, উদারহৃদয়, মহানুভব।", tag: "regular", ref: "হাদিস শরীফ" },
        { id: 62, gender: "boy", letter: "জ", name: "জুনায়েদ", arabic: "جُنَيْد", english: "Junayd", meaning: "ক্ষুদ্র সৈন্যদল, বিখ্যাত আধ্যাত্মিক সাধক।", tag: "regular", ref: "ইসলামিক মনীষী" },
        { id: 63, gender: "boy", letter: "র", name: "রাফী", arabic: "رَفِيع", english: "Rafi", meaning: "উচ্চপদস্থ, সমুন্নত, মহীয়ান।", tag: "regular", ref: "সূরা গাফির: ১৫" },
        { id: 64, gender: "boy", letter: "ম", name: "মাহমুদ", arabic: "مَحْمُود", english: "Mahmud", meaning: "প্রশংসিত সত্তা, মাকামে মাহমুদের অধিকারী।", tag: "prophet", ref: "সূরা বনি ইসরাঈল: ৭৯" },
        { id: 65, gender: "boy", letter: "ত", name: "ত্বহা", arabic: "طه", english: "Taha", meaning: "পবিত্র কুরআনের এক রহস্যময় হরফে মুকাত্তা'আত, প্রিয়নবীর উপনাম।", tag: "prophet", ref: "সূরা ত্বহা: ১" },

        // --- GIRLS ---
        { id: 66, gender: "girl", letter: "ম", name: "মারিয়াম", arabic: "مَرْيَم", english: "Maryam", meaning: "আল্লাহর একনিষ্ঠ উপাসিকা, পবিত্রা সাধ্বী। হযরত ঈসা (আ.)-এর মহীয়সী মাতা।", tag: "prophet", ref: "সূরা মারিয়াম" },
        { id: 67, gender: "girl", letter: "ফ", name: "ফাতিমা", arabic: "فَاطِمَة", english: "Fatimah", meaning: "নিষ্পাপ, আগুন থেকে মুক্তকারিনী। জান্নাতী নারীদের নেত্রী, প্রিয়নবীর আদরের কন্যা।", tag: "sahabiyyah", ref: "সাইয়্যিদাতুন নিসা" },
        { id: 68, gender: "girl", letter: "খ", name: "খাদিজাহ", arabic: "خَدِيجَة", english: "Khadijah", meaning: "সময়ের অগ্রে জন্মলাভকারী, মহিয়সী পুণ্যবতী। ইসলামের প্রথম মুসলিম নারী।", tag: "sahabiyyah", ref: "উম্মুল মু'মিনীন" },
        { id: 69, gender: "girl", letter: "আ", name: "আয়েশা", arabic: "عَائِشَة", english: "Aishah", meaning: "প্রাণবন্ত, আনন্দময়ী, সুখী জীবনযাপনকারিণী। প্রখ্যাত ফকীহ উম্মুল মু'মিনীন।", tag: "sahabiyyah", ref: "উম্মুল মু'মিনীন" },
        { id: 70, gender: "girl", letter: "হ", name: "হাফসাহ", arabic: "حَفْصَة", english: "Hafsah", meaning: "সিংহশাবক, নির্ভীক। হযরত উমর (রা.)-এর কন্যা ও উম্মুল মু'মিনীন।", tag: "sahabiyyah", ref: "উম্মুল মু'মিনীন" },
        { id: 71, gender: "girl", letter: "য", name: "যয়নাব", arabic: "زَيْنَب", english: "Zaynab", meaning: "পিতার সৌন্দর্য, সুরভিত সুদৃশ্য পুষ্পবৃক্ষ। রাসূল (ﷺ)-এর জ্যেষ্ঠা কন্যা।", tag: "sahabiyyah", ref: "আহলে বাইত" },
        { id: 72, gender: "girl", letter: "র", name: "রুকাইয়াহ", arabic: "رُقَيَّة", english: "Ruqayyah", meaning: "কোমলমতি, উন্নতিশীলা, রূপসী। রাসূল (ﷺ)-এর কন্যা ও উসমান (রা.)-এর স্ত্রী।", tag: "sahabiyyah", ref: "আহলে বাইত" },
        { id: 73, gender: "girl", letter: "উ", name: "উম্মে কুলসুম", arabic: "أُمّ كُلْثُوم", english: "Umm Kulthum", meaning: "সুন্দর লাবণ্যময় মুখমণ্ডলবিশিষ্টা। রাসূলুল্লাহ (ﷺ)-এর কন্যা।", tag: "sahabiyyah", ref: "আহলে বাইত" },
        { id: 74, gender: "girl", letter: "আ", name: "আসমা", arabic: "أَسْمَاء", english: "Asma", meaning: "উচ্চমর্যাদাসম্পন্ন, সমুন্নত। আবু বকর (রা.)-এর কন্যা ও জাতুন নিতাকাইন।", tag: "sahabiyyah", ref: "সাহাবীয়া" },
        { id: 75, gender: "girl", letter: "স", name: "সুমাইয়্যাহ", arabic: "سُمَيَّة", english: "Sumayyah", meaning: "সমুন্নত, উচ্চমর্যাদা। ইসলামের ইতিহাসের প্রথম পুণ্যবতী শহীদ নারী।", tag: "sahabiyyah", ref: "প্রথম শহীদ নারী" },
        { id: 76, gender: "girl", letter: "স", name: "সাফিয়্যাহ", arabic: "صَفِيَّة", english: "Safiyyah", meaning: "নিষ্কলঙ্ক, খাঁটি বন্ধু, পরিচ্ছন্ন অন্তরের অধিকারিণী। উম্মুল মু'মিনীন।", tag: "sahabiyyah", ref: "উম্মুল মু'মিনীন" },
        { id: 77, gender: "girl", letter: "স", name: "সাওদাহ", arabic: "سَوْدَة", english: "Sawdah", meaning: "খেজুরবন, উদার ও দানশীল। উম্মুল মু'মিনীন হযরত সাওদাহ (রা.)।", tag: "sahabiyyah", ref: "উম্মুল মু'মিনীন" },
        { id: 78, gender: "girl", letter: "জ", name: "জুওয়াইরিয়াহ", arabic: "جُوَيْرِيَة", english: "Juwayriyah", meaning: "গোলাপের কুঁড়ি, তরুণী। উম্মুল মু'মিনীন হযরত জুওয়াইরিয়া (রা.)।", tag: "sahabiyyah", ref: "উম্মুল মু'মিনীন" },
        { id: 79, gender: "girl", letter: "ম", name: "মাইমূনাহ", arabic: "مَيْمُونَة", english: "Maymunah", meaning: "বরকতময়ী, পরম সৌভাগ্যবতী। উম্মুল মু'মিনীন হযরত মাইমুনা (রা.)।", tag: "sahabiyyah", ref: "উম্মুল মু'মিনীন" },
        { id: 80, gender: "girl", letter: "উ", name: "উম্মে সালামাহ", arabic: "أُمّ سَلَمَة", english: "Umm Salamah", meaning: "শান্তির মাতা, প্রজ্ঞাময়ী নারী। উম্মুল মু'মিনীন হিন্দ বিনতে আবি উমাইয়াহ।", tag: "sahabiyyah", ref: "উম্মুল মু'মিনীন" },
        { id: 81, gender: "girl", letter: "স", name: "সারা", arabic: "سَارَة", english: "Sarah", meaning: "আনন্দদায়িনী, রাজকুমারী। হযরত ইবরাহীম (আ.)-এর স্ত্রী ও ইসহাক (আ.)-এর মাতা।", tag: "prophet", ref: "কুরআনিক ঐতিহ্য" },
        { id: 82, gender: "girl", letter: "হ", name: "হাজেরা", arabic: "هَاجَر", english: "Hajar", meaning: "উত্তম ও সুন্দরী, আল্লাহর তরে হিজরতকারিণী। ইসমাঈল (আ.)-এর মাতা।", tag: "prophet", ref: "জমজম ঐতিহ্য" },
        { id: 83, gender: "girl", letter: "আ", name: "আসিয়া", arabic: "آسِيَة", english: "Asiyah", meaning: "দুঃখ মোচনকারী, সান্ত্বনাদাত্রী। মুসা (আ.)-এর রক্ষাকর্ত্রী মহীয়সী জান্নাতী নারী।", tag: "prophet", ref: "সূরা আত-তাহরীম: ১১" },
        { id: 84, gender: "girl", letter: "আ", name: "আমিনা", arabic: "آمِنَة", english: "Aminah", meaning: "বিশ্বস্ত, শান্তিময়ী, নিরাপদ। রাসূলুল্লাহ (ﷺ)-এর মহীয়সী মাতা।", tag: "sahabiyyah", ref: "সীরাত ঐতিহ্য" },
        { id: 85, gender: "girl", letter: "হ", name: "হালিমা", arabic: "حَلِيمَة", english: "Halimah", meaning: "ধৈর্যশীলা, সহনশীল, কোমলমতি। রাসূলুল্লাহ (ﷺ)-এর স্নেহময়ী দুধমাতা।", tag: "sahabiyyah", ref: "সীরাত ঐতিহ্য" },
        { id: 86, gender: "girl", letter: "ন", name: "নুসাইবাহ", arabic: "نُسَيْبَة", english: "Nusaybah", meaning: "কুলীন, মহৎ বংশীয়। উহুদের বীর যোদ্ধা নারী উম্মে আম্মারা (রা.)।", tag: "sahabiyyah", ref: "উহুদের বীর নারী" },
        { id: 87, gender: "girl", letter: "শ", name: "শিফা", arabic: "شِفَاء", english: "Shifa", meaning: "রোগমুক্তি, নিরাময়, আরোগ্য। প্রখ্যাত নারী সাহাবী ও চিকিৎসক।", tag: "sahabiyyah", ref: "সাহাবীয়া" },
        { id: 88, gender: "girl", letter: "খ", name: "খাওলাহ", arabic: "خَوْلَة", english: "Khawlah", meaning: "হরিণী শাবক, রূপসী ও সাহসী। যাঁর সমর্থনে সূরা মুজাদালাহ অবতীর্ণ হয়।", tag: "sahabiyyah", ref: "সূরা আল-মুজাদালাহ" },
        { id: 89, gender: "girl", letter: "ত", name: "তাসনীম", arabic: "تَسْنِيم", english: "Tasnim", meaning: "জান্নাতের সর্বোচ্চ ও পবিত্রতম সুশীতল সুগন্ধিময় ঝর্ণাধারা।", tag: "regular", ref: "সূরা আল-মুতাফফিফীন: ২৭" },
        { id: 90, gender: "girl", letter: "স", name: "সালসাবীল", arabic: "سَلْسَبِيل", english: "Salsabil", meaning: "জান্নাতের সুমিষ্ট সুপেয় পানির মনোরম প্রস্রবণ।", tag: "regular", ref: "সূরা আল-ইনসান: ১৮" },
        { id: 91, gender: "girl", letter: "ক", name: "কাউসার", arabic: "كَوْثَر", english: "Kawthar", meaning: "অফুরন্ত কল্যাণ ও নিয়ামত, প্রিয়নবীকে প্রদত্ত জান্নাতী নহর।", tag: "regular", ref: "সূরা আল-কাউসার: ১" },
        { id: 92, gender: "girl", letter: "আ", name: "আফিফাহ", arabic: "عَفِيفَة", english: "Afifah", meaning: "সতী-সাধ্বী, পবিত্রা, নিষ্কলঙ্ক চরিত্রের অধিকারিণী।", tag: "regular", ref: "আরবি শব্দকোষ" },
        { id: 93, gender: "girl", letter: "স", name: "সালিহাহ", arabic: "صَالِحَة", english: "Salihah", meaning: "নেককার, সৎকর্মশীল, ধর্মপরায়ণা ধার্মিক নারী।", tag: "regular", ref: "সূরা আন-নিসা: ৩৪" },
        { id: 94, gender: "girl", letter: "স", name: "সামিহা", arabic: "سَمِيحَة", english: "Samihah", meaning: "উদারমনা, দানশীলা, ক্ষমাশীল অন্তরের অধিকারী।", tag: "regular", ref: "আরবি শব্দকোষ" },
        { id: 95, gender: "girl", letter: "ল", name: "লায়লা", arabic: "لَيْلَى", english: "Layla", meaning: "শ্যামলা রূপসী, রজনীর মাদকতাময় স্নিগ্ধ সৌন্দর্য।", tag: "regular", ref: "আরবি সাহিত্য" },
        { id: 96, gender: "girl", letter: "ল", name: "লুবাবা", arabic: "لُبَابَة", english: "Lubabah", meaning: "খাঁটি নির্যাস, সারবস্তু। সাহাবীয়া উম্মুল ফাদল লুবাবা (রা.)।", tag: "sahabiyyah", ref: "সাহাবীয়া" },
        { id: 97, gender: "girl", letter: "ম", name: "মালিহা", arabic: "مَلِيحَة", english: "Maliha", meaning: "লাবণ্যময়ী, মিষ্টি চেহারার অধিকারিণী, সুন্দরী।", tag: "regular", ref: "আরবি শব্দকোষ" },
        { id: 98, gender: "girl", letter: "ম", name: "মুনীরাহ", arabic: "مُنِيرَة", english: "Munirah", meaning: "আলোকোজ্জ্বল, জ্যোতির্ময়ী, প্রদীপ্ত নারী।", tag: "regular", ref: "সূরা আল-আহযাব: ৪৬" },
        { id: 99, gender: "girl", letter: "ন", name: "নাবীলাহ", arabic: "نَبِيلَة", english: "Nabilah", meaning: "মহতী, ভদ্র, আভিজাত্যপূর্ণ ও প্রশংসনীয়।", tag: "regular", ref: "আরবি ঐতিহ্য" },
        { id: 100, gender: "girl", letter: "ন", name: "নাদিয়া", arabic: "نَادِيَة", english: "Nadia", meaning: "সুবক্তা, যে আহ্বান করে, প্রাতঃকালের স্নিগ্ধ শিশির।", tag: "regular", ref: "আরবি শব্দকোষ" },
        { id: 101, gender: "girl", letter: "ন", name: "নাজিফাহ", arabic: "نَظِيفَة", english: "Nazifah", meaning: "পবিত্র, শুচিশুভ্র, পরিষ্কার-পরিচ্ছন্ন।", tag: "regular", ref: "আরবি ঐতিহ্য" },
        { id: 102, gender: "girl", letter: "র", name: "রাফিয়াহ", arabic: "رَفِيعَة", english: "Rafiah", meaning: "উচ্চ মর্যাদাসম্পন্ন, মহিমান্বিত নারী।", tag: "regular", ref: "সূরা আল-ওয়াকিয়াহ: ৩" },
        { id: 103, gender: "girl", letter: "র", name: "রাহমাহ", arabic: "رَحْمَة", english: "Rahmah", meaning: "আল্লাহর অপার রহমত, দয়া ও পরম করুণা।", tag: "regular", ref: "আল-কুরআন" },
        { id: 104, gender: "girl", letter: "র", name: "রায়হানা", arabic: "رَيْحَانَة", english: "Rayhanah", meaning: "সুগন্ধি ফুল, গোলাপ। উম্মুল মু'মিনীন হযরত রায়হানা (রা.)।", tag: "sahabiyyah", ref: "উম্মুল মু'মিনীন" },
        { id: 105, gender: "girl", letter: "স", name: "সাদিয়া", arabic: "سَعْدِيَّة", english: "Sadiyah", meaning: "সৌভাগ্যবতী, বরকতময়ী, প্রফুল্লচিত্ত নারী।", tag: "regular", ref: "সীরাত ঐতিহ্য" },
        { id: 106, gender: "girl", letter: "স", name: "সাকীনাহ", arabic: "سَكِينَة", english: "Sakinah", meaning: "অন্তরের গভীর প্রশান্তি, নির্ভরতা ও ঈমানী শান্তি।", tag: "regular", ref: "সূরা আল-ফাতহ: ৪" },
        { id: 107, gender: "girl", letter: "স", name: "সামিরা", arabic: "سَمِيرَة", english: "Samirah", meaning: "প্রীতিময়ী সঙ্গী, মধুর সান্ধ্যকালীন আলাপচারিণী।", tag: "regular", ref: "আরবি সাহিত্য" },
        { id: 108, gender: "girl", letter: "ত", name: "ত্বায়্যিবাহ", arabic: "طَيِّبَة", english: "Tayyibah", meaning: "পবিত্রা, নির্মল, উত্তম চরিত্রের অধিকারী।", tag: "regular", ref: "সূরা আল-বাকারা: ২৬৭" },
        { id: 109, gender: "girl", letter: "ও", name: "ওয়াজিহা", arabic: "وَجِيهَة", english: "Wajihah", meaning: "সম্মানিতা, ব্যক্তিত্বসম্পন্ন, রূপবতী ও মর্যাদাবান।", tag: "regular", ref: "সূরা আল-ইমরান: ৪৫" },
        { id: 110, gender: "girl", letter: "ও", name: "ওয়ার্দাহ", arabic: "وَرْدَة", english: "Wardah", meaning: "লাল গোলাপ, রূপবতী সুগন্ধি ফুল।", tag: "regular", ref: "সূরা আর-রহমান: ৩৭" },
        { id: 111, gender: "girl", letter: "য", name: "যাকিয়্যাহ", arabic: "زَكِيَّة", english: "Zakiyyah", meaning: "পবিত্রা, নিষ্পাপ, আত্মশুদ্ধি লাভকারিণী।", tag: "regular", ref: "সূরা মারিয়াম: ১৯" },
        { id: 112, gender: "girl", letter: "য", name: "যান্নাত", arabic: "جَنَّة", english: "Jannat", meaning: "মনোরম জান্নাত, চিরসুখের স্বর্গীয় উদ্যান।", tag: "regular", ref: "আল-কুরআন" },
        { id: 113, gender: "girl", letter: "আ", name: "আনীকা", arabic: "أَنِيقَة", english: "Anika", meaning: "মার্জিত, সুশ্রী, লাবণ্যময়ী ও রুচিশীল।", tag: "regular", ref: "আরবি শব্দকোষ" },
        { id: 114, gender: "girl", letter: "আ", name: "ইনায়া", arabic: "عِنَايَة", english: "Inayah", meaning: "আল্লাহর বিশেষ সুরক্ষা, যত্ন ও অসীম অনুগ্রহ।", tag: "regular", ref: "আরবি ঐতিহ্য" },
        { id: 115, gender: "girl", letter: "ব", name: "বুশরা", arabic: "بُشْرَى", english: "Bushra", meaning: "শুভসংবাদ, পরম আনন্দের সুসংবাদ।", tag: "regular", ref: "সূরা ইউসুফ: ১৯" }
    ]
};
