import { Selector, t } from 'testcafe';

class OrdersPage {
    constructor () {
        this.ordersList    = Selector('.a-fixed-right-grid-inner.a-grid-vertical-align.a-grid-top');
        
    }

    async verifyNumberOfOrdersGreaterThan ( threshold ) {

        this.ordersCount   = this.ordersList.count;

        await t
        .expect(this.ordersCount)
        .gt(threshold);
    } 
}

export default new OrdersPage();