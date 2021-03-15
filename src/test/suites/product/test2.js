import { Selector } from 'testcafe'

fixture("product")
    .page(process.env.TEST_BASE_URL);

test("Apply Apple and Samsung Filters", async (t) => {

    const checkBoxes = Selector('input').withAttribute('value', /^(Apple|Samsung)$/);
    const numberOfCheckboxes = await checkBoxes.count;
    
    const numOfProductsFound = Selector('.products-found')
                                    .child('span');
                                        
        
    //let prevNumber = Number(await numOfProductsFound);
    
        
    for(let i=0; i< numberOfCheckboxes; i++){
        await t.click(checkBoxes.nth(i))
                .expect(checkBoxes.nth(i).checked).ok();
    }
    console.log(await numOfProductsFound.innerText);
        
})

    

