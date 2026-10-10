# 🌙 DeenIslam (দ্বীন ইসলাম)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Language: Bengali](https://img.shields.io/badge/Language-Bengali-green.svg)](#)
[![Tech: TailwindCSS](https://img.shields.io/badge/Tech-TailwindCSS-38B2AC.svg)](#)
[![GitHub Pages](https://img.shields.io/badge/Hosted%20on-GitHub%20Pages-blue.svg)](https://deenislam.org/)
[![PWA Ready](https://img.shields.io/badge/PWA-Offline%20Ready-emerald.svg)](#)
[![Android APK v1.0](https://img.shields.io/badge/Android%20APK-v1.0%20Download-047857.svg)](https://github.com/mehedishakeel/DeenIslam/releases/download/v1.0/DeenIslam-v1.0.apk)

**DeenIslam** is an ad-free, privacy-first Islamic web portal and native Android application (`mobile/`) providing authentic Islamic resources in Bengali.

- **Live Website:** [https://deenislam.org/](https://deenislam.org/)
- **Android App (APK v1.0):** [Download DeenIslam-v1.0.apk](https://github.com/mehedishakeel/DeenIslam/releases/download/v1.0/DeenIslam-v1.0.apk)

---

## 📱 Native Android Application (`mobile/`)

Built with **Flutter 3** and native Android Kotlin channels (`MainActivity.kt`):
- **Al-Quran (114 Surahs) & Audio Recitation:** Full Arabic & Bengali translations, offline Surah caching, last-read tracker, and native Android `MediaPlayer` MP3 streaming (Sheikh Mishary Rashid Alafasy).
- **Hadith Library (7 Books):** Sahih Bukhari, Sahih Muslim, Sunan Abu Dawud, Jami at-Tirmidhi, Sunan an-Nasa'i, Sunan Ibn Majah, and Muwatta Malik with offline download & search.
- **All 64 Districts Prayer Times & Azan Alarms:** Accurate prayer, Suhoor, and Iftar timings for all 64 districts of Bangladesh, per-waqt Azan alarm toggles, and Makkah Haramain Azan audio preview.
- **Live Hardware Qibla Compass:** Native Android Magnetometer + Accelerometer sensor fusion with district Qibla bearings and alignment haptic feedback.
- **18 Complete Modules:** Quran, Hadith, Daily Duas, 6 Kalimas, Salat & Wudu Guide, Ramadan & 30-Day Roza Tracker, Hajj & Umrah Guide, Islamic Articles & Audio Hub, Digital Tasbih, Zakat Calculator, 99 Names of Allah, Hijri Calendar, Islamic Quiz & FAQ, Unified Bookmarks, and Global Search.

```bash
# Build Android Release APK locally
cd mobile
flutter pub get
flutter build apk --release
```

---

## ✨ Web Portal Features

### 🧭 Digital Qibla Compass (`qibla.html`)
- Real-time GPS & IP-based geographical bearing calculation to the Kaaba in Mecca using spherical trigonometry (Haversine formula).
- Device orientation sensor support (compass gyroscope) with iOS sensor permission handling and desktop manual degree fallback.
- Audio and haptic pulse feedback when perfectly aligned with the Qibla.

### 🤲 Hisnul Muslim - Daily Duas & Azkar (`dua.html`)
- 18+ categorized authentic daily duas (morning/evening, prayer, repentance, Rabbana, healing).
- Arabic typography, Bengali transliteration, Bengali meaning, and authentic Hadith/Quranic citations.
- Interactive repetition counters (e.g. 3x, 33x, 100x), quick copy, and bookmarking.

### 🌟 99 Names of Allah (`allah-names.html`)
- Complete collection of all 99 Names of Allah (Asmaul Husna) with serial numbering.
- Beautiful Arabic script, Bengali pronunciation, Bengali meaning, and spiritual significance.
- Live instant search filter and bookmarking.

### 📖 Al-Quran & Hifz Tools (`quran.html`, `surah.html`)
- Complete 114 Surahs and **30 Juz (Para)** view modes.
- **Audio loop & repeat selector:** 1x, 3x, 5x, or continuous loop for Quran memorization (Hifz).
- **Playback speed control:** 0.75x, 1.0x, 1.25x, 1.5x.
- **Last Read Tracker:** Automatically saves reading progress and displays an instant "Continue Reading" banner on both Quran and Home pages.
- Customizable font sizes for Arabic and Bengali text with floating settings drawer.

### 📜 Hadith Library with Offline Storage (`hadith.html`, `hadith-view.html`)
- 7 major Hadith collections (Sahih Bukhari, Muslim, Tirmidhi, Abu Dawood, Nasai, Ibn Majah, Malik).
- **IndexedDB Caching (`deen_hadith_db`):** Pre-caches heavy Hadith JSON datasets locally to eliminate repeated 10MB network downloads.
- Full text search, pagination, bookmarking, and copy functionality.

### 🕌 Comprehensive Salah Guide (`namaz.html`) & Prayer Timings (`salat.html`)
- 5-waqt prayer timing table with precise Hanafi vs Shafi'i Asr school calculation toggle.
- Live Suhoor/Iftar countdown clock and dynamic Hijri calendar date.
- Complete step-by-step Salah Guide: 5-waqt rakat breakdown, Wudu and Tayammum guides, Sana, Ruku/Sajdah tasbihs, and Dua Qunut.

### 💎 Zakat Calculator (`zakat.html`)
- Interactive real-time calculator covering cash, gold, silver, business inventory, and debt deductions.
- Automatic 2.5% net output calculation and Nisab guidance according to Quranic categories.

### ⚡ Universal Command Palette (Ctrl + K / ⌘K)
- Global shortcut modal (`Ctrl + K` or `/`) to instantly search and jump to any Surah, tool, or dua across the entire website offline.

### 🔖 Bookmarks with JSON Backup & Restore (`bookmarks.html`)
- Centralized bookmark manager for Quran, Hadith, Duas, Allah's Names, and Media.
- **JSON Export & Import:** Backup bookmarks to a JSON file and restore across devices without requiring any backend.

### 🌓 Dark Mode & Progressive Web App (PWA)
- Full system and manual dark mode support across all pages.
- Offline-ready Service Worker (`sw.js`) with resilient caching for GitHub Pages subpaths and custom domains.

---

## 🚀 Tech Stack

- **Web Frontend:** HTML5, CSS3, Tailwind CSS, Vanilla JavaScript (ES6+)
- **Mobile App:** Flutter 3 (Dart), Native Android Kotlin (`MediaPlayer` & `SensorManager` MethodChannels)
- **Offline Storage:** IndexedDB (`deen_hadith_db`), LocalStorage, SharedPreferences
- **Sensors & APIs:** DeviceOrientation API, Geolocation API, AlAdhan API, AlQuran Cloud API, Hadith CDN API
- **Fonts:** Hind Siliguri, Noto Sans Bengali & Amiri Arabic (Google Fonts)
- **CI/CD & Hosting:** GitHub Actions (Automated Android APK Release) & GitHub Pages

---

## 🛠️ Local Development & Running

```bash
# Clone the repository
git clone https://github.com/mehedishakeel/DeenIslam.git
cd DeenIslam

# Run Web Portal locally
python3 -m http.server 8000
```

---

## 📄 License

Distributed under the MIT License.

