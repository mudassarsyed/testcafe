import { Selector } from 'testcafe';
import { userRolesDict } from '../../utils/roles/roles'

fixture("user")
    .page(process.env.TEST_BASE_URL);



test("This test verifies that existing orders are shown for user: \"existing_orders_user\"", async (t) => {

    // selectors
    const ordersNavButton   = Selector('#orders');
    const ordersList        = Selector('.order');
    const ordersCount       = ordersList.count;
    
    // test
    await t
        .useRole(userRolesDict['existing_orders_user'])
        .click(ordersNavButton)
        .expect(ordersCount)
        .gt(0);
    
})

