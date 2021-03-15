import { Selector, t } from 'testcafe';

class HomePage {
    constructor () {
        this.addToCartButton = Selector('.shelf-item__buy-btn');
        this.checkoutButton = Selector('.buy-btn');
        this.orderButton = Selector('#orders');
        this.signInButton = Selector('#signin');
    }

    async addToCart (deviceIndex, quantity) {

        for(let i=0; i<quantity; i++){
            await t.
            click(this.addToCartButton.nth(deviceIndex));
        }
    } 

    async checkout (){

        await t.
        click(this.checkoutButton);

    }

    async goToOrdersPage (){
        await t.
        click(this.orderButton);

    }
    async goToSignInPage (){
        await t.
        click(this.signInButton);

    }
}

export default new HomePage();