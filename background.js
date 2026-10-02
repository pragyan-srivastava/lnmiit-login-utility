// Background Service Worker for LNMIIT Login Utility

// Command shortcut listener (Default: Alt + L)
chrome.commands.onCommand.addListener((command) => {
  if (command === "execute_login") {
    handleLoginAttempt();
  }
});

// Helper function to trigger login
function handleLoginAttempt() {
  chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
    if (tabs.length === 0) return;
    const tab = tabs[0];
    const isPortalUrl = tab.url && (
      tab.url.startsWith("https://172.22.2.6") || 
      tab.url.startsWith("http://172.22.2.6")
    );

    if (isPortalUrl) {
      chrome.scripting.executeScript({
        target: { tabId: tab.id },
        files: ["content.js"],
      });
    } else {
      chrome.notifications.create({
        type: "basic",
        iconUrl: "images/icon48.png",
        title: "LNMIIT Login Utility",
        message: "Not on the portal page. Open https://172.22.2.6 to log in.",
      });
    }
  });
}

// Automatic detection when captive portal loads
chrome.webNavigation.onCompleted.addListener(
  (details) => {
    // Only act on top-level frame navigation
    if (details.frameId !== 0) return;

    if (details.url && details.url.includes("172.22.2.6/connect/PortalMain")) {
      chrome.storage.local.get(["autoLogin", "username", "password"], (settings) => {
        // If autoLogin is not explicitly false and credentials exist, auto-execute
        const isAutoLoginEnabled = settings.autoLogin !== false;
        const hasCredentials = Boolean(settings.username && settings.password);

        if (isAutoLoginEnabled && hasCredentials) {
          chrome.scripting.executeScript({
            target: { tabId: details.tabId },
            files: ["content.js"],
          });
        }

        // Show session notification only once per browser session
        chrome.storage.session.get(["notificationShown"], (res) => {
          if (!res.notificationShown) {
            chrome.notifications.create({
              type: "basic",
              iconUrl: "images/icon128.png",
              title: "LNMIIT Login Ready",
              message: isAutoLoginEnabled && hasCredentials
                ? "Auto-authenticating your campus WiFi connection..."
                : "Portal detected! Press Alt+L to log in instantly.",
            });
            chrome.storage.session.set({ notificationShown: true });
          }
        });
      });
    }
  },
  {
    url: [{ hostContains: "172.22.2.6" }],
  }
);

// Listen to runtime messages from popup or content script
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === "showNotification") {
    chrome.notifications.create({
      type: "basic",
      iconUrl: "images/icon48.png",
      title: "LNMIIT Login Utility",
      message: request.message || "",
    });
    sendResponse({ status: "ok" });
  } else if (request.action === "openPortal") {
    const portalUrl = "https://172.22.2.6/connect/PortalMain";
    chrome.tabs.query({ url: "*://172.22.2.6/*" }, (tabs) => {
      if (tabs.length > 0) {
        chrome.tabs.update(tabs[0].id, { active: true });
      } else {
        chrome.tabs.create({ url: portalUrl });
      }
    });
    sendResponse({ status: "ok" });
  } else if (request.action === "triggerLogin") {
    handleLoginAttempt();
    sendResponse({ status: "ok" });
  }
  return true;
});
