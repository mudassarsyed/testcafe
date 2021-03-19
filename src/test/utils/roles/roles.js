
import { Role, Selector } from 'testcafe';
import { readFile } from 'fs';


// generates 'Roles' based on user login data in the Users.json. Roles is a 
// concept in TestCafe that helps abstract away authentication workflows
// In this case, we are creating a map `userRolesDict` of roles. This
// key of `userRolesDict` is the username and the corresponding value 
// is the password
// we then export this dictionary and use the roles for authentication
var userRolesDict = {};
readFile('resources/data/Users.json', (err, data) => {

    if (err) throw err;

    const userNameInput         = Selector('#username input');
    const passwordInput         = Selector('#password input');
    const loginButton           = Selector('#login-btn');

    let passwords = JSON.parse(data);

    Object.keys(passwords).forEach(function(username) {

        userRolesDict[username] = Role(process.env.TEST_BASE_URL+"signin", async t => {
            await t
                .typeText(userNameInput,username)
                .pressKey('enter')
                .typeText(passwordInput,passwords[username])
                .pressKey('enter')
                .click(loginButton)
        });
    })
});


export { userRolesDict };
