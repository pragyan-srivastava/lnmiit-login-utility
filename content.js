chrome.storage.local.get(['username', 'password'], (result) => {
    if (result.username && result.password) {
        const usernameField = document.getElementById('LoginUserPassword_auth_username');
        const passwordField = document.getElementById('LoginUserPassword_auth_password');
        const loginButton = document.getElementById('UserCheck_Login_Button');

        if (usernameField && passwordField && loginButton) {
            usernameField.value = result.username;
            passwordField.value = result.password;

            // Clicking the button is a more user-like interaction
            loginButton.click();
        } else {
            // As a fallback, try to execute the form submission script directly.
            // This requires injecting a script into the page's context.
            const script = document.createElement('script');
            script.textContent = `
                var usernameField = document.getElementById('LoginUserPassword_auth_username');
                var passwordField = document.getElementById('LoginUserPassword_auth_password');
                if (usernameField && passwordField) {
                    usernameField.value = "${result.username}";
                    passwordField.value = "${result.password}";
                    if (typeof oAuthentication !== 'undefined' && typeof oAuthentication.submitActiveForm === 'function') {
                        oAuthentication.submitActiveForm();
                    }
                }
            `;
            (document.head || document.documentElement).appendChild(script);
            script.remove();
        }
    } else {
        // Notify the user that credentials are not set
        chrome.runtime.sendMessage({
            action: "showNotification",
            message: "Username or password not set in the extension."
        });
    }
});
