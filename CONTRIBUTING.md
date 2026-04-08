# Contributing

## Prerequisites

Install these tools before working on the project:

| Tool | Purpose | Install |
|---|---|---|
| **Node.js** (v18+) | Runs HTMLHint and ESLint | `brew install node` or [nodejs.org](https://nodejs.org) |
| **actionlint** | Lints GitHub Actions workflows | `brew install actionlint` |
| **pre-commit** | Runs linters on every commit | `brew install pre-commit` or `pip install pre-commit` |

## First-time setup

```bash
npm install          # install HTMLHint, ESLint, and plugins
pre-commit install   # activate the pre-commit hook
```

## Linting

```bash
npm run lint           # all linters (HTML + JS + Actions)
npm run lint:html      # HTMLHint only
npm run lint:js        # ESLint only
npm run lint:actions   # actionlint only
```

The pre-commit hook runs all linters automatically on every commit.

## Cutting a release

```bash
./release.sh          # major release (e.g. v1.2.3 → v2.0.0)
./release.sh minor    # minor release (e.g. v1.2.3 → v1.3.0)
./release.sh patch    # patch release (e.g. v1.2.3 → v1.2.4)
```

The script verifies a clean state, runs all linters, creates a git tag, and pushes it. GitHub Actions then builds the release and publishes the versioned HTML file.
