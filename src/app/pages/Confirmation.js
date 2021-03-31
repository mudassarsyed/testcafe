import { Selector, t } from 'testcafe';

class ConfirmationPage {
    constructor () {
        this.confirmationMessage = Selector('#confirmation-message');
        this.continueShoppingButton = Selector('.continueButtonContainer').
                                        child('a').
                                        child('button');
    }

    async continueShopping () {
        await t.
        click(this.continueShoppingButton);
    } 


}

export default new ConfirmationPage();