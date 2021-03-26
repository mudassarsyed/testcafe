import { Selector } from 'testcafe';

fixture("login")
    .page(process.env.TEST_BASE_URL);

test("Click on Sign In button and Login as locked_user", async (t) => {

    // selectors
    const userName             = "locked_user";
    const password             = "testingisfun99";
    const signInButton         = Selector('#signin');
    const userNameInput        = Selector('#username input');
    const passwordInput        = Selector('#password input');
    const loginButton          = Selector('#login-btn');
    const errorMessage         = Selector('.api-error');
    const expectedErrorMessage = "Your account has been locked.";
     
    // test
    // Note: could have used `roles` here for login too.
    await t
        .click(signInButton)
        .typeText(userNameInput,userName)
        .pressKey('enter')
        .typeText(passwordInput,password)
        .pressKey('enter')
        .click(loginButton)
        .expect(errorMessage.innerText)
        .eql(expectedErrorMessage);

})





