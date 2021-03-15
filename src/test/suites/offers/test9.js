import { Selector } from 'testcafe';


fixture("login")
    .page("http://bstackdemo.com/");


test("Click on Sign In button and Login as existing_orders_user and click on orders Nav item", async (t) => {

    const userName          = "fav_user";
    const password          = "testingisfun99";
    const signInButton      = Selector('#signin');
    const userNameInput     = Selector('#username input');
    const passwordInput     = Selector('#password input');
    const loginButton       = Selector('#login-btn');
    const offersNavButton   = Selector('#offers');
    const ordersList        = Selector('.offer');
    const offersCount       = ordersList.count;
        
    await t
        .click(signInButton)
        .typeText(userNameInput,userName)
        .pressKey('enter')
        .typeText(passwordInput,password)
        .pressKey('enter')
        .click(loginButton)
        .click(offersNavButton)
        .expect(offersCount)
        .gt(0);
        
})




