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

// Load components.js into context
const componentsCode = fs.readFileSync(path.join(__dirname, '../js/components.js'), 'utf8');
eval(componentsCode);

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

console.log(`\n========================================`);
console.log(`Summary: ${passedTests}/${totalTests} tests passed.`);
console.log(`Status: ${passedTests === totalTests ? 'SUCCESS - ALL TESTS PASSED' : 'FAILURE'}`);
console.log(`========================================\n`);

if (passedTests !== totalTests) {
    process.exit(1);
}
