APP_NAME = launcherhub
VERSION ?= 1.1
ARCH    ?= amd64
DEB_DIR = build/$(APP_NAME)_$(VERSION)_$(ARCH)

.PHONY: all clean build

all: build

build:
	@echo "📦 Building $(APP_NAME) $(VERSION) ..."
	rm -rf build
	mkdir -p $(DEB_DIR)/usr/local/bin
	mkdir -p $(DEB_DIR)/DEBIAN

	# Copy app
	cp launcherhub.sh $(DEB_DIR)/usr/local/bin/$(APP_NAME)
	chmod 755 $(DEB_DIR)/usr/local/bin/$(APP_NAME)

	# Control file
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
