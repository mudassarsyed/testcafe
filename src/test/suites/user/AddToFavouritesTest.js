import { Selector } from 'testcafe';
import { userRolesDict } from '../../utils/roles/roles'

fixture("user")
    .page(process.env.TEST_BASE_URL);

    
test("add items to favourite and click on favourites Nav Item", async (t) => {

    // selectors
    const favouriteButton       = Selector(".shelf-stopper")
                                    .child("button");
    const favouritesNavButton   = Selector('#favourites');
    const favouriteList         = Selector('.shelf-item');
    const favouriteCount        = favouriteList.count;

    // test
    await t
        .useRole(userRolesDict['existing_orders_user'])
        .click(favouriteButton.with({ visibilityCheck: true })())
        .click(favouritesNavButton)
        .expect(favouriteCount)
        .gt(0);

})

