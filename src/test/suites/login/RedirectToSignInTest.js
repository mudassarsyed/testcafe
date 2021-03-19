import { Selector } from 'testcafe';


fixture("login")
    .page(process.env.TEST_BASE_URL);

test("Click on favourites Nav Item", async (t) => {


    const favouritesButton = Selector('#favourites');
    const signInButtonExists = Selector('#login-btn').exists;

    await t
        .click(favouritesButton)
        .expect(signInButtonExists)
        .ok('',{ timeout: 10000 });
    })
