.PHONY: help package install-mac install-windows clean lint

# Default target
help:
	@echo "====================================================="
	@echo "           LNMIIT Login Utility - Makefile            "
	@echo "====================================================="
	@echo "Available commands:"
	@echo "  make package         - Package extension into dist/lnmiit-login-utility.zip"
	@echo "  make install-mac     - Run macOS / Linux installer script"
	@echo "  make install-windows - Run Windows PowerShell installer script"
	@echo "  make clean           - Remove generated zip packages and dist/ folder"
	@echo "====================================================="

package:
	@mkdir -p dist
	@zip -r dist/lnmiit-login-utility.zip manifest.json popup.html popup.css popup.js background.js content.js images/ -x "*.DS_Store"
	@echo "[SUCCESS] Extension packaged at dist/lnmiit-login-utility.zip"

install-mac:
	@chmod +x install.sh
	@./install.sh

install-windows:
	@powershell -NoProfile -ExecutionPolicy Bypass -File ./install.ps1

clean:
	@rm -rf dist/ *.zip
	@echo "[SUCCESS] Cleaned distribution and temporary files."
