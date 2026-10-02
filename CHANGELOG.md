# Changelog

All notable changes to the **LNMIIT Login Utility** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.2.0] - 2026-10-02

### Added
- **⚡ Zero-Click Auto-Login**: Option to automatically submit credentials the instant `172.22.2.6/connect/PortalMain` is detected.
- **🚀 One-Click Installers**:
  - `install.bat`: Native double-clickable Windows installer with automatic browser detection, clipboard auto-copy, and direct launch.
  - `install.ps1`: Interactive PowerShell installer with rich terminal output and smart browser loading.
  - `install.sh`: Native macOS (`pbcopy`) and Linux (`xclip`/`wl-copy`) installer.
- **🎨 Glassmorphic Modern UI**: Complete overhaul of the popup interface with Plus Jakarta Sans typography, sleek card layout, and smooth animations.
- **👁️ Password Visibility Toggle**: Eye button to easily inspect entered password before saving.
- **🟢 Active Tab Status Detection**: Live status badge in popup indicating whether the active tab is on the captive portal.
- **🚀 Quick Portal Opener**: One-click button inside the extension to jump straight to the captive portal.
- **✨ On-Page Feedback HUD**: Modern floating pill on the captive portal page providing real-time login status feedback.
- **🗑️ Reset Credentials**: Clear saved data safely with confirmation.
- **📦 Release Packaging**: Automated packaging scripts (`scripts/package.bat`, `scripts/package.sh`, `scripts/package.ps1`).

### Changed
- Upgraded manifest host permissions to `*://172.22.2.6/*` for enhanced reliability.
- Improved input event dispatching (`input`, `change`) in `content.js` to ensure campus portal compatibility.
- Upgraded dark/light theme switching with smooth transitions and SVG sun/moon icons.

---

## [1.0.0] - Initial Release

### Added
- Core Manifest V3 extension architecture.
- Shortcut-based login (`Alt+L`) for `172.22.2.6`.
- Local credential storage in `chrome.storage.local`.
- Basic light/dark mode switch.
- Notification alerts on captive portal detection.
