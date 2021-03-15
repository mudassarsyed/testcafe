import { Selector } from 'testcafe';
import { existing_orders_user } from '../../utils/roles/roles'

fixture("Click on Sign In button and Login as image_not_loading_user")
    .page(process.env.TEST_BASE_URL);

    
test("Click on Sign In button and Login as existing_orders_user, add items to favourite and click on favourites Nav Item", async (t) => {


    const favouriteButton       = Selector(".shelf-stopper")
                                    .child("button");
    const favouritesNavButton   = Selector('#favourites');
    const favouriteList         = Selector('.shelf-item');
    const favouriteCount        = favouriteList.count;

    await t
        .useRole(existing_orders_user)
        .click(favouriteButton.with({ visibilityCheck: true })())
        .click(favouritesNavButton)
        .expect(favouriteCount)
        .gt(0);

})

