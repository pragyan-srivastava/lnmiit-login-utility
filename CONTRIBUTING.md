# Contributing to LNMIIT Login Utility

Thank you for your interest in improving the **LNMIIT Login Utility**! 🚀

This project is built by LNMIITians for LNMIITians to make campus network life effortless. We welcome all contributions — whether it's reporting a bug, suggesting a new feature, improving documentation, or submitting code.

---

## 🌟 How You Can Help

1. **Star the Repository**: Help more students discover this tool by starring it on GitHub!
2. **Report Bugs**: Encountered an issue with the captive portal or extension? [Open an issue](https://github.com/pragyan-srivastava/lnmiit-login-utility/issues).
3. **Suggest Features**: Have ideas to make login even faster or add cool widgets? Let us know!
4. **Submit Pull Requests**: Implement improvements or fixes.

---

## 🛠️ Local Development Setup

No build tools, compilation, or npm installs are required! Everything is pure, lightweight Vanilla JavaScript, HTML5, and CSS3.

### 1. Fork & Clone
```bash
git clone https://github.com/<your-username>/lnmiit-login-utility.git
cd lnmiit-login-utility
```

### 2. Load Extension in Browser
1. Open Chrome/Brave/Edge and navigate to `chrome://extensions`.
2. Enable **Developer mode** (top-right toggle switch).
3. Click **Load unpacked** (top-left).
4. Select the project repository directory.

### 3. Making Changes
- Modifying `popup.html`, `popup.css`, or `popup.js`: Reopen the popup to see changes instantly.
- Modifying `manifest.json`, `background.js`, or `content.js`: Click the **Reload (↻)** icon on the extension card in `chrome://extensions`.

---

## 📁 Repository Structure

```
├── manifest.json         # Extension manifest (v3)
├── popup.html            # Extension popup UI structure
├── popup.css             # Extension styling & theme tokens
├── popup.js              # Extension popup controller & storage
├── background.js         # Service worker: shortcuts & navigation hooks
├── content.js            # Injected script: DOM autofill & login trigger
├── scripts/
│   ├── package.bat       # Windows packaging script
│   ├── package.ps1       # PowerShell release packager
│   └── package.sh        # POSIX bash release packager
├── docs/
│   └── SECURITY.md       # Security & privacy audit documentation
└── images/               # Extension icons and assets
```

---

## 📝 Pull Request Guidelines

1. Create a feature branch:
   ```bash
   git checkout -b feature/awesome-feature
   ```
2. Commit your changes with clear, descriptive commit messages:
   ```bash
   git commit -m "feat: add automatic retry when captive portal times out"
   ```
3. Push to your fork:
   ```bash
   git push origin feature/awesome-feature
   ```
4. Open a Pull Request against the `main` branch of this repository.

---

## 🔒 Security Notes

Since this extension handles campus credentials, security is paramount:
- **Never** introduce remote API calls, analytics, or external script CDNs.
- All credentials must remain strictly inside `chrome.storage.local`.
- Any external dependency will be rejected.

---

Thank you for contributing! 🎓
