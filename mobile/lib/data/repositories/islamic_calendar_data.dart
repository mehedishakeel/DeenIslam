import '../../core/utils/bengali_numerals.dart';

class IslamicMonthInfo {
  final int number;
  final String nameBn;
  final String nameAr;
  final String nameEn;
  final bool isSacred;
  final String meaning;
  final String significance;

  const IslamicMonthInfo({
    required this.number,
    required this.nameBn,
    required this.nameAr,
    required this.nameEn,
    required this.isSacred,
    required this.meaning,
    required this.significance,
  });
}

class IslamicAnnualEvent {
  final String id;
  final int month;
  final int day;
  final String titleBn;
  final String titleEn;
  final String category;
  final String badge;
  final String icon;
  final String description;

  const IslamicAnnualEvent({
    required this.id,
    required this.month,
    required this.day,
    required this.titleBn,
    required this.titleEn,
    required this.category,
    required this.badge,
    required this.icon,
    required this.description,
  });
}

class HijriDateInfo {
  final int day;
  final int month;
  final int year;
  final String dayBn;
  final String yearBn;
  final String monthNameBn;
  final String monthNameAr;
  final String monthNameEn;
  final bool isSacredMonth;
  final bool isWhiteDay;
  final bool isProhibitedFasting;
  final bool isFriday;
  final bool isMonday;
  final bool isThursday;
  final List<IslamicAnnualEvent> events;
  final DateTime gregorianDate;
  final String formattedBn;

  const HijriDateInfo({
    required this.day,
    required this.month,
    required this.year,
    required this.dayBn,
    required this.yearBn,
    required this.monthNameBn,
    required this.monthNameAr,
    required this.monthNameEn,
    required this.isSacredMonth,
    required this.isWhiteDay,
    required this.isProhibitedFasting,
    required this.isFriday,
    required this.isMonday,
    required this.isThursday,
    required this.events,
    required this.gregorianDate,
    required this.formattedBn,
  });
}

class UpcomingIslamicEvent {
  final IslamicAnnualEvent event;
  final int hijriYear;
  final DateTime targetGregorianDate;
  final int daysRemaining;
  final bool isToday;

  const UpcomingIslamicEvent({
    required this.event,
    required this.hijriYear,
    required this.targetGregorianDate,
    required this.daysRemaining,
    required this.isToday,
  });
}

class CalendarDayEntry {
  final int hijriDay;
  final String hijriDayBn;
  final int hijriMonth;
  final int hijriYear;
  final DateTime gregorianDate;
  final int gregorianDay;
  final int gregorianMonth;
  final int gregorianWeekday; // 1=Mon .. 5=Fri .. 7=Sun (DateTime.weekday)
  final bool isWhiteDay;
  final bool isProhibitedFasting;
  final bool isFriday;
  final List<IslamicAnnualEvent> events;

  const CalendarDayEntry({
    required this.hijriDay,
    required this.hijriDayBn,
    required this.hijriMonth,
    required this.hijriYear,
    required this.gregorianDate,
    required this.gregorianDay,
    required this.gregorianMonth,
    required this.gregorianWeekday,
    required this.isWhiteDay,
    required this.isProhibitedFasting,
    required this.isFriday,
    required this.events,
  });
}

class HijriMonthCalendar {
  final int year;
  final int month;
  final IslamicMonthInfo monthInfo;
  final int totalDays;
  final List<CalendarDayEntry> days;

  const HijriMonthCalendar({
    required this.year,
    required this.month,
    required this.monthInfo,
    required this.totalDays,
    required this.days,
  });
}

class IslamicCalendarData {
  static const List<IslamicMonthInfo> months = [
    IslamicMonthInfo(
      number: 1,
      nameBn: "মুহাররম",
      nameAr: "المُحَرَّم",
      nameEn: "Muharram",
      isSacred: true,
      meaning: "পবিত্র ও নিষিদ্ধ মাস",
      significance: "হিজরি সনের প্রথম মাস। চার সম্মানিত মাসের অন্যতম। পবিত্র আশুরা (১০ মুহাররম) ও কারবালার ঐতিহাসিক ঘটনার মাস।",
    ),
    IslamicMonthInfo(
      number: 2,
      nameBn: "সফর",
      nameAr: "صَفَر",
      nameEn: "Safar",
      isSacred: false,
      meaning: "শূন্যতা / গৃহত্যাগ",
      significance: "ইসলামে কোনো মাস বা দিনকে অশুভ মনে করা নিষিদ্ধ। কুসংস্কারমুক্ত ঈমানী জিন্দেগির শিক্ষা দেয় এই মাস।",
    ),
    IslamicMonthInfo(
      number: 3,
      nameBn: "রবিউল আউয়াল",
      nameAr: "رَبِيع الأَوَّل",
      nameEn: "Rabi' al-Awwal",
      isSacred: false,
      meaning: "প্রথম বসন্ত",
      significance: "সাইয়্যিদুল মুরসালীন হযরত মুহাম্মদ (ﷺ)-এর শুভাগমন, ঐতিহাসিক হিজরত এবং ওফাতের বরকতময় মাস।",
    ),
    IslamicMonthInfo(
      number: 4,
      nameBn: "রবিউস সানি",
      nameAr: "رَبِيع الآخِر",
      nameEn: "Rabi' al-Thani",
      isSacred: false,
      meaning: "দ্বিতীয় বসন্ত",
      significance: "ঈমান বৃদ্ধি, জ্ঞানার্জন এবং আত্মশুদ্ধির অনুশীলনের মাস।",
    ),
    IslamicMonthInfo(
      number: 5,
      nameBn: "জমাদিউল আউয়াল",
      nameAr: "جُمَادَى الأُولَى",
      nameEn: "Jumada al-Awwal",
      isSacred: false,
      meaning: "প্রথম হিম / শীত",
      significance: "ঐতিহাসিক মুতার যুদ্ধ এবং ইসলামের বিস্তার সংক্রান্ত বহু গুরুত্বপূর্ণ ঘটনার সাক্ষী।",
    ),
    IslamicMonthInfo(
      number: 6,
      nameBn: "জমাদিউস সানি",
      nameAr: "جُمَادَى الآخِرَة",
      nameEn: "Jumada al-Thani",
      isSacred: false,
      meaning: "দ্বিতীয় হিম / শীত",
      significance: "ইসলামের প্রথম খলিফা হযরত আবু বকর সিদ্দিক (রা.)-এর ওফাত ও ইয়ারমুকের যুদ্ধ।",
    ),
    IslamicMonthInfo(
      number: 7,
      nameBn: "রজব",
      nameAr: "رَجَب",
      nameEn: "Rajab",
      isSacred: true,
      meaning: "মর্যাদাপূর্ণ / সম্মানিত",
      significance: "চার সম্মানিত মাসের একটি। পবিত্র শবে মেরাজ এবং আসন্ন মাহে রমজানের ইবাদতের পূর্বপ্রস্তুতির শুভ সূচনা।",
    ),
    IslamicMonthInfo(
      number: 8,
      nameBn: "শাবান",
      nameAr: "شَعْبَان",
      nameEn: "Sha'ban",
      isSacred: false,
      meaning: "শাখা-প্রশাখা বিস্তার",
      significance: "নবীজী (ﷺ) এ মাসে সর্বাধিক নফল রোজা রাখতেন। শবে বরাত (লাইলাতুন নিসফি মিন শাবান) ও রমজানের চূড়ান্ত প্রস্তুতি।",
    ),
    IslamicMonthInfo(
      number: 9,
      nameBn: "রমজান",
      nameAr: "رَمَضَان",
      nameEn: "Ramadan",
      isSacred: false,
      meaning: "দহন / আত্মশুদ্ধি",
      significance: "কুরআন অবতীর্ণ হওয়ার শ্রেষ্ঠ মাস। এক মাসব্যাপী ফরজ রোজা, তারাবিহ, ইতিকাফ এবং হাজার মাসের চেয়ে উত্তম 'লাইলাতুল কদর'।",
    ),
    IslamicMonthInfo(
      number: 10,
      nameBn: "শাওয়াল",
      nameAr: "شَوَّال",
      nameEn: "Shawwal",
      isSacred: false,
      meaning: "উত্তোলন / সমৃদ্ধি",
      significance: "১লা শাওয়াল আনন্দ ও কৃতজ্ঞতার 'পবিত্র ঈদুল ফিতর'। পুরো বছর রোজা রাখার সমতুল্য সওয়াবের ৬টি সুন্নাত রোজা।",
    ),
    IslamicMonthInfo(
      number: 11,
      nameBn: "জিলকদ",
      nameAr: "ذُو القَعْدَة",
      nameEn: "Dhu al-Qi'dah",
      isSacred: true,
      meaning: "বিশ্রামের মাস (যুদ্ধবিরতি)",
      significance: "চার সম্মানিত মাসের অন্যতম এবং হজের মাসসমূহের প্রথম। বায়তুল্লাহর উদ্দেশ্যে হজযাত্রীদের যাত্রা শুরু হয়।",
    ),
    IslamicMonthInfo(
      number: 12,
      nameBn: "জিলহজ",
      nameAr: "ذُو الحِجَّة",
      nameEn: "Dhu al-Hijjah",
      isSacred: true,
      meaning: "পবিত্র হজের মাস",
      significance: "ইসলামের পঞ্চম স্তম্ভ পবিত্র হজ, আরাফার দিনের শ্রেষ্ঠ রোজা, ঈদুল আজহা (কোরবানি) ও তাশরিকের তাকবির।",
    ),
  ];

  static const List<IslamicAnnualEvent> events = [
    IslamicAnnualEvent(
      id: "hijri_new_year",
      month: 1,
      day: 1,
      titleBn: "পবিত্র হিজরি নববর্ষ",
      titleEn: "Islamic New Year (1st Muharram)",
      category: "নববর্ষ",
      badge: "🎉 নতুন হিজরি বছর",
      icon: "🌙",
      description: "নতুন হিজরি সনের প্রথম দিন। রাসূলুল্লাহ (ﷺ)-এর মদিনায় হিজরতের ঐতিহাসিক স্মৃতিবিজড়িত বর্ষগণনা।",
    ),
    IslamicAnnualEvent(
      id: "ashura_tasua",
      month: 1,
      day: 9,
      titleBn: "পবিত্র তাসুআ (আশুরার পূর্বের রোজা)",
      titleEn: "Tasu'a (9th Muharram)",
      category: "রোজা",
      badge: "🤲 মুস্তাহাব রোজা",
      icon: "✨",
      description: "রাসূলুল্লাহ (ﷺ) আশুরার সাথে মিলিয়ে ৯ ও ১০ অথবা ১০ ও ১১ মুহাররম রোজা রাখতে নির্দেশ দিয়েছেন।",
    ),
    IslamicAnnualEvent(
      id: "ashura",
      month: 1,
      day: 10,
      titleBn: "পবিত্র আশুরা",
      titleEn: "Day of Ashura (10th Muharram)",
      category: "ঐতিহাসিক ও রোজা",
      badge: "⭐ বিগত ১ বছরের পাপ মোচনকারী রোজা",
      icon: "🌟",
      description: "মুসা (আ.) ও বনী ইসরাঈলকে ফেরাউনের কবল থেকে মুক্তির দিন এবং কারবালার মর্মান্তিক শাহাদাতের স্মরণীয় দিন।",
    ),
    IslamicAnnualEvent(
      id: "seerah_un_nabi",
      month: 3,
      day: 12,
      titleBn: "সিরাতুন্নবী (ﷺ) / রাসূল (ﷺ)-এর শুভাগমন ও ওফাত",
      titleEn: "Milad un Nabi / Seerah (12th Rabi' al-Awwal)",
      category: "ঐতিহাসিক",
      badge: "📖 সিরাত চর্চা",
      icon: "🌸",
      description: "বিশ্বনবী হযরত মুহাম্মদ (ﷺ)-এর বরকতময় জীবন ও সিরাত অধ্যয়নের অনুপ্রেরণার দিন।",
    ),
    IslamicAnnualEvent(
      id: "shab_e_miraj",
      month: 7,
      day: 27,
      titleBn: "পবিত্র শবে মেরাজ (লাইলাতুল মেরাজ)",
      titleEn: "Shab-e-Miraj (27th Rajab)",
      category: "ঐতিহাসিক ও ইবাদত",
      badge: "🌌 উর্ধ্বাকাশ ভ্রমণ ও ৫ ওয়াক্ত সালাত",
      icon: "🚀",
      description: "রাসূলুল্লাহ (ﷺ)-এর মসজিদুল হারাম থেকে মসজিদুল আকসা ও সপ্তাকাশ ভ্রমণ করে পাঁচ ওয়াক্ত সালাতের উপহার প্রাপ্তি।",
    ),
    IslamicAnnualEvent(
      id: "shab_e_barat",
      month: 8,
      day: 15,
      titleBn: "পবিত্র শবে বরাত (লাইলাতুন নিসফি মিন শাবান)",
      titleEn: "Shab-e-Barat (15th Sha'ban)",
      category: "ইবাদত ও ক্ষমা",
      badge: "🤲 মাগফিরাত ও ক্ষমা",
      icon: "💫",
      description: "শাবান মাসের মধ্যবর্তী রজনী। আল্লাহর রহমত ও বান্দার পাপ মার্জনার বিশেষ রজনী।",
    ),
    IslamicAnnualEvent(
      id: "ramadan_start",
      month: 9,
      day: 1,
      titleBn: "পবিত্র মাহে রমজান শুরু (১ম রোজা)",
      titleEn: "First Day of Ramadan",
      category: "ফরজ ইবাদত",
      badge: "🌙 মাহে রমজান মোবারক",
      icon: "🕌",
      description: "রহমত, মাগফিরাত ও নাজাতের পবিত্র মাস। সুবহে সাদেক থেকে সূর্যাস্ত পর্যন্ত এক মাসব্যাপী ফরজ রোজা পালন শুরু।",
    ),
    IslamicAnnualEvent(
      id: "badr_day",
      month: 9,
      day: 17,
      titleBn: "ঐতিহাসিক বদর দিবস (১৭ রমজান)",
      titleEn: "Battle of Badr (17th Ramadan)",
      category: "ঐতিহাসিক",
      badge: "⚔️ হক ও বাতিলের চূড়ান্ত ফয়সালা",
      icon: "🛡️",
      description: "ইসলামের প্রথম প্রকাশ্য যুদ্ধ। ৩১৩ জন নিঃস্ব সাহাবীর মোকাবেলায় আল্লাহর পক্ষ থেকে ফেরেশতাদের মাধ্যমে বিজয় দান।",
    ),
    IslamicAnnualEvent(
      id: "mecca_conquest",
      month: 9,
      day: 20,
      titleBn: "ঐতিহাসিক মক্কা বিজয় (২০ রমজান)",
      titleEn: "Conquest of Mecca (20th Ramadan)",
      category: "ঐতিহাসিক",
      badge: "🕋 তাওহীদের বিজয় ও ক্ষমার পরাকাষ্ঠা",
      icon: "🚩",
      description: "রক্তপাতহীন মক্কা বিজয় এবং কা'বা ঘরকে ৩৬০টি মূর্তির অপবিত্রতা থেকে মুক্ত করে তাওহীদের পুনঃপ্রতিষ্ঠা।",
    ),
    IslamicAnnualEvent(
      id: "laylatul_qadr_27",
      month: 9,
      day: 27,
      titleBn: "পবিত্র শবে কদর (লাইলাতুল কদর - সম্ভাব্য প্রধান রাত)",
      titleEn: "Laylatul Qadr (27th Ramadan)",
      category: "শ্রেষ্ঠ রজনী",
      badge: "👑 হাজার মাসের চেয়ে শ্রেষ্ঠ রাত",
      icon: "✨",
      description: "রমজানের শেষ দশকের বিজোড় রাতগুলোর অন্যতম। এ রাতে ইবাদত ১,০০০ মাস (৮৩ বছর ৪ মাস) ইবাদতের চেয়েও শ্রেষ্ঠ।",
    ),
    IslamicAnnualEvent(
      id: "eid_ul_fitr",
      month: 10,
      day: 1,
      titleBn: "পবিত্র ঈদুল ফিতর (রোজার ঈদ)",
      titleEn: "Eid-ul-Fitr (1st Shawwal)",
      category: "ঈদ ও উৎসব",
      badge: "🎉 রোজা রাখা হারাম / আনন্দ উৎসব",
      icon: "🎁",
      description: "এক মাসের সিয়াম সাধনার পর বিশ্ব মুসলিমের পরম আনন্দের উৎসব। ফিতরা আদায় ও ঈদের সালাত আদায় করা ওয়াজিব।",
    ),
    IslamicAnnualEvent(
      id: "six_fasts_shawwal",
      month: 10,
      day: 2,
      titleBn: "শাওয়ালের ৬ রোজা শুরু",
      titleEn: "Six Sunnah Fasts of Shawwal",
      category: "সুন্নাত রোজা",
      badge: "💎 পুরো বছর রোজার সমান সওয়াব",
      icon: "🗓️",
      description: "রাসূল (ﷺ) বলেন: যে রমজানের রোজা রাখল অতঃপর শাওয়ালের ৬টি রোজা রাখল, সে যেন সারা বছরই রোজা রাখল। (সহীহ মুসলিম)",
    ),
    IslamicAnnualEvent(
      id: "ten_days_dhul_hijjah",
      month: 12,
      day: 1,
      titleBn: "জিলহজের প্রথম দশক শুরু",
      titleEn: "First 10 Days of Dhu al-Hijjah",
      category: "শ্রেষ্ঠ দিনসমূহ",
      badge: "🌿 বছরের শ্রেষ্ঠ ১০ দিন",
      icon: "💎",
      description: "রাসূল (ﷺ) বলেন: যিলহজের প্রথম ১০ দিনের সৎকাজের চেয়ে আল্লাহর কাছে অধিক প্রিয় অন্য কোনো দিনের আমল নেই। (বুখারী)",
    ),
    IslamicAnnualEvent(
      id: "hajj_days",
      month: 12,
      day: 8,
      titleBn: "পবিত্র হজের মূল কার্যক্রম শুরু (৮-১২ জিলহজ)",
      titleEn: "Hajj Pilgrimage Begins (8th Dhu al-Hijjah)",
      category: "ফরজ হজ",
      badge: "🕋 লাব্বাইকা আল্লাহুম্মা লাব্বাইক",
      icon: "🕋",
      description: "মিনায় অবস্থানের মধ্য দিয়ে শুরু হয় ইসলামের অন্যতম মহান ফরজ ইবাদত পবিত্র হজের মূল আনুষ্ঠানিকতা।",
    ),
    IslamicAnnualEvent(
      id: "arafah_day",
      month: 12,
      day: 9,
      titleBn: "পবিত্র ইয়াওমু আরাফাহ (আরাফার দিন ও রোজা)",
      titleEn: "Day of Arafah (9th Dhu al-Hijjah)",
      category: "শ্রেষ্ঠ দিন ও রোজা",
      badge: "⭐ আগের ও পরের ২ বছরের পাপ মোচনকারী রোজা",
      icon: "🤲",
      description: "হজের মূল দিন এবং সারা বছরের সর্বশ্রেষ্ঠ দিন। যারা হজে নন তাদের জন্য আরাফার রোজা রাখা অত্যন্ত মর্যাদাপূর্ণ সুন্নাত।",
    ),
    IslamicAnnualEvent(
      id: "eid_ul_adha",
      month: 12,
      day: 10,
      titleBn: "পবিত্র ঈদুল আজহা (কোরবানির ঈদ)",
      titleEn: "Eid-ul-Adha (10th Dhu al-Hijjah)",
      category: "ঈদ ও কোরবানি",
      badge: "🎉 রোজা রাখা হারাম / কোরবানি ওয়াজিব",
      icon: "🐑",
      description: "হযরত ইব্রাহিম (আ.) ও ইসমাইল (আ.)-এর মহান আত্মত্যাগের স্মরণে পশু কোরবানি ও তাকবিরের দিন।",
    ),
    IslamicAnnualEvent(
      id: "ayyam_at_tashreeq",
      month: 12,
      day: 11,
      titleBn: "আইয়ামে তাশরিক শুরু (১১, ১২ ও ১৩ জিলহজ)",
      titleEn: "Days of Tashreeq (11-13 Dhu al-Hijjah)",
      category: "তাকবির ও খাবার",
      badge: "🚫 রোজা রাখা সম্পূর্ণ হারাম",
      icon: "📢",
      description: "পানাহার ও আল্লাহর জিকিরের দিন। প্রত্যেক ফরজ সালাতের পর 'তাকবিরে তাশরিক' পাঠ করা ওয়াজিব। এ দিনগুলোতে রোজা রাখা হারাম।",
    ),
  ];

  static const List<Map<String, String>> fastingRules = [
    {
      'title': 'আইয়ামে বিজের ৩টি রোজা (প্রতি হিজরি মাসের ১৩, ১৪ ও ১৫ তারিখ)',
      'ruling': 'সুন্নাতে মুয়াক্কাদা',
      'desc':
          'প্রতি চান্দ্র মাসের ১৩, ১৪ ও ১৫ তারিখ রোজা রাখা সারা বছর রোজা রাখার সমতুল্য। হযরত আবু হুরায়রা (রা.) বলেন, আমার প্রিয় বন্ধু (রাসূল ﷺ) আমাকে প্রতি মাসে তিনটি করে রোজা রাখার অসিয়ত করেছেন (সহীহ বুখারী: ১৯৮১)।',
    },
    {
      'title': 'প্রতি সপ্তাহের সোমবার ও বৃহস্পতিবারের রোজা',
      'ruling': 'মুস্তাহাব / সুন্নাত',
      'desc':
          'সোম ও বৃহস্পতিবার বান্দার আমল আল্লাহর দরবারে পেশ করা হয়, তাই রাসূলুল্লাহ (ﷺ) এই দুই দিন রোজা রাখতে পছন্দ করতেন (সুনান তিরমিযী: ৭৪৭)।',
    },
    {
      'title': 'শাওয়াল মাসের ৬টি রোজা',
      'ruling': 'মুস্তাহাব / সুন্নাত',
      'desc':
          'রমজানের রোজা রাখার পর শাওয়াল মাসে ৬টি রোজা রাখলে পূর্ণ এক বছর রোজা রাখার সওয়াব পাওয়া যায় (সহীহ মুসলিম: ১১৬৪)।',
    },
    {
      'title': 'জিলহজের প্রথম ৯ দিন ও আরাফার দিনের রোজা',
      'ruling': 'অত্যন্ত ফজিলতপূর্ণ সুন্নাত',
      'desc':
          'জিলহজের প্রথম দশকের নেক আমল আল্লাহর কাছে বছরের অন্য যেকোনো দিনের চেয়ে অধিক প্রিয় (সহীহ বুখারী: ৯৬৯)। আরাফার দিনের রোজা আগের ও পরের ২ বছরের গুনাহ মাফ করে (সহীহ মুসলিম: ১১৬২)।',
    },
    {
      'title': 'যে ৫ দিনে রোজা রাখা সম্পূর্ণ হারাম (নিষিদ্ধ)',
      'ruling': 'হারাম (নিষিদ্ধ)',
      'desc':
          '১. পবিত্র ঈদুল ফিতরের দিন (১ শাওয়াল), ২. পবিত্র ঈদুল আজহার দিন (১০ জিলহজ), ৩. আইয়ামে তাশরিকের ৩ দিন (১১, ১২ ও ১৩ জিলহজ)। রাসূলুল্লাহ (ﷺ) এ দিনগুলোতে রোজা রাখতে নিষেধ করেছেন (সহীহ মুসলিম: ১১৪০)।',
    },
  ];

  /// Converts a Gregorian DateTime to HijriDateInfo with optional offset adjustment
  static HijriDateInfo gregorianToHijri(DateTime dateInput, [int offsetDays = 0]) {
    final normalized = DateTime(dateInput.year, dateInput.month, dateInput.day);
    final targetDate = normalized.add(Duration(days: offsetDays));

    int day = targetDate.day;
    int month = targetDate.month;
    int year = targetDate.year;

    int m = month;
    int y = year;
    if (m < 3) {
      y -= 1;
      m += 12;
    }

    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    final jd = (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        day +
        b -
        1524;

    final z = jd - 1948084;
    final hy = ((30 * z + 10646) / 10631).floor();
    final hmRaw = ((z - 29 - (hy - 1) * 354 - ((3 + 11 * hy) / 30).floor()) / 29.5).ceil() + 1;
    final hm = hmRaw.clamp(1, 12);
    final hd = (z -
            (29.5001 * (hm - 1)).floor() -
            (hy - 1) * 354 -
            ((3 + 11 * hy) / 30).floor() +
            1)
        .floor();

    final monthObj = months.firstWhere(
      (item) => item.number == hm,
      orElse: () => months.first,
    );

    final isWhiteDay = (hd == 13 || hd == 14 || hd == 15);
    final isProhibitedFasting =
        (hm == 10 && hd == 1) || (hm == 12 && (hd >= 10 && hd <= 13));
    final isFriday = targetDate.weekday == DateTime.friday;
    final isMonday = targetDate.weekday == DateTime.monday;
    final isThursday = targetDate.weekday == DateTime.thursday;

    final matchingEvents =
        events.where((ev) => ev.month == hm && ev.day == hd).toList();

    final dayBn = BengaliNumerals.toBengali(hd);
    final yearBn = BengaliNumerals.toBengali(hy);

    return HijriDateInfo(
      day: hd,
      month: hm,
      year: hy,
      dayBn: dayBn,
      yearBn: yearBn,
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
      formattedBn: '$dayBn ${monthObj.nameBn}, $yearBn হিজরি',
    );
  }

  /// Approximate Hijri to Gregorian conversion with optional offset adjustment
  static DateTime hijriToGregorian(
    int hYear,
    int hMonth,
    int hDay, [
    int offsetDays = 0,
  ]) {
    final z = ((11 * hYear + 3) / 30).floor() +
        354 * (hYear - 1) +
        (29.5001 * (hMonth - 1)).floor() +
        hDay +
        1948084 -
        1;
    final jd = z;

    final l = jd + 68569;
    final n = ((4 * l) / 146097).floor();
    final l2 = l - ((146097 * n + 3) / 4).floor();
    final i = ((4000 * (l2 + 1)) / 1461001).floor();
    final l3 = l2 - ((1461 * i) / 4).floor() + 31;
    final j = ((80 * l3) / 2447).floor();
    final d = l3 - ((2447 * j) / 80).floor();
    final l4 = (j / 11).floor();
    final m = j + 2 - 12 * l4;
    final y = 100 * (n - 49) + i + l4;

    final baseDate = DateTime(y, m, d);
    return baseDate.subtract(Duration(days: offsetDays));
  }

  /// Compute upcoming Islamic events sorted chronologically
  static List<UpcomingIslamicEvent> getUpcomingEvents(
    DateTime baseDate, [
    int offsetDays = 0,
  ]) {
    final nowDay = DateTime(baseDate.year, baseDate.month, baseDate.day);
    final currentHijri = gregorianToHijri(nowDay, offsetDays);
    final currentHYear = currentHijri.year;

    final result = <UpcomingIslamicEvent>[];
    for (final ev in events) {
      int targetHYear = currentHYear;
      DateTime eventGregorian =
          hijriToGregorian(currentHYear, ev.month, ev.day, offsetDays);

      if (eventGregorian.isBefore(nowDay)) {
        targetHYear = currentHYear + 1;
        eventGregorian =
            hijriToGregorian(targetHYear, ev.month, ev.day, offsetDays);
      }

      final daysRemaining = eventGregorian.difference(nowDay).inDays;
      result.add(UpcomingIslamicEvent(
        event: ev,
        hijriYear: targetHYear,
        targetGregorianDate: eventGregorian,
        daysRemaining: daysRemaining,
        isToday: daysRemaining == 0,
      ));
    }

    result.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    return result;
  }

  /// Generates day-by-day calendar data for an entire Hijri month
  static HijriMonthCalendar getMonthCalendar(
    int hYear,
    int hMonth, [
    int offsetDays = 0,
  ]) {
    final isLeapYear = ((11 * hYear + 14) % 30) < 11;
    final daysInMonth =
        (hMonth % 2 == 1 || (hMonth == 12 && isLeapYear)) ? 30 : 29;

    final days = <CalendarDayEntry>[];
    for (int d = 1; d <= daysInMonth; d++) {
      final gDate = hijriToGregorian(hYear, hMonth, d, offsetDays);
      final isWhiteDay = (d == 13 || d == 14 || d == 15);
      final isProhibited =
          (hMonth == 10 && d == 1) || (hMonth == 12 && (d >= 10 && d <= 13));
      final isFriday = gDate.weekday == DateTime.friday;
      final matchingEvents =
          events.where((ev) => ev.month == hMonth && ev.day == d).toList();

      days.add(CalendarDayEntry(
        hijriDay: d,
        hijriDayBn: BengaliNumerals.toBengali(d),
        hijriMonth: hMonth,
        hijriYear: hYear,
        gregorianDate: gDate,
        gregorianDay: gDate.day,
        gregorianMonth: gDate.month,
        gregorianWeekday: gDate.weekday,
        isWhiteDay: isWhiteDay,
        isProhibitedFasting: isProhibited,
        isFriday: isFriday,
        events: matchingEvents,
      ));
    }

    final monthInfo = months.firstWhere(
      (m) => m.number == hMonth,
      orElse: () => months.first,
    );

    return HijriMonthCalendar(
      year: hYear,
      month: hMonth,
      monthInfo: monthInfo,
      totalDays: daysInMonth,
      days: days,
    );
  }
}
