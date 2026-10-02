// Content Script injected into the LNMIIT Network Portal page

(function () {
  // Prevent duplicate execution if already running
  if (window.__lnmiit_login_running) return;
  window.__lnmiit_login_running = true;

  // Show a modern, floating HUD status badge on the page
  function showStatusToast(message, type = "info") {
    let toast = document.getElementById("lnmiit-status-toast");
    if (!toast) {
      toast = document.createElement("div");
      toast.id = "lnmiit-status-toast";
      toast.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999999;
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 12px 20px;
        background: rgba(15, 23, 42, 0.95);
        color: #ffffff;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        font-size: 14px;
        font-weight: 500;
        border-radius: 12px;
        box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3), 0 8px 10px -6px rgba(0, 0, 0, 0.3);
        border: 1px solid rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(8px);
        transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        transform: translateY(-10px);
        opacity: 0;
      `;
      document.body.appendChild(toast);
      requestAnimationFrame(() => {
        toast.style.transform = "translateY(0)";
        toast.style.opacity = "1";
      });
    }

    const icon = type === "success" ? "✅" : type === "error" ? "⚠️" : "⚡";
    const accentColor = type === "success" ? "#10b981" : type === "error" ? "#ef4444" : "#6366f1";
    toast.innerHTML = `<span style="font-size: 16px;">${icon}</span> <span style="color: ${accentColor}; font-weight: 600;">LNMIIT Utility:</span> ${message}`;

    if (type === "success" || type === "error") {
      setTimeout(() => {
        toast.style.transform = "translateY(-15px)";
        toast.style.opacity = "0";
        setTimeout(() => toast.remove(), 400);
      }, 3500);
    }
  }

  chrome.storage.local.get(["username", "password"], (result) => {
    if (result.username && result.password) {
      showStatusToast("Authenticating credentials...", "info");

      // Attempt to find fields by canonical IDs first, fallback to generic selectors
      const usernameField =
        document.getElementById("LoginUserPassword_auth_username") ||
        document.querySelector('input[name*="user" i]') ||
        document.querySelector('input[type="text"]');

      const passwordField =
        document.getElementById("LoginUserPassword_auth_password") ||
        document.querySelector('input[type="password"]');

      const loginButton =
        document.getElementById("UserCheck_Login_Button") ||
        document.querySelector('input[type="submit"]') ||
        document.querySelector('button[type="submit"]') ||
        document.querySelector("#loginButton");

      if (usernameField && passwordField) {
        usernameField.value = result.username;
        usernameField.dispatchEvent(new Event("input", { bubbles: true }));
        usernameField.dispatchEvent(new Event("change", { bubbles: true }));

        passwordField.value = result.password;
        passwordField.dispatchEvent(new Event("input", { bubbles: true }));
        passwordField.dispatchEvent(new Event("change", { bubbles: true }));

        if (loginButton) {
          showStatusToast("Credentials verified. Logging in...", "success");
          setTimeout(() => {
            loginButton.click();
            window.__lnmiit_login_running = false;
          }, 200);
        } else {
          // Fallback if button element isn't directly clickable
          executeScriptFallback(result.username, result.password);
        }
      } else {
        // Fallback injection directly into page context
        executeScriptFallback(result.username, result.password);
      }
    } else {
      showStatusToast("Please save your credentials in extension settings!", "error");
      chrome.runtime.sendMessage({
        action: "showNotification",
        message: "No credentials saved. Please click the LNMIIT extension icon to save them.",
      });
      window.__lnmiit_login_running = false;
    }
  });

  function executeScriptFallback(user, pass) {
    try {
      const script = document.createElement("script");
      script.textContent = `
        (function() {
          var u = document.getElementById('LoginUserPassword_auth_username');
          var p = document.getElementById('LoginUserPassword_auth_password');
          if (u && p) {
            u.value = ${JSON.stringify(user)};
            p.value = ${JSON.stringify(pass)};
            if (typeof oAuthentication !== 'undefined' && typeof oAuthentication.submitActiveForm === 'function') {
              oAuthentication.submitActiveForm();
            } else {
              var btn = document.getElementById('UserCheck_Login_Button');
              if (btn) btn.click();
            }
          }
        })();
      `;
      (document.head || document.documentElement).appendChild(script);
      script.remove();
      showStatusToast("Credentials submitted via fallback!", "success");
    } catch (e) {
      showStatusToast("Failed to auto-submit form.", "error");
    } finally {
      window.__lnmiit_login_running = false;
    }
  }
})();
