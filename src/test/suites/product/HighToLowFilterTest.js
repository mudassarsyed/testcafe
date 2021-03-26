import { Selector } from 'testcafe'

fixture("product")
    .page(process.env.TEST_BASE_URL);

test("Apply Lowest to Highest Order by Filter", async (t) => {

    // selectors
    const filterSelect  = Selector('.sort')
                            .child('select');
    const lowToHigh     = filterSelect.find('option');
    const prices        = Selector('.shelf-item__price')
                            .child('.val')
                            .child('b');
    const numberOfItems = await prices.count;

    // apply filter to sort by lowest to highest
    await t
        .click(filterSelect)
        .click(lowToHigh.withAttribute('value','lowestprice'));
    
    // loop through all items, verify that prices are in ascending order by checking 
    // price[i] < price[i+1] for all valid i
    for(let i=0; i<numberOfItems-1; i++){
        let cellText        = Number(await prices.nth(i).innerText);
        let compareCellText = Number(await prices.nth(i + 1).innerText);
        await t.expect(cellText <= compareCellText).ok();
    }
    
})
