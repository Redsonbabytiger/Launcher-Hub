# Makefile for Launcher Hub
APP_NAME = launcherhub
VERSION ?= 1.1
ARCH    ?= amd64
DEB_DIR = build/$(APP_NAME)_$(VERSION)_$(ARCH)
SRC_DIR = src
USR_SHARE = usr/share

.PHONY: all clean build install

all: build

build:
	@echo "📦 Building $(APP_NAME) $(VERSION) ..."
	rm -rf build
	mkdir -p $(DEB_DIR)/usr/local/bin
	mkdir -p $(DEB_DIR)/DEBIAN
	mkdir -p $(DEB_DIR)/$(USR_SHARE)/applications
	mkdir -p $(DEB_DIR)/$(USR_SHARE)/icons/hicolor/64x64/apps

	# Copy main script
	install -m 755 $(SRC_DIR)/launcherhub.sh $(DEB_DIR)/usr/local/bin/$(APP_NAME)

	# Copy .desktop file
	cp $(USR_SHARE)/applications/launcherhub.desktop $(DEB_DIR)/$(USR_SHARE)/applications/

	# Copy icon
	cp $(USR_SHARE)/icons/hicolor/64x64/apps/launcherhub.png $(DEB_DIR)/$(USR_SHARE)/icons/hicolor/64x64/apps/

	# Generate DEBIAN/control file at build time
	cat > $(DEB_DIR)/DEBIAN/control <<EOF
Package: $(APP_NAME)
Version: $(VERSION)
Section: utils
Priority: optional
Architecture: $(ARCH)
Maintainer: You <you@example.com>
Description: Launcher Hub - A GUI hub and VM manager

EOF

	# Build .deb
	dpkg-deb --build --root-owner-group $(DEB_DIR)
	mv build/*.deb .

clean:
	rm -rf build *.deb

install: build
	sudo dpkg -i $(APP_NAME)_$(VERSION)_$(ARCH).deb
