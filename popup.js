document.addEventListener('DOMContentLoaded', () => {
    const usernameInput = document.getElementById('username');
    const passwordInput = document.getElementById('password');
    const passwordNote = document.getElementById('password-note');
    const saveButton = document.getElementById('save');
    const status = document.getElementById('status');
    const shortcutLink = document.getElementById('shortcut-link');
    const themeCheckbox = document.getElementById('theme-checkbox');

    // --- Theme Switcher Logic ---
    // Function to set the theme
    const setTheme = (isDark) => {
        if (isDark) {
            document.body.classList.add('dark-mode');
            themeCheckbox.checked = true;
        } else {
            document.body.classList.remove('dark-mode');
            themeCheckbox.checked = false;
        }
    };

    // 1. Load saved theme preference
    chrome.storage.local.get('theme', (result) => {
        setTheme(result.theme === 'dark');
    });

    // 2. Add listener for theme toggle
    themeCheckbox.addEventListener('change', () => {
        const isDark = themeCheckbox.checked;
        setTheme(isDark);
        // 3. Save theme preference
        chrome.storage.local.set({ theme: isDark ? 'dark' : 'light' });
    });
    // --- End of Theme Switcher Logic ---

    // Load saved data for credentials
    chrome.storage.local.get(['username', 'password'], (result) => {
        if (result.username) {
            usernameInput.value = result.username;
        }
        if (result.password) {
            passwordNote.textContent = 'Password is saved. Enter a new one to update.';
        } else {
            passwordNote.textContent = 'Your password will be stored securely.';
        }
    });

    saveButton.addEventListener('click', () => {
        const username = usernameInput.value;
        const password = passwordInput.value;

        const dataToSave = { username: username };

        // Only save the password if a new one is entered.
        // This prevents accidentally clearing the password.
        if (password) {
            dataToSave.password = password;
        }

        chrome.storage.local.set(dataToSave, () => {
            status.textContent = 'Credentials saved successfully!';
            passwordInput.value = ''; // Clear password field after saving
            if(dataToSave.password) {
                passwordNote.textContent = 'Password is saved. Enter a new one to update.';
            }
            setTimeout(() => {
                status.textContent = '';
            }, 3000);
        });
    });

    shortcutLink.addEventListener('click', (e) => {
        e.preventDefault();
        chrome.tabs.create({ url: 'chrome://extensions/shortcuts' });
    });
});