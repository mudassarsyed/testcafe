import { Selector } from 'testcafe';
import { ClientFunction } from 'testcafe';


fixture("login")
    .page(process.env.TEST_BASE_URL);

test("Click on favourites Nav Item", async (t) => {


    const favouritesButton = Selector('#favourites');
    const URL = process.env.TEST_BASE_URL+'signin?favourites=true';
    const getURL = ClientFunction(() => window.location.href);

    await t
        .click(favouritesButton)
        .expect(getURL())
        .eql(URL);
    })
