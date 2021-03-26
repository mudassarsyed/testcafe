import { Selector, ClientFunction } from 'testcafe';
import { userRolesDict } from '../../utils/roles/roles'


fixture("offers")
    .page(process.env.TEST_BASE_URL);


// overwrite the getCurrentPosition func to mock Mumbai's geolocation
const mockGeoLocationForMumbai = ClientFunction(() => {
    window.navigator.geolocation.getCurrentPosition = function(cb){cb({ coords: {accuracy: 20,altitude: null,altitudeAccuracy: null,heading: null,latitude: 1,longitude: 103,speed: null}}); }
});


test("Offers for Mumbai location", async (t) => {

    // selectors
    const offersNavButton   = Selector('#offers');
    const ordersList        = Selector('.offer');
    const offersCount       = ordersList.count;
        
    // sign in 
    await t
        .useRole(userRolesDict['fav_user']);

    // set geolocation to Mumbai
    await mockGeoLocationForMumbai();

    // confirm there are a positive number of offers
    await t
        .click(offersNavButton)
        .expect(offersCount)
        .gt(0);
        
})




