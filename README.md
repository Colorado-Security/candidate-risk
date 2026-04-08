# Candidate Fraud Risk Assessment

A standalone, single-file HTML tool for assessing candidate fraud risk — designed to detect patterns consistent with DPRK IT worker fraud and similar hiring threats.

**Public work by [Colorado Security](https://www.colorado-security.com/)**
V1: Ralph Forsythe, based upon the work of Joey Stanford | V2: Joey Stanford, CISO

---

## Usage

Open `Candidate_Risk_Dashboard.html` in any browser. No server, no install, no build step required.

## Modes

- **Example mode** — displays a pre-filled CRITICAL-risk case based on a confirmed DPRK IT worker fraud scenario. Inputs are read-only.
- **Assess mode** — blank scorecard with editable candidate name/role fields and a Reset button.

Switching modes preserves each scorecard's state independently.

## Scoring

Ten categories span four hiring stages:

| Stage | Categories |
|---|---|
| Stage 1 | Digital Footprint, Employer Verification, Resume Authenticity, Phone / Contact Integrity |
| Stage 2 | Interview Signals, Geographic Consistency |
| Stage 3 | Compensation Behavior, Identity Documentation |
| Stage 4 | Hardware / Onboarding, Identity Continuity |

**Risk tiers** (0–115 total points):

| Score | Level | Action |
|---|---|---|
| 0–15 | LOW | Proceed normally |
| 16–35 | MODERATE | Additional OSINT; flag for CISO awareness |
| 36–60 | HIGH | No offer without CISO approval; full ID verification |
| 61+ | CRITICAL | Reject; preserve evidence; initiate reporting |

## Development

```bash
npm install            # install dev dependencies (first time only)
pre-commit install     # activate pre-commit hook (first time only)

npm run lint           # run both linters
npm run lint:html      # HTMLHint only
npm run lint:js        # ESLint only (lints inline <script> via eslint-plugin-html)
```

The pre-commit hook runs both linters against staged `.html` files on every commit.

## Security

- No data is sent anywhere — entirely client-side, no network calls from application code.
- CSP restricts scripts to `cdnjs.cloudflare.com` (React 18 with SRI hashes) and inline scripts only.
- Cache-control headers, `no-referrer`, `noindex`, and `Permissions-Policy` are intentional — do not remove them.

## No License

No license. No warranties or guarantees of any kind.
