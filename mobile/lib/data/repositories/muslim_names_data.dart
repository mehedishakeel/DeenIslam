class MuslimNameItem {
  final int id;
  final String name;
  final String arabic;
  final String english;
  final String meaning;
  final String gender; // 'boy' or 'girl'
  final String letter;

  const MuslimNameItem({
    required this.id,
    required this.name,
    required this.arabic,
    required this.english,
    required this.meaning,
    required this.gender,
    required this.letter,
  });
}

class MuslimNamesData {
  static const List<MuslimNameItem> names = [
    // Boys (ছেলেদের নাম)
    MuslimNameItem(id: 1, name: "মুহাম্মদ", arabic: "مُحَمَّد", english: "Muhammad", meaning: "প্রশংসিত, যাঁর সর্বাধিক প্রশংসা করা হয়েছে", gender: "boy", letter: "ম"),
    MuslimNameItem(id: 2, name: "আহমাদ", arabic: "أَحْمَد", english: "Ahmad", meaning: "অধিক প্রশংসাকারী, অত্যন্ত প্রশংসিত", gender: "boy", letter: "আ"),
    MuslimNameItem(id: 3, name: "আব্দুল্লাহ", arabic: "عَبْدُ الله", english: "Abdullah", meaning: "আল্লাহর প্রিয় বান্দা", gender: "boy", letter: "আ"),
    MuslimNameItem(id: 4, name: "আব্দুর রহমান", arabic: "عَبْدُ الرَّحْمٰن", english: "Abdur Rahman", meaning: "পরম দয়াময় আল্লাহর বান্দা", gender: "boy", letter: "আ"),
    MuslimNameItem(id: 5, name: "আব্দুর রহিম", arabic: "عَبْدُ الرَّحِيم", english: "Abdur Rahim", meaning: "অসীম করুণাময় আল্লাহর বান্দা", gender: "boy", letter: "আ"),
    MuslimNameItem(id: 6, name: "ইব্রাহিম", arabic: "إِبْرَاهِيم", english: "Ibrahim", meaning: "জাতির পিতা, নবী হযরত ইব্রাহিম (আ.)", gender: "boy", letter: "ই"),
    MuslimNameItem(id: 7, name: "ইউসুফ", arabic: "يُوسُف", english: "Yusuf", meaning: "আল্লাহ বৃদ্ধি করেন, সৌন্দর্য ও ধৈর্যের প্রতীক", gender: "boy", letter: "ই"),
    MuslimNameItem(id: 8, name: "মুসা", arabic: "مُوسَى", english: "Musa", meaning: "পানি থেকে উদ্ধারপ্রাপ্ত, নবী হযরত মুসা (আ.)", gender: "boy", letter: "ম"),
    MuslimNameItem(id: 9, name: "ঈসা", arabic: "عِيسَى", english: "Isa", meaning: "আল্লাহর সাহায্যপ্রাপ্ত, নবী হযরত ঈসা (আ.)", gender: "boy", letter: "ঈ"),
    MuslimNameItem(id: 10, name: "দাউদ", arabic: "دَاوُد", english: "Dawud", meaning: "প্রিয়তম, নবী হযরত দাউদ (আ.)", gender: "boy", letter: "দ"),
    MuslimNameItem(id: 11, name: "সুলাইমান", arabic: "سُلَيْمَان", english: "Sulaiman", meaning: "শান্তিপূর্ণ, সুবিচারক বাদশা ও নবী", gender: "boy", letter: "স"),
    MuslimNameItem(id: 12, name: "ইউনুস", arabic: "يُونُس", english: "Yunus", meaning: "আল্লাহর একনিষ্ঠ অনুগত নবী", gender: "boy", letter: "ই"),
    MuslimNameItem(id: 13, name: "ইয়াহিয়া", arabic: "يَحْيَى", english: "Yahya", meaning: "চিরঞ্জীব, আল্লাহ যাকে জীবন দান করেছেন", gender: "boy", letter: "ই"),
    MuslimNameItem(id: 14, name: "জাকারিয়া", arabic: "زَكَرِيَّا", english: "Zakariya", meaning: "আল্লাহকে স্মরণকারী নবী", gender: "boy", letter: "জ"),
    MuslimNameItem(id: 15, name: "আবু বকর", arabic: "أَبُو بَكْر", english: "Abu Bakr", meaning: "প্রথম খলিফা, ইসলামের সত্যবাদী বন্ধু (সিদ্দিক)", gender: "boy", letter: "আ"),
    MuslimNameItem(id: 16, name: "উমর", arabic: "عُمَر", english: "Umar", meaning: "দীর্ঘায়ু, ন্যায়বিচারক দ্বিতীয় খলিফা (ফারুক)", gender: "boy", letter: "উ"),
    MuslimNameItem(id: 17, name: "উসমান", arabic: "عُثْمَان", english: "Uthman", meaning: "বিনম্র, লাজুক, দুই নূরের অধিকারী খলিফা (জুন্নুরাইন)", gender: "boy", letter: "উ"),
    MuslimNameItem(id: 18, name: "আলী", arabic: "عَلِيّ", english: "Ali", meaning: "উচ্চ মর্যাদাশীল, চতুর্থ খলিফা ও বীর সেনানী", gender: "boy", letter: "আ"),
    MuslimNameItem(id: 19, name: "হাসান", arabic: "حَسَن", english: "Hasan", meaning: "সুন্দর, সৎ স্বভাবের অধিকারী, জান্নাতী যুবকদের সর্দার", gender: "boy", letter: "হ"),
    MuslimNameItem(id: 20, name: "হুসাইন", arabic: "حُسَيْن", english: "Husain", meaning: "অতি সুশ্রী, পরম সম্মানিত, জান্নাতী যুবকদের সর্দার", gender: "boy", letter: "হ"),
    MuslimNameItem(id: 21, name: "হামজাহ", arabic: "حَمْزَة", english: "Hamza", meaning: "সিংহ, বীরত্ব ও সাহসিকতার প্রতীক", gender: "boy", letter: "হ"),
    MuslimNameItem(id: 22, name: "বিলাল", arabic: "بِلَال", english: "Bilal", meaning: "সজীবতা, আর্দ্রতা, ইসলামের প্রথম মুয়াজ্জিন", gender: "boy", letter: "ব"),
    MuslimNameItem(id: 23, name: "সালমান", arabic: "سَلْمَان", english: "Salman", meaning: "নিরাপদ, শান্তিকামী, প্রখ্যাত সাহাবী সালমান ফারসি (রা.)", gender: "boy", letter: "স"),
    MuslimNameItem(id: 24, name: "জায়িদ", arabic: "زَيْد", english: "Zayd", meaning: "প্রবৃদ্ধি, প্রাচুর্য, কুরআনে বর্ণিত প্রিয় সাহাবী", gender: "boy", letter: "জ"),
    MuslimNameItem(id: 25, name: "খালেদ", arabic: "خَالِد", english: "Khalid", meaning: "চিরস্থায়ী, অপরাজেয় সেনাপতি (সাইফুল্লাহ)", gender: "boy", letter: "খ"),
    MuslimNameItem(id: 26, name: "তারিক", arabic: "طَارِق", english: "Tariq", meaning: "ভোরের উজ্জ্বল নক্ষত্র, বিজয়ী বীর", gender: "boy", letter: "ত"),
    MuslimNameItem(id: 27, name: "আনাস", arabic: "أَنَس", english: "Anas", meaning: "আনন্দময়, প্রিয় সঙ্গী, সাহাবী আনাস ইবনে মালিক (রা.)", gender: "boy", letter: "আ"),
    MuslimNameItem(id: 28, name: "মুয়াজ", arabic: "مُعَاذ", english: "Mu'adh", meaning: "আল্লাহর আশ্রয়ে সুরক্ষিত", gender: "boy", letter: "ম"),
    MuslimNameItem(id: 29, name: "তালহা", arabic: "طَلْحَة", english: "Talha", meaning: "জান্নাতী ফলবান বৃক্ষ, আশারায়ে মুবাশশারাহর অন্যতম", gender: "boy", letter: "ত"),
    MuslimNameItem(id: 30, name: "জুবায়ের", arabic: "زُبَيْر", english: "Zubair", meaning: "দৃঢ় সংকল্পবদ্ধ বীর, রাসূল (ﷺ)-এর প্রিয় হাওয়ারী", gender: "boy", letter: "জ"),
    MuslimNameItem(id: 31, name: "সাদ", arabic: "سَعْد", english: "Sa'd", meaning: "সৌভাগ্যবান, আনন্দ ও সফলতার অধিকারী", gender: "boy", letter: "স"),
    MuslimNameItem(id: 32, name: "সাঈদ", arabic: "سَعِيد", english: "Sa'id", meaning: "সুখী, সৌভাগ্যবান ও পুণ্যবান ব্যক্তি", gender: "boy", letter: "স"),
    MuslimNameItem(id: 33, name: "আম্মার", arabic: "عَمَّار", english: "Ammar", meaning: "দৃঢ় ঈমানদার, আজীবন ইবাদতকারী", gender: "boy", letter: "আ"),
    MuslimNameItem(id: 34, name: "ইয়াসির", arabic: "يَاسِر", english: "Yasir", meaning: "সহজসাধ্য, সমৃদ্ধিশালী", gender: "boy", letter: "ই"),
    MuslimNameItem(id: 35, name: "হুযায়ফা", arabic: "حُذَيْفَة", english: "Hudhayfah", meaning: "বিশ্বস্ত বন্ধু ও গোপনীয়তার আমানতদার সাহাবী", gender: "boy", letter: "হ"),
    MuslimNameItem(id: 36, name: "ইমরান", arabic: "عِمْرَان", english: "Imran", meaning: "সমৃদ্ধি ও আবাদকারী, মারিয়াম (আ.)-এর পিতা", gender: "boy", letter: "ই"),
    MuslimNameItem(id: 37, name: "লুকমান", arabic: "لُقْمَان", english: "Luqman", meaning: "মহাজ্ঞানী, প্রজ্ঞাবান ব্যক্তি", gender: "boy", letter: "ল"),
    MuslimNameItem(id: 38, name: "হারুন", arabic: "هَارُون", english: "Harun", meaning: "উঁচু মর্যাদাশীল, মুসা (আ.)-এর ভ্রাতা ও নবী", gender: "boy", letter: "হ"),
    MuslimNameItem(id: 39, name: "আইয়ুব", arabic: "أَيُّوب", english: "Ayyub", meaning: "আল্লাহর দিকে প্রত্যাবর্তনকারী, ধৈর্যের মূর্তপ্রতীক", gender: "boy", letter: "আ"),
    MuslimNameItem(id: 40, name: "শুয়াইব", arabic: "شُعَيْب", english: "Shu'aib", meaning: "সঠিক পথের নির্দেশক নবী", gender: "boy", letter: "শ"),
    MuslimNameItem(id: 41, name: "সালেহ", arabic: "صَالِح", english: "Salih", meaning: "নেককার, সৎকর্মশীল নবী", gender: "boy", letter: "স"),
    MuslimNameItem(id: 42, name: "হুদ", arabic: "هُود", english: "Hud", meaning: "হিদায়াতপ্রাপ্ত নবী", gender: "boy", letter: "হ"),
    MuslimNameItem(id: 43, name: "নুহ", arabic: "نُوح", english: "Nuh", meaning: "শান্তি, দীর্ঘজীবী উলুল আযম নবী", gender: "boy", letter: "ন"),
    MuslimNameItem(id: 44, name: "ইদরীস", arabic: "إِدْرِيس", english: "Idris", meaning: "অধ্যয়নকারী ও জ্ঞানপিপাসু নবী", gender: "boy", letter: "ই"),
    MuslimNameItem(id: 45, name: "ইলিয়াস", arabic: "إِلْيَاس", english: "Ilyas", meaning: "আল্লাহই আমার প্রভু", gender: "boy", letter: "ই"),
    MuslimNameItem(id: 46, name: "রাইয়ান", arabic: "رَيَّان", english: "Rayyan", meaning: "পরিতৃপ্ত, রোজাদারদের জন্য নির্ধারিত জান্নাতের দরজা", gender: "boy", letter: "র"),
    MuslimNameItem(id: 47, name: "ফারহান", arabic: "فَرْحَان", english: "Farhan", meaning: "প্রফুল্ল, প্রীতিভাজন ও আনন্দিত", gender: "boy", letter: "ফ"),
    MuslimNameItem(id: 48, name: "তাহসিন", arabic: "تَحْسِين", english: "Tahsin", meaning: "উন্নতি, সৌন্দর্য বর্ধন ও সংস্কার", gender: "boy", letter: "ত"),
    MuslimNameItem(id: 49, name: "তামিম", arabic: "تَمِيم", english: "Tamim", meaning: "পরিপূর্ণ, চরিত্রবান ও সুদৃঢ়", gender: "boy", letter: "ত"),
    MuslimNameItem(id: 50, name: "জাবীর", arabic: "جَابِر", english: "Jabir", meaning: "সহানুভূতিশীল, ভগ্নহৃদয় সান্ত্বনাদানকারী সাহাবী", gender: "boy", letter: "জ"),
    MuslimNameItem(id: 51, name: "মাহির", arabic: "مَاهِر", english: "Mahir", meaning: "দক্ষ, বিচক্ষণ ও পারদর্শী", gender: "boy", letter: "ম"),
    MuslimNameItem(id: 52, name: "নাবিল", arabic: "نَبِيل", english: "Nabil", meaning: "উদারমনা, মহৎ ও মর্যাদাবান", gender: "boy", letter: "ন"),
    MuslimNameItem(id: 53, name: "সামির", arabic: "سَمِير", english: "Samir", meaning: "মনোমুগ্ধকর সহচর, রাতের সুহৃদ", gender: "boy", letter: "স"),
    MuslimNameItem(id: 54, name: "ফাহিম", arabic: "فَهِيم", english: "Fahim", meaning: "তীক্ষ্ণ বুদ্ধিসম্পন্ন, গভীর উপলব্ধিকারী", gender: "boy", letter: "ফ"),
    MuslimNameItem(id: 55, name: "আকিল", arabic: "عَاقِل", english: "Aqil", meaning: "বিবেকবান, প্রজ্ঞাবান ও বুদ্ধিমান", gender: "boy", letter: "আ"),
    MuslimNameItem(id: 56, name: "ওয়াসিম", arabic: "وَسِيم", english: "Wasim", meaning: "সুশ্রী, সুদর্শন ও কমনীয়", gender: "boy", letter: "ও"),
    MuslimNameItem(id: 57, name: "আহনাফ", arabic: "أَحْنَف", english: "Ahnaf", meaning: "একনিষ্ঠ তাওহীদবাদী, সত্যের অনুসারী", gender: "boy", letter: "আ"),
    MuslimNameItem(id: 58, name: "সাকিব", arabic: "ثَاقِب", english: "Saqib", meaning: "উজ্জ্বল, প্রদীপ্ত ও তীক্ষ্ণ তারকা", gender: "boy", letter: "স"),
    MuslimNameItem(id: 59, name: "কায়েস", arabic: "قَيْس", english: "Qais", meaning: "পরিমিতিবোধ সম্পন্ন ও দৃঢ়চেতা", gender: "boy", letter: "ক"),
    MuslimNameItem(id: 60, name: "শাফী", arabic: "شَافِي", english: "Shafi", meaning: "রোগমুক্তি প্রদানকারী বা সুপারিশকারী", gender: "boy", letter: "শ"),
    MuslimNameItem(id: 61, name: "মুস্তফা", arabic: "مُصْطَفَى", english: "Mustafa", meaning: "মনোনীত, নবীজী (ﷺ)-এর সম্মানিত উপাধি", gender: "boy", letter: "ম"),
    MuslimNameItem(id: 62, name: "মুজতবা", arabic: "مُجْتَبَى", english: "Mujtaba", meaning: "আল্লাহর মনোনীত প্রিয় বান্দা", gender: "boy", letter: "ম"),
    MuslimNameItem(id: 63, name: "তাহমিদ", arabic: "تَحْمِيد", english: "Tahmid", meaning: "আল্লাহর প্রশংসাগীতি পাঠকারী", gender: "boy", letter: "ত"),
    MuslimNameItem(id: 64, name: "তাসনিম", arabic: "تَسْنِيم", english: "Tasnim", meaning: "জান্নাতের সুউচ্চ ও স্ফটিক স্বচ্ছ ঝর্ণাধারা", gender: "boy", letter: "ত"),
    MuslimNameItem(id: 65, name: "রাকিন", arabic: "رَكِين", english: "Rakin", meaning: "দৃঢ় ভিত্তিসম্পন্ন, সম্মানিত ও বিশ্বাসভাজন", gender: "boy", letter: "র"),

    // Girls (মেয়েদের নাম)
    MuslimNameItem(id: 66, name: "খাদিজা", arabic: "خَدِيجَة", english: "Khadija", meaning: "প্রথম উম্মুল মুমিনীন, মহীয়সী ও অকালজাত সৌভাগ্যবতী", gender: "girl", letter: "খ"),
    MuslimNameItem(id: 67, name: "আয়েশা", arabic: "عَائِشَة", english: "Aisha", meaning: "সমৃদ্ধ জীবন্ত, মহাজ্ঞানী উম্মুল মুমিনীন", gender: "girl", letter: "আ"),
    MuslimNameItem(id: 68, name: "ফাতিমা", arabic: "فَاطِمَة", english: "Fatima", meaning: "নিষ্পাপ, জাহান্নাম থেকে মুক্তকারী, জান্নাতী নারীদের সর্দার", gender: "girl", letter: "ফ"),
    MuslimNameItem(id: 69, name: "মারিয়াম", arabic: "مَرْيَم", english: "Maryam", meaning: "আল্লাহর পবিত্র ভক্তিমতী সেবিকা, ঈসা (আ.)-এর মহীয়সী মাতা", gender: "girl", letter: "ম"),
    MuslimNameItem(id: 70, name: "আসিয়া", arabic: "آسِيَة", english: "Asiya", meaning: "দৃঢ় স্তম্ভ, পরম শান্তিদায়িনী, ফেরাউনের পুণ্যবতী স্ত্রী", gender: "girl", letter: "আ"),
    MuslimNameItem(id: 71, name: "হাফসা", arabic: "حَفْصَة", english: "Hafsa", meaning: "সিংহের শাবক, সাহসী ও প্রজ্ঞাবান উম্মুল মুমিনীন", gender: "girl", letter: "হ"),
    MuslimNameItem(id: 72, name: "জয়নব", arabic: "زَيْنَب", english: "Zainab", meaning: "সুদৃশ্য সুগন্ধিযুক্ত মরুভূমির ফুল", gender: "girl", letter: "জ"),
    MuslimNameItem(id: 73, name: "রুকাইয়াহ", arabic: "رُقَيَّة", english: "Ruqayyah", meaning: "উচ্চ মর্যাদাপূর্ণ ও কোমলমতি, নবীদুহিতা", gender: "girl", letter: "র"),
    MuslimNameItem(id: 74, name: "উম্মে কুলসুম", arabic: "أُمّ كُلْثُوم", english: "Umm Kulthum", meaning: "গোলাপী কমনীয় চেহারার অধিকারী, নবীদুহিতা", gender: "girl", letter: "উ"),
    MuslimNameItem(id: 75, name: "সাওদা", arabic: "سَوْدَة", english: "Sawda", meaning: "দানশীলা ও মমতাময়ী উম্মুল মুমিনীন", gender: "girl", letter: "স"),
    MuslimNameItem(id: 76, name: "জুওয়াইরিয়াহ", arabic: "جُوَيْرِيَة", english: "Juwairiyah", meaning: "ছোট প্রস্ফুটিত গোলাপ", gender: "girl", letter: "জ"),
    MuslimNameItem(id: 77, name: "সাফিয়াহ", arabic: "صَفِيَّة", english: "Safiyyah", meaning: "পবিত্র, নিষ্কলুষ ও আন্তরিক বন্ধু", gender: "girl", letter: "স"),
    MuslimNameItem(id: 78, name: "মায়মুনা", arabic: "مَيْمُونَة", english: "Maymunah", meaning: "বরকতময়ী, সৌভাগ্যবতী উম্মুল মুমিনীন", gender: "girl", letter: "ম"),
    MuslimNameItem(id: 79, name: "উম্মে সালামা", arabic: "أُمّ سَلَمَة", english: "Umm Salama", meaning: "শান্তির মাতা, বুদ্ধিমতী উম্মুল মুমিনীন", gender: "girl", letter: "উ"),
    MuslimNameItem(id: 80, name: "আসমা", arabic: "أَسْمَاء", english: "Asma", meaning: "উচ্চ মর্যাদাবতী, সাহাবী আবু বকর (রা.)-এর মহীয়সী কন্যা", gender: "girl", letter: "আ"),
    MuslimNameItem(id: 81, name: "সুমাইয়াহ", arabic: "سُمَيَّة", english: "Sumayyah", meaning: "উচ্চ মর্যাদাশীলা, ইসলামের প্রথম নারী শহীদ", gender: "girl", letter: "স"),
    MuslimNameItem(id: 82, name: "নুসাইবাহ", arabic: "نُسَيْبَة", english: "Nusaybah", meaning: "উচ্চ বংশীয়, বীর সেনানী নারী সাহাবী (উম্মে আম্মারা)", gender: "girl", letter: "ন"),
    MuslimNameItem(id: 83, name: "হালিমা", arabic: "حَلِيمَة", english: "Halimah", meaning: "ধৈর্যশীল ও কোমল হৃদয়া, নবীজীর দুধমাতা", gender: "girl", letter: "হ"),
    MuslimNameItem(id: 84, name: "আমিনা", arabic: "آمِنَة", english: "Aminah", meaning: "বিশ্বস্ত, নিরাপদ ও শান্তিময়ী, নবীজীর গর্ভধারিণী মাতা", gender: "girl", letter: "আ"),
    MuslimNameItem(id: 85, name: "হাজেরা", arabic: "هَاجَر", english: "Hajar", meaning: "আল্লাহর সন্তুষ্টিতে হিজরতকারিণী, ইসমাইল (আ.)-এর মাতা", gender: "girl", letter: "হ"),
    MuslimNameItem(id: 86, name: "সায়্যিদা", arabic: "سَيِّدَة", english: "Sayyida", meaning: "নেত্রী, ভদ্রমহিলা ও সম্মানিত নারী", gender: "girl", letter: "স"),
    MuslimNameItem(id: 87, name: "সারা", arabic: "سَارَة", english: "Sarah", meaning: "আনন্দদায়িনী, নবী ইব্রাহিম (আ.)-এর স্ত্রী", gender: "girl", letter: "স"),
    MuslimNameItem(id: 88, name: "বিলকিস", arabic: "بِلْقِيس", english: "Bilqis", meaning: "বুদ্ধিমতী রানি, যিনি তাওহীদের আলোয় উদ্ভাসিত হন", gender: "girl", letter: "ব"),
    MuslimNameItem(id: 89, name: "আফিয়া", arabic: "عَافِيَة", english: "Afiyah", meaning: "সুস্থতা, নিরাপত্তা ও শারীরিক-মানসিক প্রশান্তি", gender: "girl", letter: "আ"),
    MuslimNameItem(id: 90, name: "আনিসা", arabic: "أَنِيسَة", english: "Anisah", meaning: "স্নেহশীলা, প্রীতিভাজন ও অন্তরঙ্গ বান্ধবী", gender: "girl", letter: "আ"),
    MuslimNameItem(id: 91, name: "আলিয়া", arabic: "عَالِيَة", english: "Aliyah", meaning: "উচ্চস্থানপ্রাপ্তা, মহিমান্বিত ও শ্রেষ্ঠা", gender: "girl", letter: "আ"),
    MuslimNameItem(id: 92, name: "আমাতুল্লাহ", arabic: "أَمَةُ الله", english: "Amatullah", meaning: "আল্লাহর পুণ্যবতী দাসী", gender: "girl", letter: "আ"),
    MuslimNameItem(id: 93, name: "ফারিহা", arabic: "فَرِحَة", english: "Fariha", meaning: "আনন্দময়ী, প্রফুল্লচিত্ত ও সুখী", gender: "girl", letter: "ফ"),
    MuslimNameItem(id: 94, name: "তাসমিয়া", arabic: "تَسْمِيَة", english: "Tasmiyah", meaning: "বিসমিল্লাহ পাঠকারিণী, নামাঙ্কন", gender: "girl", letter: "ত"),
    MuslimNameItem(id: 95, name: "মালিহা", arabic: "مَلِيحَة", english: "Maliha", meaning: "অপরূপা, লাবণ্যময়ী ও মিষ্টভাষিণী", gender: "girl", letter: "ম"),
    MuslimNameItem(id: 96, name: "সালিহা", arabic: "صَالِحَة", english: "Salihah", meaning: "নেককার, পুণ্যবতী ও ধর্মপরায়ণ নারী", gender: "girl", letter: "স"),
    MuslimNameItem(id: 97, name: "মুনিরা", arabic: "مُنِيرَة", english: "Munira", meaning: "প্রদীপ্ত, জ্যোতির্ময়ী ও আলোকবর্তিকা", gender: "girl", letter: "ম"),
    MuslimNameItem(id: 98, name: "নাদিয়া", arabic: "نَادِيَة", english: "Nadia", meaning: "উদার, দানশীলা ও আহ্বায়িকা", gender: "girl", letter: "ন"),
    MuslimNameItem(id: 99, name: "নাফিসা", arabic: "نَفِيسَة", english: "Nafisa", meaning: "অমূল্য, অতি সূক্ষ্ম ও পরম মূল্যবান", gender: "girl", letter: "ন"),
    MuslimNameItem(id: 100, name: "নুসরাত", arabic: "نُصْرَة", english: "Nusrat", meaning: "আল্লাহর সাহায্য ও বিজয়", gender: "girl", letter: "ন"),
    MuslimNameItem(id: 101, name: "সামিহা", arabic: "سَمِيحَة", english: "Samiha", meaning: "ক্ষমাশীলা ও উদার হৃদয়ের অধিকারিণী", gender: "girl", letter: "স"),
    MuslimNameItem(id: 102, name: "সালমা", arabic: "سَلْمَى", english: "Salma", meaning: "নিরাপদ, শান্তিময়ী ও সুস্বাস্থ্যের অধিকারী", gender: "girl", letter: "স"),
    MuslimNameItem(id: 103, name: "তাহমিনা", arabic: "تَهْمِينَة", english: "Tahmina", meaning: "শক্তিশালী, বুদ্ধিমতী ও দৃঢ়চেতা", gender: "girl", letter: "ত"),
    MuslimNameItem(id: 104, name: "হুসনা", arabic: "حُسْنَى", english: "Husna", meaning: "পরম সৌন্দর্য, সর্বোত্তম কল্যাণ", gender: "girl", letter: "হ"),
    MuslimNameItem(id: 105, name: "লাতিফা", arabic: "لَطِيفَة", english: "Latifa", meaning: "কোমল স্বভাবা, দয়াময়ী ও মার্জিত", gender: "girl", letter: "ল"),
    MuslimNameItem(id: 106, name: "মারজিয়া", arabic: "مَرْضِيَّة", english: "Marziya", meaning: "আল্লাহর সন্তুষ্টিপ্রাপ্তা পুণ্যবতী", gender: "girl", letter: "ম"),
    MuslimNameItem(id: 107, name: "মুমতাহিনা", arabic: "مُمْتَحَنَة", english: "Mumtahina", meaning: "পরীক্ষিত ও উত্তীর্ণ মুমিন নারী", gender: "girl", letter: "ম"),
    MuslimNameItem(id: 108, name: "রায়হানা", arabic: "رَيْحَانَة", english: "Rayhana", meaning: "জান্নাতী সুগন্ধি ফুল বা সুঘ্রাণ", gender: "girl", letter: "র"),
    MuslimNameItem(id: 109, name: "রুহি", arabic: "رُوحِي", english: "Ruhi", meaning: "আমার আত্মা, আধ্যাত্মিক ও পরম স্নেহভাজন", gender: "girl", letter: "র"),
    MuslimNameItem(id: 110, name: "সাবিহা", arabic: "صَبِيحَة", english: "Sabiha", meaning: "ভোরের নির্মলতা, অনিন্দ্য সুন্দরী", gender: "girl", letter: "স"),
    MuslimNameItem(id: 111, name: "শামসিয়া", arabic: "شَمْسِيَّة", english: "Shamsiya", meaning: "সূর্যকিরণের ন্যায় উজ্জ্বল ও প্রদীপ্ত", gender: "girl", letter: "শ"),
    MuslimNameItem(id: 112, name: "তাহেরা", arabic: "طَاهِرَة", english: "Tahira", meaning: "পবিত্র, নিষ্কলুষ ও সতীসাধ্বী", gender: "girl", letter: "ত"),
    MuslimNameItem(id: 113, name: "জারা", arabic: "زَهْرَة", english: "Zahra", meaning: "উজ্জ্বলতা, প্রস্ফুটিত পুষ্পকলি", gender: "girl", letter: "জ"),
    MuslimNameItem(id: 114, name: "জাবিন", arabic: "جَبِين", english: "Jabin", meaning: "উজ্জ্বল ললাট বা সৌভাগ্যবতী মুখমণ্ডল", gender: "girl", letter: "জ"),
    MuslimNameItem(id: 115, name: "রাইসা", arabic: "رَئِيسَة", english: "Raisa", meaning: "নেত্রী, রানী বা মর্যাদাবান পরিচালক", gender: "girl", letter: "র"),
  ];

  static const List<Map<String, String>> guidelines = [
    {
      "title": "নামকরণের সর্বোত্তম সময়",
      "desc": "সন্তান জন্মের ৭ম দিনে নাম রাখা, আকিকা করা এবং মাথার চুল কামানো সুন্নাত (তিরমিযী: ২৮৩২)। জন্মের দিনেও নাম রাখা জায়েজ।"
    },
    {
      "title": "আল্লাহর নিকট সবচেয়ে প্রিয় নাম",
      "desc": "রাসূলুল্লাহ (ﷺ) বলেন: 'আল্লাহর নিকট তোমাদের নামের মধ্যে সর্বাধিক প্রিয় হলো আব্দুল্লাহ (আল্লাহর বান্দা) এবং আব্দুর রহমান (পরম করুণাময়ের বান্দা)।' (সহীহ মুসলিম: ২১৩২)"
    },
    {
      "title": "নবীদের নামে নাম রাখা",
      "desc": "রাসূল (ﷺ) তাঁর প্রিয় পুত্রের নাম রেখেছিলেন ইব্রাহিম এবং বলেছেন: 'তোমরা নবীদের নামে নাম রাখো।' (আবু দাউদ: ৪৯৫০)"
    },
    {
      "title": "উত্তম অর্থবহ নাম বাছাই",
      "desc": "রাসূলুল্লাহ (ﷺ) বলেছেন: 'কিয়ামতের দিন তোমাদেরকে তোমাদের নাম ও পিতার নাম ধরে ডাকা হবে। সুতরাং তোমরা সুন্দর অর্থবহ নাম রাখো।' (আবু দাউদ: ৪৯৪৮)"
    },
    {
      "title": "মন্দ নাম পরিবর্তন করা সুন্নাত",
      "desc": "রাসূলুল্লাহ (ﷺ) কোনো ব্যক্তির মন্দ অর্থবোধক বা উদ্ধত নাম শুনলে তা পরিবর্তন করে সুন্দর অর্থবোধক নাম রেখে দিতেন। (সহীহ বুখারী)"
    }
  ];

  static const List<Map<String, String>> prohibitedNames = [
    {
      "name": "আল্লাহর খাস গুণবাচক নাম সরাসরি রাখা",
      "reason": "রহমান, রাজ্জাক, খালেক, কুদ্দুস ইত্যাদি খাস নাম 'আব্দ' (বান্দা) যোগ না করে সরাসরি রাখা কঠোরভাবে হারাম। যেমন: আব্দুর রহমান বা আব্দুল খালেক রাখা ওয়াজিব।"
    },
    {
      "name": "গায়রুল্লাহর দাসত্ববোধক নাম",
      "reason": "আব্দুশ শামস (সূর্যের বান্দা), আব্দুল কা'বা, আব্দুর রাসূল বা কোনো পীর-বুজুর্গের নামে 'বান্দা' সম্বন্ধ করে নাম রাখা শিরক ও হারাম।"
    },
    {
      "name": "অহংকার ও অহমিকাযুক্ত নাম",
      "reason": "শাহেনশাহ (রাজাদের রাজা), মালিকুল মুলক (সম্রাটের সম্রাট) ইত্যাদি নাম রাখা হারাম। কারণ সার্বভৌমত্বের চূড়ান্ত মালিক একমাত্র আল্লাহ।"
    },
    {
      "name": "শয়তান, ফেরাউন ও জালিমদের নাম",
      "reason": "ইবলিস, খিনজাব, ফেরাউন, হামান, কারুন, আবু জাহেল ইত্যাদি অভিশপ্তদের নামে নাম রাখা ইসলামে নিষিদ্ধ।"
    },
    {
      "name": "মন্দ ও অশুভ অর্থবোধক নাম",
      "reason": "যুদ্ধ (হারব), তিক্ততা (মুররাহ), অন্ধকার (জুলাম), পাপ (ইসম) ইত্যাদি নেতিবাচক অর্থসম্পন্ন নাম রাখা অনুচিত ও মাকরুহ।"
    }
  ];
}
