# Detailed Installation & Setup Guide

This guide covers all methods to install the **LNMIIT Login Utility** on any Chromium-based browser across Windows, macOS, and Linux.

---

## ⚡ Method 1: Automated 1-Click Installer (Recommended)

We provide native, zero-dependency setup scripts for every operating system.

### For Windows:
1. Download or clone this repository to your computer.
2. Double-click **`install.bat`** (or open PowerShell and run `.\install.ps1`).
3. The script will:
   - Automatically detect Google Chrome, Brave, and Microsoft Edge on your PC.
   - Automatically copy the folder path to your Windows clipboard.
   - Offer to **Quick Launch** your browser with the extension already running, or guide you through a 10-second permanent setup.

### For macOS:
1. Open Terminal and navigate to the cloned folder:
   ```bash
   cd /path/to/lnmiit-login-utility
   ```
2. Make the script executable and run it:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```
3. The script copies the path to macOS clipboard (`pbcopy`), opens `chrome://extensions`, and gives you interactive options.

### For Linux:
1. Run `./install.sh` in your terminal.
2. The script detects installed browsers (`google-chrome`, `brave-browser`, `microsoft-edge`, `chromium`), copies the path via `xclip` or `wl-copy`, and launches the extension page.

---

## 🛠️ Method 2: Manual Installation (30 Seconds)

You can manually load the extension into any Chromium-based browser in 4 simple steps:

### 1. Google Chrome / Chromium
1. Open Chrome and enter `chrome://extensions` in the address bar.
2. In the top-right corner, switch the **Developer mode** toggle to **ON**.
3. In the top-left corner, click **Load unpacked**.
4. Select the `LNMLoginUtility` directory (the folder containing `manifest.json`).
5. The extension is now installed! Pin it to your toolbar by clicking the puzzle icon (🧩) next to the address bar.

### 2. Brave Browser
1. Navigate to `brave://extensions`.
2. Toggle **Developer mode** in the top-right corner.
3. Click **Load unpacked** and select the extension directory.
4. Pin the extension for quick access.

### 3. Microsoft Edge
1. Navigate to `edge://extensions`.
2. In the left sidebar, enable **Developer mode**.
3. Click **Load unpacked** and select the extension folder.

### 4. Arc Browser
1. In Arc, press `Cmd + T` (macOS) or `Ctrl + T` (Windows) and type `arc://extensions`.
2. Toggle **Developer mode** on the top-right.
3. Click **Load unpacked** and select the folder.

### 5. Opera & Opera GX
1. Open `opera://extensions`.
2. Enable **Developer Mode** in the upper-right corner.
3. Click **Load unpacked** and select the folder.

---

## ⚙️ Post-Installation Setup

1. **Click the extension icon** in your toolbar to open the popup.
2. Enter your LNMIIT Roll / Username (e.g. `23ucc001`) and campus network password.
3. Click **Save Credentials**.
4. **Auto-Login:** By default, auto-login is active. When you connect to campus WiFi and open the captive portal (`https://172.22.2.6/connect/PortalMain`), you will be logged in automatically!
5. **Manual Login Shortcut:** You can always trigger an instant login by pressing **`Alt + L`** (or `⌥ + L` on macOS).

---

## ⌨️ Customizing the Keyboard Shortcut

Want to use a different shortcut like `Ctrl+Shift+L` or `Alt+K`?
1. In your browser, navigate to:
   - Chrome: `chrome://extensions/shortcuts`
   - Brave: `brave://extensions/shortcuts`
   - Edge: `edge://extensions/shortcuts`
2. Scroll to **LNMIIT Login Utility**.
3. Click the pencil icon next to **"Trigger automated login"** and press your desired shortcut key combination.

---

## ❓ Troubleshooting

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| **"Manifest file is missing or unreadable"** | You selected the parent folder instead of the folder containing `manifest.json`. | Ensure you select the exact folder containing `manifest.json`. |
| **"Your connection is not private" on 172.22.2.6** | The campus gateway uses a self-signed SSL certificate. | Click **Advanced** and then click **Proceed to 172.22.2.6 (unsafe)**. |
| **Shortcut `Alt+L` does nothing** | You are not on the portal tab, or shortcut is conflicting with another extension. | Check `chrome://extensions/shortcuts` to ensure `Alt+L` is assigned to LNMIIT Login Utility. |
| **Password changed on campus** | Old password still stored. | Open extension popup, enter your new password, and click **Save Credentials**. |
