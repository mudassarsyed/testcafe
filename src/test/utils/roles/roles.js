
import { Role, Selector } from 'testcafe';




const locked_user = Role(process.env.TEST_BASE_URL+"signin", async t => {

    const userName              = "locked_user"
    const password              = "testingisfun99"
    const userNameInput         = Selector('#username input');
    const passwordInput         = Selector('#password input');
    const loginButton           = Selector('#login-btn');

    await t
        .typeText(userNameInput,userName)
        .pressKey('enter')
        .typeText(passwordInput,password)
        .pressKey('enter')
        .click(loginButton)
        
});

const image_not_loading_user = Role(process.env.TEST_BASE_URL+"signin", async t => {

    const userName              = "image_not_loading_user"
    const password              = "testingisfun99"
    const userNameInput         = Selector('#username input');
    const passwordInput         = Selector('#password input');
    const loginButton           = Selector('#login-btn');
    await t
        .typeText(userNameInput,userName)
        .pressKey('enter')
        .typeText(passwordInput,password)
        .pressKey('enter')
        .click(loginButton)
});

const existing_orders_user = Role(process.env.TEST_BASE_URL+"signin", async t => {

    const userName              = "existing_orders_user"
    const password              = "testingisfun99"
    const userNameInput         = Selector('#username input');
    const passwordInput         = Selector('#password input');
    const loginButton           = Selector('#login-btn');
    await t
        .typeText(userNameInput,userName)
        .pressKey('enter')
        .typeText(passwordInput,password)
        .pressKey('enter')
        .click(loginButton)
});

const fav_user = Role(process.env.TEST_BASE_URL+"signin", async t => {

    const userName              = "fav_user"
    const password              = "testingisfun99"
    const userNameInput         = Selector('#username input');
    const passwordInput         = Selector('#password input');
    const loginButton           = Selector('#login-btn');

    await t
        .typeText(userNameInput,userName)
        .pressKey('enter')
        .typeText(passwordInput,password)
        .pressKey('enter')
        .click(loginButton)
});



/*
import { createReadStream } from 'fs';
import pkg from 'csv-parse';
var  parse  = pkg;

var logins = {};

createReadStream('./resources/data/Users.csv')
    .pipe(parse({delimiter: ','}))
    .on('data', function(csvrow) {
        console.log(csvrow);
        logins['']
        //csvData.push(csvrow);        
    })
    .on('end',function() {
      //do something with csvData
      //console.log(csvData);
    });
*/

export { locked_user, image_not_loading_user, existing_orders_user, fav_user };
