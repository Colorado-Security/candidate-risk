#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# release.sh — cut a tagged GitHub release for candidate-risk
#
# Usage:
#   ./release.sh          # major release (e.g. v1.2.3 → v2.0.0)
#   ./release.sh minor    # minor release (e.g. v1.2.3 → v1.3.0)
#   ./release.sh patch    # patch release (e.g. v1.2.3 → v1.2.4)
# ---------------------------------------------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}==>${NC} $*"; }
warn()  { echo -e "${YELLOW}warn:${NC} $*"; }
die()   { echo -e "${RED}error:${NC} $*" >&2; exit 1; }

# --- determine bump type ---------------------------------------------------
BUMP="${1:-major}"
case "$BUMP" in
  major|minor|patch) ;;
  *) die "Unknown bump type '$BUMP'. Use: major, minor, patch" ;;
esac

# --- compute next version --------------------------------------------------
LATEST=$(git tag --list 'v*.*.*' --sort=-version:refname | head -1)

if [[ -z "$LATEST" ]]; then
  # No tags yet — start at v1.0.0 regardless of bump type
  VERSION="v1.0.0"
else
  # Strip leading 'v' and split
  IFS='.' read -r MAJOR MINOR PATCH <<< "${LATEST#v}"
  case "$BUMP" in
    major) VERSION="v$((MAJOR + 1)).0.0" ;;
    minor) VERSION="v${MAJOR}.$((MINOR + 1)).0" ;;
    patch) VERSION="v${MAJOR}.${MINOR}.$((PATCH + 1))" ;;
  esac
fi

warn "Latest release: ${LATEST:-none}"
info "Next version ($BUMP): $VERSION"
read -rp "Proceed? [y/N] " CONFIRM
[[ "$CONFIRM" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

# --- preflight checks ------------------------------------------------------
info "Running preflight checks..."

# Must be on main
BRANCH=$(git rev-parse --abbrev-ref HEAD)
[[ "$BRANCH" == "main" ]] || die "Must be on main branch (currently on: $BRANCH)"

# Working tree must be clean
if ! git diff --quiet || ! git diff --cached --quiet; then
  die "Working tree has uncommitted changes — commit or stash them first"
fi

# Tag must not already exist
if git tag --list | grep -qx "$VERSION"; then
  die "Tag $VERSION already exists"
fi

# Pull latest so we're not behind
info "Pulling latest from origin/main..."
git pull --ff-only origin main

# --- lint ------------------------------------------------------------------
info "Running linters..."
npm run lint

# --- tag and push ----------------------------------------------------------
info "Creating tag $VERSION..."
git tag "$VERSION"

info "Pushing tag to origin..."
git push origin "$VERSION"

echo ""
echo -e "${GREEN}Done!${NC} GitHub Actions is now building the release."
echo "Follow progress at: https://github.com/Colorado-Security/candidate-risk/actions"
echo "Release will appear at: https://github.com/Colorado-Security/candidate-risk/releases/tag/$VERSION"
