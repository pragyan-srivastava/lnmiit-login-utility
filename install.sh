#!/usr/bin/env bash
# ==============================================================================
# LNMIIT Login Utility - Quick Setup & Launcher (macOS & Linux)
# ==============================================================================

set -e

# Resolve directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Styling
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m' # No Color

clear 2>/dev/null || true
echo -e "${CYAN}=====================================================================${NC}"
echo -e "${YELLOW}${BOLD}     LNMIIT LOGIN UTILITY - ONE-CLICK INSTALLER (macOS & Linux)      ${NC}"
echo -e "${CYAN}=====================================================================${NC}"
echo ""
echo -e " [i] Extension Directory: ${GREEN}${SCRIPT_DIR}${NC}"

# Detect OS
OS_NAME="$(uname -s)"
CLIP_SUCCESS=false

# Copy path to clipboard
if [ "$OS_NAME" = "Darwin" ]; then
    if command -v pbcopy >/dev/null 2>&1; then
        echo -n "$SCRIPT_DIR" | pbcopy
        CLIP_SUCCESS=true
    fi
elif [ "$OS_NAME" = "Linux" ]; then
    if command -v xclip >/dev/null 2>&1; then
        echo -n "$SCRIPT_DIR" | xclip -selection clipboard
        CLIP_SUCCESS=true
    elif command -v wl-copy >/dev/null 2>&1; then
        echo -n "$SCRIPT_DIR" | wl-copy
        CLIP_SUCCESS=true
    fi
fi

if [ "$CLIP_SUCCESS" = true ]; then
    echo -e " [✔] ${GREEN}Extension path automatically copied to clipboard!${NC}"
else
    echo -e " [!] ${GRAY}Clipboard tool not available; you can copy the path manually.${NC}"
fi

echo ""

# Detect installed browsers
CHROME_BIN=""
BRAVE_BIN=""
EDGE_BIN=""

if [ "$OS_NAME" = "Darwin" ]; then
    [ -d "/Applications/Google Chrome.app" ] && CHROME_BIN="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    [ -d "/Applications/Brave Browser.app" ] && BRAVE_BIN="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
    [ -d "/Applications/Microsoft Edge.app" ] && EDGE_BIN="/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
else
    # Linux
    CHROME_BIN="$(command -v google-chrome || command -v google-chrome-stable || true)"
    BRAVE_BIN="$(command -v brave-browser || command -v brave || true)"
    EDGE_BIN="$(command -v microsoft-edge || command -v microsoft-edge-stable || true)"
fi

echo -e "${BOLD}Detected Browsers:${NC}"
[ -n "$CHROME_BIN" ] && echo -e "  - Google Chrome: ${GREEN}Found${NC}" || echo -e "  - Google Chrome: ${GRAY}Not found${NC}"
[ -n "$BRAVE_BIN" ]  && echo -e "  - Brave Browser: ${GREEN}Found${NC}" || echo -e "  - Brave Browser: ${GRAY}Not found${NC}"
[ -n "$EDGE_BIN" ]   && echo -e "  - Microsoft Edge: ${GREEN}Found${NC}" || echo -e "  - Microsoft Edge: ${GRAY}Not found${NC}"

echo ""
echo -e "${CYAN}Choose an option:${NC}"
echo -e "  ${YELLOW}[1]${NC} Guided Setup: Open Extensions page (Recommended)"
echo -e "  ${YELLOW}[2]${NC} Quick Launch: Start Chrome with extension preloaded"
echo -e "  ${YELLOW}[3]${NC} Quick Launch: Start Brave with extension preloaded"
echo -e "  ${YELLOW}[4]${NC} Quick Launch: Start Edge with extension preloaded"
echo -e "  ${YELLOW}[5]${NC} Package into release .zip file"
echo -e "  ${YELLOW}[6]${NC} Exit"
echo ""

read -p "Enter choice (1-6) [default: 1]: " choice
choice="${choice:-1}"

case "$choice" in
    1)
        clear 2>/dev/null || true
        echo -e "${CYAN}=====================================================================${NC}"
        echo -e "${YELLOW}${BOLD}              PERMANENT INSTALLATION (3 QUICK STEPS)                 ${NC}"
        echo -e "${CYAN}=====================================================================${NC}"
        echo ""
        echo -e "  Step 1: Your browser extensions page is opening now..."
        echo -e "  Step 2: Turn ${BOLD}ON${NC} \"Developer mode\" (top-right toggle switch)."
        echo -e "  Step 3: Click \"${BOLD}Load unpacked${NC}\" (top-left button)."
        if [ "$OS_NAME" = "Darwin" ]; then
            echo -e "  Step 4: In the open dialog, press ${BOLD}${GREEN}Cmd + Shift + G${NC}, press ${BOLD}${GREEN}Cmd + V${NC}, and hit Enter!"
        else
            echo -e "  Step 4: Press ${BOLD}${GREEN}Ctrl + V${NC} into the folder path and press Enter!"
        fi
        echo ""
        echo -e "  ${GRAY}Path copied on clipboard: ${SCRIPT_DIR}${NC}"
        echo -e "${CYAN}=====================================================================${NC}"
        echo ""

        if [ "$OS_NAME" = "Darwin" ]; then
            if [ -n "$CHROME_BIN" ]; then
                open -a "Google Chrome" "chrome://extensions"
            elif [ -n "$BRAVE_BIN" ]; then
                open -a "Brave Browser" "brave://extensions"
            elif [ -n "$EDGE_BIN" ]; then
                open -a "Microsoft Edge" "edge://extensions"
            else
                open "chrome://extensions" || true
            fi
        else
            if [ -n "$CHROME_BIN" ]; then
                "$CHROME_BIN" "chrome://extensions" &
            elif [ -n "$BRAVE_BIN" ]; then
                "$BRAVE_BIN" "brave://extensions" &
            elif [ -n "$EDGE_BIN" ]; then
                "$EDGE_BIN" "edge://extensions" &
            else
                xdg-open "chrome://extensions" 2>/dev/null || true
            fi
        fi
        ;;
    2)
        if [ -n "$CHROME_BIN" ]; then
            echo -e "${GREEN}Launching Chrome with LNMIIT Login Utility...${NC}"
            "$CHROME_BIN" --load-extension="$SCRIPT_DIR" "https://172.22.2.6/connect/PortalMain" &
        else
            echo -e "${RED}Google Chrome not found.${NC}"
        fi
        ;;
    3)
        if [ -n "$BRAVE_BIN" ]; then
            echo -e "${GREEN}Launching Brave with LNMIIT Login Utility...${NC}"
            "$BRAVE_BIN" --load-extension="$SCRIPT_DIR" "https://172.22.2.6/connect/PortalMain" &
        else
            echo -e "${RED}Brave Browser not found.${NC}"
        fi
        ;;
    4)
        if [ -n "$EDGE_BIN" ]; then
            echo -e "${GREEN}Launching Edge with LNMIIT Login Utility...${NC}"
            "$EDGE_BIN" --load-extension="$SCRIPT_DIR" "https://172.22.2.6/connect/PortalMain" &
        else
            echo -e "${RED}Microsoft Edge not found.${NC}"
        fi
        ;;
    5)
        DIST_DIR="$SCRIPT_DIR/dist"
        mkdir -p "$DIST_DIR"
        ZIP_PATH="$DIST_DIR/lnmiit-login-utility.zip"
        echo -e "${CYAN}Packaging extension into ${ZIP_PATH}...${NC}"
        (
            cd "$SCRIPT_DIR"
            zip -r "$ZIP_PATH" manifest.json popup.html popup.css popup.js background.js content.js images/ -x "*.DS_Store"
        )
        echo -e " [✔] ${GREEN}Created ${ZIP_PATH} successfully!${NC}"
        ;;
    *)
        echo "Exiting."
        ;;
esac
