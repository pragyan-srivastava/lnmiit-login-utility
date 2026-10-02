# Security & Privacy Architecture

Security and privacy are fundamental requirements for the **LNMIIT Login Utility**. This document details how user credentials are treated, our threat model, and how the extension adheres to the principle of least privilege.

---

## 🛡️ Core Security Principles

### 1. 100% Offline & Zero Telemetry
- The extension **contains no external network calls**, analytics scripts, third-party CDNs, tracking pixels, or remote APIs.
- Your credentials **never leave your local machine**.
- The extension operates strictly in offline sandboxed browser storage.

### 2. Isolated Local Storage
- Credentials (username and password) are stored exclusively in [`chrome.storage.local`](https://developer.chrome.com/docs/extensions/reference/storage/#property-local).
- Data saved in `chrome.storage.local` is:
  - Sandboxed strictly to the LNMIIT Login Utility extension ID.
  - Inaccessible to any other extension, web page, or third-party script.
  - Automatically wiped when the extension is uninstalled or when you click **"Clear"** in the popup.

### 3. Strict Host Permissions
In `manifest.json`, the extension requests host access **only** for the college portal:
```json
"host_permissions": [
  "*://172.22.2.6/*"
]
```
- The extension is **strictly prohibited by browser sandbox rules** from reading, modifying, or interacting with any other websites you visit (such as Google, Gmail, GitHub, banking sites, etc.).
- Your general web browsing history is completely invisible to this utility.

---

## 🔍 Permission Analysis

| Permission | Justification |
| :--- | :--- |
| `storage` | Required to save your Roll Number, password, and preferences (theme, auto-login) locally in `chrome.storage.local`. |
| `activeTab` | Required to interact with the currently active tab when the keyboard shortcut (`Alt+L`) is invoked. |
| `scripting` | Required to execute `content.js` to fill the portal login inputs when `172.22.2.6` is open. |
| `notifications` | Required to show desktop toasts when the portal is ready or when credentials are saved. |
| `webNavigation` | Required to detect when the captive portal URL (`172.22.2.6/connect/PortalMain`) finishes loading so auto-login can trigger. |
| `*://172.22.2.6/*` | Restricts content script injection exclusively to the LNMIIT captive portal IP address. |

---

## 🧪 Open Source Auditability

Because this extension is completely open-source:
- You and anyone in the LNMIIT community can inspect every single line of code in this repository before installing.
- There are no minified or obfuscated bundles — the code you read is the exact code your browser executes.
- If you notice any security vulnerability, please report it via GitHub Issues or submit a Pull Request.
