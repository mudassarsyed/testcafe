import { Selector } from 'testcafe';
import { userRolesDict } from '../../utils/roles/roles'

fixture("user")
    .page(process.env.TEST_BASE_URL);


test("Login as User with no image loaded", async (t) => {

    // selectorss
    const images        = Selector('img')
    const numberOfItems = await images.count;
    
    // login with credentials
    await t
        .useRole(userRolesDict['image_not_loading_user']);

    // loops through all images on the page and verifies that no image is missing
    for(let i=0; i<numberOfItems-1; i++){
        let img_src   = await images.nth(i).getAttribute('src');
        await t.expect(img_src != "").ok();
    }

    
    })
