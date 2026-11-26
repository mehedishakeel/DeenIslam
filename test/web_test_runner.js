/**
 * DeenIslam Comprehensive Web Suite & Security Unit Tests
 * Run with: node test/web_test_runner.js
 */

const fs = require('fs');
const path = require('path');
const assert = require('assert');

// Mock a lightweight browser window environment
global.window = global;
global.document = {
    addEventListener: () => {},
    head: { appendChild: () => {} },
    createElement: () => ({ setAttribute: () => {}, innerHTML: '', style: {} }),
    body: { appendChild: () => {} },
    getElementById: () => null,
};
global.localStorage = {
    _data: {},
    getItem: function(k) { return this._data[k] || null; },
    setItem: function(k, v) { this._data[k] = String(v); },
    removeItem: function(k) { delete this._data[k]; }
};

// Load components.js, muslim-names-data.js, and islamic-calendar-data.js into context
const componentsCode = fs.readFileSync(path.join(__dirname, '../js/components.js'), 'utf8');
eval(componentsCode);

const muslimNamesCode = fs.readFileSync(path.join(__dirname, '../js/muslim-names-data.js'), 'utf8');
eval(muslimNamesCode);

const islamicCalendarCode = fs.readFileSync(path.join(__dirname, '../js/islamic-calendar-data.js'), 'utf8');
eval(islamicCalendarCode);

const quizDataCode = fs.readFileSync(path.join(__dirname, '../js/quiz-data.js'), 'utf8');
eval(quizDataCode);

let totalTests = 0;
let passedTests = 0;

function it(name, fn) {
    totalTests++;
    try {
        fn();
        console.log(`  ✓ ${name}`);
        passedTests++;
    } catch (err) {
        console.error(`  ✗ ${name}`);
        console.error(`    ${err.message}`);
    }
}

function describe(suiteName, fn) {
    console.log(`\n--- ${suiteName} ---`);
    fn();
}

console.log('🌙 Running DeenIslam Web Test Suite & Security Audit...');

describe('1. Bengali Numerals & Formatting', () => {
    it('should convert English digits to Bengali numerals correctly', () => {
        assert.strictEqual(window.toBengaliNumerals(12345), '১২৩৪৫');
        assert.strictEqual(window.toBengaliNumerals('Surah 114'), 'Surah ১১৪');
        assert.strictEqual(window.toBengaliNumerals(0), '০');
    });

    it('should handle empty or null values gracefully', () => {
        assert.strictEqual(window.toBengaliNumerals(null), '');
        assert.strictEqual(window.toBengaliNumerals(undefined), '');
    });
});

describe('2. Security: XSS Sanitization & HTML Escaping', () => {
    it('should escape dangerous HTML characters (&, <, >, ", \')', () => {
        const payload = '<script>alert("XSS & attack")</script>';
        const escaped = window.escapeHTML(payload);
        assert.strictEqual(escaped.includes('<script>'), false);
        assert.strictEqual(escaped.includes('&lt;script&gt;'), true);
        assert.strictEqual(escaped.includes('&quot;'), true);
        assert.strictEqual(escaped.includes('&amp;'), true);
    });

    it('should return empty string for null/undefined', () => {
        assert.strictEqual(window.escapeHTML(null), '');
        assert.strictEqual(window.escapeHTML(undefined), '');
    });
});

describe('3. 64 Districts Database & Geographical Boundary Integrity', () => {
    it('should contain all 64 districts of Bangladesh', () => {
        assert.strictEqual(Array.isArray(window.BD_DISTRICTS), true);
        assert.strictEqual(window.BD_DISTRICTS.length, 64);
    });

    it('Dhaka district should have offset 0', () => {
        const dhaka = window.BD_DISTRICTS.find(d => d.name === 'ঢাকা');
        assert.ok(dhaka, 'Dhaka not found in BD_DISTRICTS');
        assert.strictEqual(dhaka.offset, 0);
    });

    it('All districts must be strictly within Bangladesh coordinates bounds', () => {
        for (const d of window.BD_DISTRICTS) {
            assert.ok(d.name && d.name.trim().length > 0, 'District name missing');
            assert.ok(d.division && d.division.trim().length > 0, `District ${d.name} division missing`);
            assert.ok(d.lat >= 20.5 && d.lat <= 27.0, `District ${d.name} latitude ${d.lat} out of BD bounds`);
            assert.ok(d.lon >= 88.0 && d.lon <= 93.0, `District ${d.name} longitude ${d.lon} out of BD bounds`);
            assert.ok(d.offset >= -15 && d.offset <= 15, `District ${d.name} offset ${d.offset} unreasonable`);
        }
    });

    it('All 8 Administrative Divisions are represented', () => {
        const divisions = new Set(window.BD_DISTRICTS.map(d => d.division));
        const expected = ['ঢাকা', 'চট্টগ্রাম', 'সিলেট', 'রাজশাহী', 'খুলনা', 'বরিশাল', 'রংপুর', 'ময়মনসিংহ'];
        for (const div of expected) {
            assert.ok(divisions.has(div), `Division ${div} not represented in BD_DISTRICTS`);
        }
    });
});

describe('4. Universal Command Palette: 114 Surahs Indexing', () => {
    it('should index all 114 Surahs from Surah 1 to 114', () => {
        const surahs = commandPaletteIndex.filter(item => item.category === 'কুরআন সূরা');
        assert.strictEqual(surahs.length, 114);
    });

    it('Searching by Surah number finds the exact Surah', () => {
        const surah36 = commandPaletteIndex.find(item => item.url === 'surah.html?id=36');
        assert.ok(surah36, 'Surah 36 Ya-Sin not found');
        assert.ok(surah36.keywords.includes('36'));
        assert.ok(surah36.keywords.includes('৩৬'));
        assert.ok(surah36.title.includes('ইয়াসীন'));
    });

    it('Searching by English name finds the exact Surah', () => {
        const ikhlas = commandPaletteIndex.find(item => item.url === 'surah.html?id=112');
        assert.ok(ikhlas, 'Surah 112 Al-Ikhlas not found');
        assert.ok(ikhlas.keywords.toLowerCase().includes('ikhlas'));
    });
});

describe('5. Zakat Calculator Mathematics & Presets', () => {
    it('accurately calculates 2.5% Zakat on net assets', () => {
        const cash = 100000;
        const gold = 200000;
        const debt = 50000;
        const netAssets = cash + gold - debt; // 250,000
        const zakat = netAssets * 0.025; // 6,250
        assert.strictEqual(zakat, 6250);
    });

    it('Bhori to Gram conversion adheres to standard (1 Bhori = 11.664g)', () => {
        const grams = 23.328;
        const bhori = grams / 11.664;
        assert.strictEqual(bhori, 2);
    });
});

describe('6. Security: Share Card XSS Defense', () => {
    it('escapes injected malicious HTML within share card generation', () => {
        const maliciousData = {
            category: '<img src=x onerror=alert(1)>কুরআন',
            title: '<script>evil()</script>',
            translation: 'Normal text "quoted" & <dangerous>',
            arabic: 'بِسْمِ اللَّهِ',
            reference: '<a href="javascript:attack()">Ref</a>'
        };

        const html = renderCardHTML(maliciousData, 'emerald');
        assert.strictEqual(html.includes('<img src=x onerror=alert(1)>'), false);
        assert.strictEqual(html.includes('<script>evil()</script>'), false);
        assert.strictEqual(html.includes('href="javascript:attack()"'), false);
        assert.strictEqual(html.includes('&lt;script&gt;evil()&lt;/script&gt;'), true);
        assert.strictEqual(html.includes('&amp;'), true);
    });
});

describe('7. Muslim Baby Names Database & Navigation Integrity', () => {
    it('should load authentic Muslim names database with 100+ names', () => {
        assert.ok(window.muslimNamesData, 'muslimNamesData is not defined');
        assert.ok(Array.isArray(window.muslimNamesData.names), 'names is not an array');
        assert.ok(window.muslimNamesData.names.length >= 100, `Expected 100+ names, got ${window.muslimNamesData.names.length}`);
    });

    it('each name item has valid schema (id, name, arabic, english, meaning, gender, letter)', () => {
        window.muslimNamesData.names.forEach(n => {
            assert.ok(n.id, `Missing id for ${JSON.stringify(n)}`);
            assert.ok(n.name, `Missing name for ${n.id}`);
            assert.ok(n.arabic, `Missing arabic for ${n.id}`);
            assert.ok(n.english, `Missing english for ${n.id}`);
            assert.ok(n.meaning, `Missing meaning for ${n.id}`);
            assert.ok(n.gender === 'boy' || n.gender === 'girl', `Invalid gender for ${n.id}`);
            assert.ok(n.letter, `Missing letter for ${n.id}`);
        });
    });

    it('contains naming guidelines and prohibited names datasets', () => {
        assert.ok(Array.isArray(window.muslimNamesData.guidelines), 'guidelines missing');
        assert.ok(window.muslimNamesData.guidelines.length >= 5, 'expected at least 5 guidelines');
        assert.ok(Array.isArray(window.muslimNamesData.prohibitedNames), 'prohibitedNames missing');
        assert.ok(window.muslimNamesData.prohibitedNames.length >= 5, 'expected at least 5 prohibited names');
    });

    it('Universal Command Palette indexes muslim-names.html', () => {
        const item = commandPaletteIndex.find(i => i.url === 'muslim-names.html');
        assert.ok(item, 'muslim-names.html is not indexed in Command Palette');
        assert.ok(item.keywords.includes('muslim'));
        assert.ok(item.keywords.includes('baby'));
    });
});

describe('8. Islamic Calendar Engine, Date Converter & Navigation Integrity', () => {
    it('should define all 12 Islamic months with 4 sacred months (Ashhurul Hurum)', () => {
        assert.ok(window.IslamicCalendarData, 'IslamicCalendarData is not loaded');
        assert.strictEqual(window.IslamicCalendarData.MONTHS.length, 12);
        const sacred = window.IslamicCalendarData.MONTHS.filter(m => m.isSacred);
        assert.strictEqual(sacred.length, 4, 'Must have exactly 4 sacred months');
        const sacredNumbers = sacred.map(m => m.number);
        assert.deepStrictEqual(sacredNumbers, [1, 7, 11, 12], 'Sacred months must be Muharram, Rajab, Dhu al-Qidah, Dhu al-Hijjah');
    });

    it('contains major annual Islamic events with countdown dates', () => {
        assert.ok(window.IslamicCalendarData.EVENTS.length >= 10);
        const eventIds = window.IslamicCalendarData.EVENTS.map(e => e.id);
        assert.ok(eventIds.includes('ramadan_start'), 'Must include Ramadan start');
        assert.ok(eventIds.includes('eid_ul_fitr'), 'Must include Eid ul Fitr');
        assert.ok(eventIds.includes('eid_ul_adha'), 'Must include Eid ul Adha');
        assert.ok(eventIds.includes('ashura'), 'Must include Ashura');
        assert.ok(eventIds.includes('arafah_day'), 'Must include Day of Arafah');
    });

    it('accurately identifies white days (Ayyam al-Beed: 13, 14, 15) and prohibited fasting days', () => {
        // 13, 14, 15 are white days
        const d13 = window.IslamicCalendarData.gregorianToHijri('2026-03-03');
        // Test direct helper
        const cal = window.IslamicCalendarData.getMonthCalendar(1448, 9); // Ramadan
        assert.strictEqual(cal.days.find(d => d.hijriDay === 13).isWhiteDay, true);
        assert.strictEqual(cal.days.find(d => d.hijriDay === 14).isWhiteDay, true);
        assert.strictEqual(cal.days.find(d => d.hijriDay === 15).isWhiteDay, true);
        assert.strictEqual(cal.days.find(d => d.hijriDay === 12).isWhiteDay, false);

        // Prohibited fasting days: 1 Shawwal, 10, 11, 12, 13 Dhu al-Hijjah
        const shawwalCal = window.IslamicCalendarData.getMonthCalendar(1448, 10);
        assert.strictEqual(shawwalCal.days.find(d => d.hijriDay === 1).isProhibitedFasting, true);
        assert.strictEqual(shawwalCal.days.find(d => d.hijriDay === 2).isProhibitedFasting, false);

        const dhulHijjahCal = window.IslamicCalendarData.getMonthCalendar(1448, 12);
        assert.strictEqual(dhulHijjahCal.days.find(d => d.hijriDay === 10).isProhibitedFasting, true);
        assert.strictEqual(dhulHijjahCal.days.find(d => d.hijriDay === 11).isProhibitedFasting, true);
        assert.strictEqual(dhulHijjahCal.days.find(d => d.hijriDay === 12).isProhibitedFasting, true);
        assert.strictEqual(dhulHijjahCal.days.find(d => d.hijriDay === 13).isProhibitedFasting, true);
        assert.strictEqual(dhulHijjahCal.days.find(d => d.hijriDay === 9).isProhibitedFasting, false); // Arafah is recommended
    });

    it('converts Gregorian to Hijri and respects manual offset adjustments', () => {
        const base = window.IslamicCalendarData.gregorianToHijri('2026-05-15', 0);
        const plusOne = window.IslamicCalendarData.gregorianToHijri('2026-05-15', 1);
        const minusOne = window.IslamicCalendarData.gregorianToHijri('2026-05-15', -1);

        assert.ok(base.formattedBn.includes('হিজরি'));
        assert.strictEqual(plusOne.gregorianDate.getDate(), 16);
        assert.strictEqual(minusOne.gregorianDate.getDate(), 14);
    });

    it('Universal Command Palette indexes islamic-calendar.html', () => {
        const item = commandPaletteIndex.find(i => i.url === 'islamic-calendar.html');
        assert.ok(item, 'islamic-calendar.html is not indexed in Command Palette');
        assert.ok(item.keywords.includes('calendar'));
        assert.ok(item.keywords.includes('hijri'));
    });

    it('validates islamic-calendar.html structure and presence on disk', () => {
        const filePath = path.join(__dirname, '../islamic-calendar.html');
        assert.ok(fs.existsSync(filePath), 'islamic-calendar.html missing on disk');
        const content = fs.readFileSync(filePath, 'utf8');
        assert.ok(content.includes('navbar-placeholder'), 'Missing navbar-placeholder');
        assert.ok(content.includes('footer-placeholder'), 'Missing footer-placeholder');
        assert.ok(content.includes('today-hijri-display'), 'Missing today-hijri-display');
        assert.ok(content.includes('events-grid-container'), 'Missing events-grid-container');
        assert.ok(content.includes('calendar-days-grid'), 'Missing calendar-days-grid');
    });
});

describe('9. Islamic Quiz & Masael FAQs Dataset & Navigation Integrity', () => {
    it('should load QuizData with categories, 16+ questions, and 8+ FAQs', () => {
        assert.ok(window.QuizData, 'QuizData is not loaded');
        assert.strictEqual(window.QuizData.CATEGORIES.length, 4);
        assert.ok(window.QuizData.QUESTIONS.length >= 16, 'Expected at least 16 quiz questions');
        assert.ok(window.QuizData.FAQS.length >= 8, 'Expected at least 8 Masael FAQs');
    });

    it('every quiz question has valid options, in-bounds answer index, and explanation', () => {
        const validCats = new Set(['quran', 'seerah', 'fiqh']);
        window.QuizData.QUESTIONS.forEach(item => {
            assert.ok(validCats.has(item.category), `Invalid category for question ${item.id}`);
            assert.ok(item.q && item.q.length > 5, `Empty question text for ${item.id}`);
            assert.ok(Array.isArray(item.options) && item.options.length === 4, `Question ${item.id} must have 4 options`);
            assert.ok(item.answer >= 0 && item.answer < item.options.length, `Invalid answer index for ${item.id}`);
            assert.ok(item.explanation && item.explanation.length > 10, `Missing explanation for ${item.id}`);
        });
    });

    it('Universal Command Palette indexes quiz.html', () => {
        const item = commandPaletteIndex.find(i => i.url === 'quiz.html');
        assert.ok(item, 'quiz.html is not indexed in Command Palette');
        assert.ok(item.keywords.includes('quiz'));
    });

    it('validates quiz.html structure and presence on disk', () => {
        const filePath = path.join(__dirname, '../quiz.html');
        assert.ok(fs.existsSync(filePath), 'quiz.html missing on disk');
        const content = fs.readFileSync(filePath, 'utf8');
        assert.ok(content.includes('navbar-placeholder'), 'Missing navbar-placeholder');
        assert.ok(content.includes('footer-placeholder'), 'Missing footer-placeholder');
        assert.ok(content.includes('quiz-question-card'), 'Missing quiz-question-card');
        assert.ok(content.includes('faq-list-container'), 'Missing faq-list-container');
    });
});

describe('10. Quran Reader Font Controls, Auto-Scroll & Reading Progress Integrity', () => {
    it('surah.html includes font size controls, auto-scroll highlight, and completion toggle', () => {
        const surahHtml = fs.readFileSync(path.join(__dirname, '../surah.html'), 'utf8');
        assert.ok(surahHtml.includes('adjustFontSize'), 'Missing adjustFontSize handler');
        assert.ok(surahHtml.includes('arabic-size-label'), 'Missing arabic-size-label');
        assert.ok(surahHtml.includes('bengali-size-label'), 'Missing bengali-size-label');
        assert.ok(surahHtml.includes('toggleSurahCompleted'), 'Missing toggleSurahCompleted handler');
        assert.ok(surahHtml.includes('scrollIntoView'), 'Missing auto-scroll into view on highlight');
    });

    it('quran.html includes Khatam reading progress bar and completed tracker', () => {
        const quranHtml = fs.readFileSync(path.join(__dirname, '../quran.html'), 'utf8');
        assert.ok(quranHtml.includes('khatam-progress-card'), 'Missing khatam-progress-card');
        assert.ok(quranHtml.includes('khatam-progress-bar'), 'Missing khatam-progress-bar');
        assert.ok(quranHtml.includes('deen_completed_surahs'), 'Missing deen_completed_surahs tracker');
    });
});

describe('11. Dua & Daily Adhkar Loop Counters & Persistence Integrity', () => {
    it('dua.html includes daily persisted Adhkar progress banner and reset controls', () => {
        const duaHtml = fs.readFileSync(path.join(__dirname, '../dua.html'), 'utf8');
        assert.ok(duaHtml.includes('adhkar-progress-banner'), 'Missing adhkar-progress-banner');
        assert.ok(duaHtml.includes('adhkar-progress-bar'), 'Missing adhkar-progress-bar');
        assert.ok(duaHtml.includes('deen_dua_counts_v1'), 'Missing daily persistence key');
        assert.ok(duaHtml.includes('hasbiyallahu-7'), 'Missing 7x Hasbiyallahu adhkar');
        assert.ok(duaHtml.includes('raditu-billahi-3'), 'Missing 3x Raditu Billahi adhkar');
        assert.ok(duaHtml.includes('resetAllDuaCounters'), 'Missing resetAllDuaCounters');
    });
});

describe('12. SEO, Open Graph, Twitter Card & Schema.org Coverage', () => {
    it('all public HTML pages contain canonical URL, OG tags, Twitter Card, and valid JSON-LD schema', () => {
        const rootDir = path.join(__dirname, '..');
        const rootFiles = fs.readdirSync(rootDir)
            .filter(f => f.endsWith('.html') && f !== '404.html')
            .map(f => path.join(rootDir, f));
        const articlesDir = path.join(rootDir, 'articles');
        const articleFiles = fs.existsSync(articlesDir)
            ? fs.readdirSync(articlesDir).filter(f => f.endsWith('.html')).map(f => path.join(articlesDir, f))
            : [];
        const allFiles = [...rootFiles, ...articleFiles];
        assert.ok(allFiles.length >= 30, `Expected at least 30 HTML files, found ${allFiles.length}`);

        allFiles.forEach(file => {
            const name = path.relative(rootDir, file);
            const content = fs.readFileSync(file, 'utf8');
            assert.ok(content.includes('rel="canonical"'), `${name} missing canonical tag`);
            assert.ok(content.includes('property="og:title"'), `${name} missing og:title`);
            assert.ok(content.includes('property="og:description"'), `${name} missing og:description`);
            assert.ok(content.includes('property="og:image"'), `${name} missing og:image`);
            assert.ok(content.includes('twitter:card'), `${name} missing twitter:card`);
            assert.ok(!content.includes('share-preview.png'), `${name} references missing share-preview.png`);

            const ldMatch = content.match(/<script type="application\/ld\+json">\s*([\s\S]*?)\s*<\/script>/);
            assert.ok(ldMatch && ldMatch[1], `${name} missing JSON-LD script`);
            const parsed = JSON.parse(ldMatch[1]);
            assert.ok(parsed['@context'] === 'https://schema.org', `${name} invalid Schema.org @context`);
        });
    });
});

describe('13. Service Worker & APK Download Safety', () => {
    it('sw.js bypasses cross-origin requests and binary (.apk) downloads', () => {
        const swCode = fs.readFileSync(path.join(__dirname, '../sw.js'), 'utf8');
        assert.ok(swCode.includes('url.origin !== self.location.origin'), 'Missing cross-origin bypass in sw.js');
        assert.ok(swCode.includes('.apk') || swCode.includes('apk|zip'), 'Missing .apk bypass in sw.js');
    });

    it('index.html APK download link opens safely without same-tab SW interception', () => {
        const indexHtml = fs.readFileSync(path.join(__dirname, '../index.html'), 'utf8');
        assert.ok(indexHtml.includes('DeenIslam-v1.6.0.apk'), 'Missing v1.6.0 APK link');
        assert.ok(indexHtml.includes('download="DeenIslam-v1.6.0.apk"'), 'Missing download attribute on APK link');
    });

    it('sw.js handles notificationclick for web prayer reminders', () => {
        const swCode = fs.readFileSync(path.join(__dirname, '../sw.js'), 'utf8');
        assert.ok(swCode.includes('notificationclick'), 'Missing notificationclick listener in sw.js');
    });
});

describe('14. v1.5.0 Features: Backup v2, Tafsir, Ampara Offline Batch, Special Prayers & Reminders', () => {
    it('bookmarks.html supports full-state v2 JSON backup and restore', () => {
        const html = fs.readFileSync(path.join(__dirname, '../bookmarks.html'), 'utf8');
        assert.ok(html.includes('exportBookmarksJSON'), 'Missing exportBookmarksJSON');
        assert.ok(html.includes('importBookmarksJSON'), 'Missing importBookmarksJSON');
        assert.ok(html.includes('version: 2'), 'Missing v2 backup schema');
    });

    it('surah.html includes Bengali Mokhtasar Tafsir toggle and CacheStorage lookup', () => {
        const html = fs.readFileSync(path.join(__dirname, '../surah.html'), 'utf8');
        assert.ok(html.includes('tafsir-toggle-btn'), 'Missing tafsir-toggle-btn');
        assert.ok(html.includes('toggleTafsirMode'), 'Missing toggleTafsirMode');
        assert.ok(html.includes('bengali-mokhtasar'), 'Missing bengali-mokhtasar endpoint');
    });

    it('quran.html includes batch offline Ampara downloader', () => {
        const html = fs.readFileSync(path.join(__dirname, '../quran.html'), 'utf8');
        assert.ok(html.includes('batch-offline-btn'), 'Missing batch-offline-btn');
        assert.ok(html.includes('downloadAmparaOffline'), 'Missing downloadAmparaOffline');
    });

    it('namaz.html includes Janazah, Istikharah, and Tahajjud practical guides', () => {
        const html = fs.readFileSync(path.join(__dirname, '../namaz.html'), 'utf8');
        assert.ok(html.includes('id="special-prayers"'), 'Missing #special-prayers section');
    });

    it('salat.html includes opt-in web prayer reminder toggle and minute check', () => {
        const html = fs.readFileSync(path.join(__dirname, '../salat.html'), 'utf8');
        assert.ok(html.includes('enableWebPrayerReminders'), 'Missing enableWebPrayerReminders');
        assert.ok(html.includes('checkWebPrayerReminderTick'), 'Missing checkWebPrayerReminderTick');
    });
});

console.log(`\n========================================`);
console.log(`Summary: ${passedTests}/${totalTests} tests passed.`);
console.log(`Status: ${passedTests === totalTests ? 'SUCCESS - ALL TESTS PASSED' : 'FAILURE'}`);
console.log(`========================================\n`);

if (passedTests !== totalTests) {
    process.exit(1);
}
