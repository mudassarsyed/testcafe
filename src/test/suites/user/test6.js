import { Selector } from 'testcafe';
import { existing_orders_user } from '../../utils/roles/roles'

fixture("Click on Sign In button and Login as image_not_loading_user")
    .page(process.env.TEST_BASE_URL);



test("Click on Sign In button and Login as existing_orders_user and click on orders Nav item", async (t) => {

    const ordersNavButton   = Selector('#orders');
    const ordersList        = Selector('.order');
    const ordersCount       = ordersList.count;
    
    await t
        .useRole(existing_orders_user)
        .click(ordersNavButton)
        .expect(ordersCount)
        .gt(0);
    
})

