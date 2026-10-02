document.addEventListener('DOMContentLoaded', () => {
    // DOM Elements
    const usernameInput = document.getElementById('username');
    const passwordInput = document.getElementById('password');
    const savedBadge = document.getElementById('saved-badge');
    const passwordHint = document.getElementById('password-hint');
    const togglePasswordBtn = document.getElementById('toggle-password');
    const eyeIcon = document.getElementById('eye-icon');
    const eyeOffIcon = document.getElementById('eye-off-icon');

    const autoLoginCheckbox = document.getElementById('autologin-checkbox');
    const themeToggleBtn = document.getElementById('theme-toggle');
    const themeSun = document.getElementById('theme-icon-sun');
    const themeMoon = document.getElementById('theme-icon-moon');

    const btnSave = document.getElementById('btn-save');
    const btnLoginNow = document.getElementById('btn-login-now');
    const btnClear = document.getElementById('btn-clear');
    const btnOpenPortal = document.getElementById('btn-open-portal');
    const changeShortcutLink = document.getElementById('change-shortcut');
    const feedbackMsg = document.getElementById('feedback-msg');

    const pulseDot = document.getElementById('pulse-dot');
    const statusLabel = document.getElementById('status-label');

    // 1. Theme Management
    const setTheme = (isDark) => {
        if (isDark) {
            document.body.classList.add('dark-mode');
            themeSun.style.display = 'block';
            themeMoon.style.display = 'none';
        } else {
            document.body.classList.remove('dark-mode');
            themeSun.style.display = 'none';
            themeMoon.style.display = 'block';
        }
    };

    chrome.storage.local.get('theme', (result) => {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        const isDark = result.theme ? result.theme === 'dark' : prefersDark;
        setTheme(isDark);
    });

    themeToggleBtn.addEventListener('click', () => {
        const isCurrentlyDark = document.body.classList.contains('dark-mode');
        const newTheme = !isCurrentlyDark;
        setTheme(newTheme);
        chrome.storage.local.set({ theme: newTheme ? 'dark' : 'light' });
    });

    // 2. Active Tab Status Check
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
        if (tabs && tabs.length > 0) {
            const activeUrl = tabs[0].url || '';
            if (activeUrl.includes('172.22.2.6')) {
                pulseDot.className = 'pulse-dot online';
                statusLabel.textContent = 'Portal Tab Active';
                btnLoginNow.textContent = '⚡ Log In Active Tab';
            } else {
                pulseDot.className = 'pulse-dot';
                statusLabel.textContent = 'Network Standby';
            }
        }
    });

    // 3. Password Visibility Toggle
    togglePasswordBtn.addEventListener('click', () => {
        const isPassword = passwordInput.getAttribute('type') === 'password';
        passwordInput.setAttribute('type', isPassword ? 'text' : 'password');
        eyeIcon.style.display = isPassword ? 'none' : 'block';
        eyeOffIcon.style.display = isPassword ? 'block' : 'none';
    });

    // 4. Load Saved Preferences & Credentials
    chrome.storage.local.get(['username', 'password', 'autoLogin'], (data) => {
        if (data.username) {
            usernameInput.value = data.username;
        }

        if (data.password) {
            savedBadge.classList.add('visible');
            passwordHint.textContent = '•••••••• (Enter new to overwrite)';
        } else {
            savedBadge.classList.remove('visible');
            passwordHint.textContent = 'Stored securely in local browser storage';
        }

        if (typeof data.autoLogin !== 'undefined') {
            autoLoginCheckbox.checked = data.autoLogin;
        } else {
            autoLoginCheckbox.checked = true; // Enabled by default
        }
    });

    // 5. Auto-Login Setting change
    autoLoginCheckbox.addEventListener('change', () => {
        chrome.storage.local.set({ autoLogin: autoLoginCheckbox.checked }, () => {
            showFeedback(
                autoLoginCheckbox.checked ? '⚡ Auto-login enabled' : 'Auto-login disabled (use Alt+L)',
                'success',
                2000
            );
        });
    });

    // 6. Save Credentials Action
    btnSave.addEventListener('click', () => {
        const username = usernameInput.value.trim();
        const password = passwordInput.value;
        const autoLogin = autoLoginCheckbox.checked;

        if (!username) {
            showFeedback('Please enter your Roll / Username', 'error');
            usernameInput.focus();
            return;
        }

        const dataToSave = {
            username: username,
            autoLogin: autoLogin
        };

        if (password) {
            dataToSave.password = password;
        }

        chrome.storage.local.set(dataToSave, () => {
            showFeedback('Credentials saved successfully! ✨', 'success');
            passwordInput.value = '';
            savedBadge.classList.add('visible');
            passwordHint.textContent = '•••••••• (Enter new to overwrite)';
        });
    });

    // 7. Trigger Login Now
    btnLoginNow.addEventListener('click', () => {
        chrome.runtime.sendMessage({ action: 'triggerLogin' }, () => {
            showFeedback('Triggering login...', 'success');
        });
    });

    // 8. Open / Navigate to Portal
    btnOpenPortal.addEventListener('click', () => {
        chrome.runtime.sendMessage({ action: 'openPortal' });
    });

    // 9. Clear Saved Credentials
    btnClear.addEventListener('click', () => {
        if (confirm('Clear saved LNMIIT credentials from this browser?')) {
            chrome.storage.local.remove(['username', 'password'], () => {
                usernameInput.value = '';
                passwordInput.value = '';
                savedBadge.classList.remove('visible');
                passwordHint.textContent = 'Stored securely in local browser storage';
                showFeedback('Credentials cleared', 'success');
            });
        }
    });

    // 10. Configure Shortcuts Link
    changeShortcutLink.addEventListener('click', (e) => {
        e.preventDefault();
        chrome.tabs.create({ url: 'chrome://extensions/shortcuts' });
    });

    // Helper Feedback Toast
    function showFeedback(text, type, duration = 3000) {
        feedbackMsg.textContent = text;
        feedbackMsg.className = `feedback-msg ${type}`;
        setTimeout(() => {
            feedbackMsg.textContent = '';
            feedbackMsg.className = 'feedback-msg';
        }, duration);
    }
});