import { Selector, t } from 'testcafe';

class CheckoutPage {
    constructor () {
        this.firstNameInput = Selector('#firstNameInput');
        this.lastNameInput = Selector('#lastNameInput');
        this.addressInput = Selector('#addressLine1Input');
        this.provinceInput = Selector('#provinceInput');
        this.postalCodeInput = Selector('#postCodeInput');
        this.submitButton = Selector('#checkout-shipping-continue');
    }

    async enterAllDetailsAndSubmit (firstName, lastName, address, province, postalCode) {
        await t.
        typeText(this.firstNameInput, firstName).
        typeText(this.lastNameInput, lastName).
        typeText(this.addressInput, address).
        typeText(this.provinceInput, province).
        typeText(this.postalCodeInput, postalCode).
        click(this.submitButton)
        ;
    } 

    async enterDummyDetailsAndSubmit(){

        await this.enterAllDetailsAndSubmit("martian", "martian", "mars", "solarsystem", "0");

    }

}

export default new CheckoutPage();