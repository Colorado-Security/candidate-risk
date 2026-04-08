# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A single-file, standalone HTML application for candidate fraud risk assessment. No build step, no dependencies to install — open `Candidate_Risk_Dashboard.html` directly in a browser.

## Development

**Running the app:** Open `Candidate_Risk_Dashboard.html` in any browser. No server required.

**Testing changes:** Reload the browser tab. There is no test suite.

## Linting

```bash
npm install              # install dev deps (first time)
npm run lint             # run both linters
npm run lint:html        # HTMLHint only
npm run lint:js          # ESLint only (lints inline <script> via eslint-plugin-html)
```

**Pre-commit hook:** Uses the `pre-commit` framework. After `npm install`, run `pre-commit install` once to activate it. The hook runs both linters against staged `.html` files on every commit.

Config files: `.htmlhintrc` (HTML rules), `eslint.config.mjs` (JS rules — browser globals + `React`/`ReactDOM` as readonly).

## Architecture

The entire application lives in `Candidate_Risk_Dashboard.html` — React 18 is loaded via CDN (`cdnjs.cloudflare.com`) with SRI integrity hashes. All JavaScript is vanilla JS using `React.createElement` (no JSX, no transpilation).

### Key data structures

- `CATEGORIES` — array of scoring categories, each with `id`, `max` points, `stage`, and `levels` (radio options with fixed point values).
- `RISK_TIERS` — thresholds mapping cumulative score ranges to LOW / MODERATE / HIGH / CRITICAL risk levels.
- `EXAMPLE_SCORES` — hardcoded scores for the "Flagged Candidate" demo mode (confirmed DPRK IT worker fraud case).

### Modes

The app has three modes toggled by header buttons:
- **Example mode** — displays `EXAMPLE_SCORES` with radio inputs disabled; shows a case summary panel at the bottom.
- **Assess mode** — blank scores, editable inputs, candidate name/role fields, Reset button, and a **Copy Review Link** button that encodes the assessment as a URL-safe base64 string.
- **Panel View** — aggregates multiple reviewers' encoded links into a composite score; shows per-reviewer totals, per-category averages, and spread flags. Panel state syncs to the URL.

Score state is maintained in separate `useState` hooks (`scores` for example, `blankScores` for assess, `panelReviews` for panel) so switching modes preserves each independently.

### Components

- `GaugeRing` — SVG ring chart showing total score vs. max.
- `MiniBar` — horizontal progress bar per category.
- `CategoryCard` — renders one category with its radio level options.
- `PanelImport` — input UI for pasting reviewer links in Panel View.
- `PanelSummary` — aggregate gauge and tier for the panel composite score.
- `PanelCategoryCard` — per-category average with spread flag in Panel View.
- `ReviewerTable` — per-reviewer score breakdown table in Panel View.
- `PanelView` — root panel component; composes the above panel pieces.
- `App` — root component; owns all state and renders header, risk summary, tier legend, category grid, and (in example mode) the case detail panel.

## Security constraints

The CSP header (`Content-Security-Policy`) allows only `cdnjs.cloudflare.com` for scripts, with `worker-src 'none'` and `upgrade-insecure-requests`. Do not add inline `eval`, dynamic imports, or external script sources without updating the CSP. All script content must remain inline (current CSP uses `'unsafe-inline'` for scripts). The `referrer`, cache-busting meta tags, and `Permissions-Policy` are intentional — preserve them.

URL encoding uses `TextEncoder`/`TextDecoder` (not the deprecated `escape`/`unescape`). All string fields decoded from review links pass through `safeStr()` — a validation helper that enforces type and length caps. Do not bypass it.

No data is sent anywhere; the tool is entirely client-side with no network calls from application code.
