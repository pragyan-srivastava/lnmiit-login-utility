.PHONY: help package clean

help:
	@echo "Available commands:"
	@echo "  make package - Package extension into dist/lnmiit-login-utility.zip"
	@echo "  make clean   - Remove generated zip packages and dist/ folder"

package:
	@mkdir -p dist
	@zip -r dist/lnmiit-login-utility.zip manifest.json popup.html popup.css popup.js background.js content.js images/ -x "*.DS_Store"
	@echo "[SUCCESS] Extension packaged at dist/lnmiit-login-utility.zip"

clean:
	@rm -rf dist/ *.zip
	@echo "[SUCCESS] Cleaned distribution and temporary files."

