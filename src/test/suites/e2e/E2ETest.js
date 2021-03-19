import HomePage from '../../../app/pages/HomePage';
import LoginPage from '../../../app/pages/Login';
import CheckoutPage from '../../../app/pages/Checkout';
import ConfirmationPage from '../../../app/pages/Confirmation';


fixture("e2e")
    .page(process.env.TEST_BASE_URL);


test("Click on Sign In button and Login as fav_user ,add 3 items to cart, click on checkout, enter details, click on submit, click on continue shopping and click on orders nav item.", async (t) => {

    const username = 'fav_user';
    const password = 'testingisfun99';

    
    await HomePage.goToSignInPage()
    await LoginPage.login(username, password)
    await HomePage.addToCart(0,3)
    await HomePage.checkout()
    await CheckoutPage.enterDummyDetailsAndSubmit()
    await ConfirmationPage.continueShopping()
    await HomePage.goToOrdersPage();

    })

