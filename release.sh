#!/bin/bash
# release.sh - Create a tagged release and update version info everywhere

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 v2.0"
  exit 1
fi

VERSION=$1
# strip leading "v" for Debian metadata
DEB_VERSION="${VERSION#v}"

# Ensure all changes are committed
if ! git diff-index --quiet HEAD --; then
  echo "⚠️ You have uncommitted changes. Please commit or stash before releasing."
  exit 1
fi

# Ensure we're on main
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" != "main" ]; then
  echo "⚠️ You are on branch '$BRANCH'. Releases should be made from 'main'."
  echo "Switch to main with: git checkout main && git merge v2.0-dev"
  exit 1
fi

echo "📦 Updating version numbers to $DEB_VERSION ..."

# Update DEBIAN/control
if [ -f "DEBIAN/control" ]; then
  sed -i "s/^Version:.*/Version: $DEB_VERSION/" DEBIAN/control
fi

# Update launcherhub.sh (if version line exists)
if grep -q "^VERSION=" launcherhub.sh; then
  sed -i "s/^VERSION=.*/VERSION=\"$DEB_VERSION\"/" launcherhub.sh
fi

# Update Makefile VERSION line
if grep -q "^VERSION ?=" Makefile; then
  sed -i "s/^VERSION ?=.*/VERSION ?= $DEB_VERSION/" Makefile
fi

# Update changelog (prepend entry)
if [ -f "CHANGELOG.md" ]; then
  sed -i "1i## $VERSION - $(date +%Y-%m-%d)\n- Released $VERSION\n" CHANGELOG.md
fi

# Commit version bump
git add DEBIAN/control launcherhub.sh Makefile CHANGELOG.md 2>/dev/null || true
git commit -m "Bump version to $VERSION"

echo "🏷️ Creating git tag $VERSION ..."
git tag -a "$VERSION" -m "Release $VERSION"

# Push branch + tag
git push origin main
git push origin "$VERSION"

echo "✅ Release $VERSION created and pushed!"
echo "GitHub Actions will now build and publish the .deb + update the APT repo."