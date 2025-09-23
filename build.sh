#!/bin/bash
PACKAGE="launcherhub"
VERSION="1.0"
ARCH="amd64"
BUILD_DIR="${PACKAGE}_${VERSION}"

echo "==> Cleaning old build..."
rm -rf "$BUILD_DIR" "${PACKAGE}_${VERSION}.deb"

echo "==> Copying files..."
mkdir -p "$BUILD_DIR"
cp -r DEBIAN usr src "$BUILD_DIR"/
mv "$BUILD_DIR/src/launcherhub.sh" "$BUILD_DIR/usr/local/bin/launcherhub"
rm -rf "$BUILD_DIR/src"

chmod -R 755 "$BUILD_DIR"/DEBIAN
chmod +x "$BUILD_DIR"/usr/local/bin/launcherhub

echo "==> Building package..."
dpkg-deb --build "$BUILD_DIR"

echo "==> Installing package..."
sudo dpkg -i "${PACKAGE}_${VERSION}.deb" || sudo apt -f install -y

echo "==> Done. You can run it from your app menu or by typing 'launcherhub'."