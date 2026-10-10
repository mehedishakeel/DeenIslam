# DeenIslam Design System & Visual Specification

This document defines the visual direction, design tokens, and craftsmanship rules for DeenIslam, complying with the **anti-slop** design philosophy.

---

## 1. Identity & Philosophy
- **Concept:** A serene, respectful, and dignified Islamic digital sanctuary.
- **Aesthetic:** Modern Islamic Editorial & Architectural Craftsmanship.
- **Filter Standard:** Zero generic SaaS cliches (no arbitrary bento boxes, no neon radial glow orbs, no pill-shaped everything, no generic pastel cards).
- **Liveliness Dials:**
  - **ENERGY: 2** — Clear visual hierarchy, rich contrast between deep botanical emerald and warm ivory, reverent Arabic typography.
  - **RHYTHM: 2** — Varied section structures driven by Islamic content (sacred verse framing, structured prayer timeline, architectural tool grid, interactive calculator).
  - **MOTION: 1** — Calibrated, subtle transitions (150ms-250ms), smooth SVG ring progressions, discrete audio feedback.

---

## 2. Color Palette (100% Preserved)
The original brand colors are strictly preserved and deepened with harmonious tones:

| Role | Name | Hex / Class | Purpose |
|------|------|-------------|---------|
| **Primary** | Botanical Emerald | `#059669` / `bg-emerald-600` | Primary brand color, spiritual identity, active waqt |
| **Primary Dark** | Deep Forest Emerald | `#047857` / `bg-emerald-700` | Hover states, hero gradients, emphasized headers |
| **Primary Deep** | Midnight Mosque | `#022c22` / `#064e3b` | Focal card background in hero, deep dark tone |
| **Accent** | Sacred Amber | `#d97706` / `#f59e0b` | One deliberate accent: next prayer countdown, audio play button, golden highlights |
| **Light Canvas** | Brand Ivory | `#fbfaf8` | Soothing, book-like paper background in light mode |
| **Dark Canvas** | Deep Obsidian Slate | `#020617` / `#0b1120` | OLED-friendly, eye-relieving night reading background |
| **Card Surface** | Pure Light / Deep Navy | `#ffffff` / `#0f172a` | Solid, grounded surfaces with crisp hairline borders |
| **Borders** | Hairline Stone / Slate | `rgba(226, 232, 240, 0.8)` / `rgba(30, 41, 59, 0.8)` | Structured separation without muddy drop shadows |

---

## 3. Typography Hierarchy
- **Bengali Headings & UI:** `Noto Sans Bengali` (weights: 500, 600, 700, 800, 900)
- **Arabic Sacred Text:** `Amiri` (weights: 400, 700) with generous line heights (`leading-[2.2]`) for vocalization marks (tashkeel).
- **Numerals & Timers:** Tabular nums, monospaced digits (`font-mono`) for prayer clocks and countdowns to prevent jitter.

---

## 4. Architectural Motifs & Craft
- **Corner Radius Scale:**
  - Major Cards: `rounded-2xl` (16px) or `rounded-3xl` (24px) with subtle Islamic architectural geometry.
  - Interactive Buttons & Inputs: `rounded-xl` (12px).
  - Status Pills & Badges: `rounded-lg` (8px) or discreet `rounded-full` (for status dots only).
- **Surface Elevation:**
  - Ground plane is flat and stable with hairline borders: `border border-stone-200/80 dark:border-slate-800`.
  - Elevation is reserved for floating elements (Command Palette modal, dropdown menus, audio bar).
  - No bloated fuzzy drop shadows or artificial corner glow blobs.
