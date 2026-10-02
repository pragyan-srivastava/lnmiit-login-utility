
chrome.commands.onCommand.addListener((command) => {
  if (command === "execute_login") {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      if (tabs.length > 0) {
        const tab = tabs[0];
        if (tab.url.startsWith("https://172.22.2.6/connect/PortalMain")) {
          chrome.scripting.executeScript({
            target: { tabId: tab.id },
            files: ["content.js"],
          });
        } else {
          chrome.notifications.create({
            type: "basic",
            iconUrl: "images/icon48.png",
            title: "LNMIIT Login Utility",
            message: "This is not the login page.",
          });
        }
      }
    });
  }
});

chrome.webNavigation.onCompleted.addListener(
  (details) => {
    if (details.url.startsWith("https://172.22.2.6/connect/PortalMain")) {
      chrome.storage.session.get(["notificationShown"], (result) => {
        if (!result.notificationShown) {
          chrome.notifications.create({
            type: "basic",
            iconUrl: "images/icon128.png", // Using a larger icon
            title: "LNMIIT Login Ready",
            message: "Login page detected! Press Alt+L for a lightning-fast login.",
          });
          chrome.storage.session.set({ notificationShown: true });
        }
      });
    }
  },
  {
    url: [{ hostContains: "172.22.2.6" }],
  }
);
