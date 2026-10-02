#!/usr/bin/env bash
set -e
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
mkdir -p "$DIST_DIR"

ZIP_OUT="$DIST_DIR/lnmiit-login-utility.zip"
echo "Creating release zip at $ZIP_OUT..."
(
    cd "$ROOT_DIR"
    zip -r "$ZIP_OUT" manifest.json popup.html popup.css popup.js background.js content.js images/ -x "*.DS_Store"
)
echo "[SUCCESS] Created: $ZIP_OUT"
