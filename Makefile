PACKAGE = launcherhub
VERSION = 1.0
ARCH = amd64
BUILD_DIR = $(PACKAGE)_$(VERSION)

all: clean build

clean:
	rm -rf $(BUILD_DIR) $(PACKAGE)_$(VERSION).deb

build:
	@echo "==> Building $(PACKAGE) v$(VERSION) .deb"
	mkdir -p $(BUILD_DIR)
	cp -r DEBIAN usr src $(BUILD_DIR)/
	mkdir -p $(BUILD_DIR)/usr/local/bin
	mv $(BUILD_DIR)/src/$(PACKAGE).sh $(BUILD_DIR)/usr/local/bin/$(PACKAGE)
	rm -rf $(BUILD_DIR)/src
	chmod -R 755 $(BUILD_DIR)/DEBIAN
	chmod +x $(BUILD_DIR)/usr/local/bin/$(PACKAGE)
	dpkg-deb --build $(BUILD_DIR)

install:
	@echo "==> Installing package"
	sudo dpkg -i $(PACKAGE)_$(VERSION).deb || sudo apt -f install -y

uninstall:
	@echo "==> Removing package"
	sudo dpkg -r $(PACKAGE)

reinstall: clean build install
