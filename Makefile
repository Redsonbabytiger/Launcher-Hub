# Makefile for Launcher Hub
APP_NAME = launcherhub
VERSION ?= 1.2
ARCH    ?= amd64
DEB_DIR = build/$(APP_NAME)_$(VERSION)_$(ARCH)
SRC_DIR = src
USR_SHARE = usr/share
CONTROL_TEMPLATE = DEBIAN/control

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

	# Copy and update control file from template
	sed \
		-e 's/@APP_NAME@/$(APP_NAME)/g' \
		-e 's/@VERSION@/$(VERSION)/g' \
		-e 's/@ARCH@/$(ARCH)/g' \
		$(CONTROL_TEMPLATE) > $(DEB_DIR)/DEBIAN/control

	# Build .deb
	dpkg-deb --build --root-owner-group $(DEB_DIR)
	mv build/*.deb .

clean:
	rm -rf build *.deb

install: build
	sudo dpkg -i $(APP_NAME)_$(VERSION)_$(ARCH).deb
