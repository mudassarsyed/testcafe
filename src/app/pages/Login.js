import { Selector, t } from 'testcafe';

class LoginPage {
    constructor () {
        this.userNameInput = Selector('#username');
        this.passwordInput = Selector('#password');
        this.loginButton = Selector('#login-btn');
    }

    async login (userName, password) {
        await t.
        typeText(this.userNameInput, userName).
        pressKey('enter').
        typeText(this.passwordInput, password).
        pressKey('enter').
        click(this.loginButton);
    } 
}

export default new LoginPage();