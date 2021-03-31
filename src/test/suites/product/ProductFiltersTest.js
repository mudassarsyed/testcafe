import { Selector } from 'testcafe'

fixture("product")
    .page(process.env.TEST_BASE_URL);

test("Apply Apple and Samsung Filters", async (t) => {

    // As of now this test is set to filter by apple or samsung
    // to filter for any other device manufacturers modify the regex for the `checkBoxes` selector
    const checkBoxes = Selector('input',{ timeout: 3000 }).withAttribute('value', /^(Apple|Samsung)$/);
    const numberOfCheckboxes = await checkBoxes.count;
    
    const numOfProductsFound = Selector('.products-found')
                                    .child('span');
                                        
    // store the number of products before applying the manufacturer filters
    // the .split("")[0] is to discard the '$' sign in the price listing and 
    // to only store the numeric values
    var prevNumberString = await numOfProductsFound.innerText;
    const prevNumber = Number( prevNumberString.split(" ")[0]);
    
        
    // now loop all the checkboxes which were selected by the `checkBoxes` selector
    // and check them
    for(let i=0; i< numberOfCheckboxes; i++){
        await t.click(checkBoxes.nth(i))
                .expect(checkBoxes.nth(i).checked).ok();
    }

    // now record the new number of products in the listing affter applying the filters
    var newNumberString = await numOfProductsFound.innerText;
    const newNumber = Number(newNumberString.split(" ")[0]);

    // verify that after applying the manufacturer products, the number of products 
    // decrease
    await t
    .expect(newNumber <= prevNumber).ok()

        
})

    

