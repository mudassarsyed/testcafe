import { Selector } from 'testcafe';
import { userRolesDict } from '../../utils/roles/roles'

fixture("user")
    .page(process.env.TEST_BASE_URL);


test("[Wrong Test]Click on Sign In button and Login as image_not_loading_user", async (t) => {

    const images        = Selector('img')
    const numberOfItems = await images.count;
    
    await t
        .useRole(userRolesDict['image_not_loading_user']);

    for(let i=0; i<numberOfItems-1; i++){
        let img_src   = await images.nth(i).getAttribute('src');
        await t.expect(img_src != "").ok();
    }

    
    })
