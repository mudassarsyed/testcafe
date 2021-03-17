import { Selector } from 'testcafe'

fixture("product")
    .page(process.env.TEST_BASE_URL);

test("Apply Apple and Samsung Filters", async (t) => {


    await t.wait(2000);
    const checkBoxes = Selector('input').withAttribute('value', /^(Apple|Samsung)$/);
    const numberOfCheckboxes = await checkBoxes.count;
    
    const numOfProductsFound = Selector('.products-found')
                                    .child('span');
                                        
    
    var prevNumberString = await numOfProductsFound.innerText;
    const prevNumber = Number( prevNumberString.split(" ")[0]);
    
        
    for(let i=0; i< numberOfCheckboxes; i++){
        await t.click(checkBoxes.nth(i))
                .expect(checkBoxes.nth(i).checked).ok();
    }

    //await t.wait(2000);
    var newNumberString = await numOfProductsFound.innerText;
    const newNumber = Number(newNumberString.split(" ")[0]);

    await t
    .expect(newNumber <= prevNumber).ok()

    //console.log(prevNumber);
    console.log(newNumber);
        
})

    

