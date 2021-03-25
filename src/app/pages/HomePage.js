import { Selector, t } from 'testcafe';

class HomePage {
    constructor () {
        this.addToCartButton= Selector('.shelf-item__buy-btn');
        this.checkoutButton = Selector('.buy-btn');
        this.orderButton    = Selector('#orders');
        this.signInButton   = Selector('#signin');
        const prices        = Selector('.shelf-item__price')
                                .child('.val')
                                .child('b');
    }

    // adds 'quantity' number of devices of 'deviceIndex' type to cart
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

    async getPrice(deviceIndex){
        let price = Number(await prices.nth(deviceIndex).innerText);
        return price
    }
}

export default new HomePage();