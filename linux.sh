#!/bin/sh


# read the env type and suite name from commandline arguments
# the env_type can be "on-prem" or "remote"
# set on-prem to run suite locally, and remote to run on suite browserstack
# set suite name, we have defined different test combinations depending on suite name which cover 
# a broad range of usecases
env_type=$1
suite=$2

# define testcafe location
testcafe="./node_modules/.bin/testcafe"


# set some environment variables which would be common to all tests
common_env(){
    # use Automate API, higher stability, more debug logs
    export BROWSERSTACK_USE_AUTOMATE=1
    # use a lower API polling interval, higher stability
    export TESTCAFE_BROWSERSTACK_API_POLLING_INTERVAL="40000"
    
    # browserstack credentials
    #export BROWSERSTACK_USERNAME=""
    #export BROWSERSTACK_ACCESS_KEY=""

    # set the build name, a build is a logical grouping of tests on the automate dashboard
    time_stamp=$(date +"%Y-%m-%d %H:%M:%S")
    export BROWSERSTACK_BUILD_ID="test-cafe-{$(date +"%Y-%m-%d %H:%M:%S")}"

    # enable/ disable the debugging logs generated
    export BROWSERSTACK_DEBUG="true"
    export BROWSERSTACK_CONSOLE="errors"
    export BROWSERSTACK_VIDEO="true"
    export BROWSERSTACK_NETWORK_LOG="true"


    # we are setting the base url for the tests to run on,
    # we will overwrite this in the `run_local_test` function below 
    # and set it to a "localhost:3000" url to test the browserstack-local feature
    export TEST_BASE_URL="http://bstackdemo.com/"


}


# run a single test on a single browser
run_single_test(){

    # set the common env variables from the `common_env` function defined above
    common_env

    # note the `@browserStack/browserstack:` before the browser name; this is because we are using
    # the browserstack fork of testcafe's browserstack integration
    browser="@browserStack/browserstack:chrome@84.0:Windows 10"

    test_file="src/test/suites/login/test3.js"

    $testcafe $browser $test_file --test-scheduling --reporter spec

}

# run one test on multiple browsers
run_parallel_1t_Nb(){

    
    #browser_list="@browserStack/browserstack:firefox@74.0:OS X High Sierra,@browserStack/browserstack:chrome@80.0:OS X High Sierra,@browserStack/browserstack:ie@11:Windows 10,@browserStack/browserstack:chrome@80.0:Windows 10,@browserStack/browserstack:firefox@75.0:Windows 8.1"
    test_file="src/test/suites/offers/test9.js"


    #$testcafe "$browser_list"  $test_file --test-scheduling --reporter spec
    $testcafe "@browserStack/browserstack:firefox@74.0:OS X High Sierra"  $test_file --test-scheduling --reporter spec &
    $testcafe "@browserStack/browserstack:chrome@80.0:OS X High Sierra"  $test_file --test-scheduling --reporter spec &
    $testcafe "@browserStack/browserstack:firefox@75.0:Windows 8.1"  $test_file --test-scheduling --reporter spec &
    $testcafe "@browserStack/browserstack:Samsung Galaxy S20@10.0"  $test_file --test-scheduling --reporter spec &
    $testcafe "@browserStack/browserstack:iPhone XS@13.0"  $test_file --test-scheduling --reporter spec


}

# run multiple tests concurrently on a single browser
run_parallel_Nt_1b(){

    
    browser="@browserStack/browserstack:firefox@74.0:OS X High Sierra"

    test_file1="src/test/suites/product/test1.js"
    test_file2="src/test/suites/product/test2.js"
    test_file3="src/test/suites/login/test3.js"
    test_file4="src/test/suites/login/test4.js"
    test_file5="src/test/suites/user/test5.js"
    test_file6="src/test/suites/user/test6.js"
    test_file7="src/test/suites/user/test7.js"
    
    $testcafe "$browser"  $test_file1 --test-scheduling &
    $testcafe "$browser"  $test_file2 --test-scheduling &
    $testcafe "$browser"  $test_file3 --test-scheduling &
    $testcafe "$browser"  $test_file4 --test-scheduling &
    $testcafe "$browser"  $test_file5 --test-scheduling &
    $testcafe "$browser"  $test_file6 --test-scheduling &
    $testcafe "$browser"  $test_file7 --test-scheduling &
    

}

start_local()
{
    export BROWSERSTACK_LOCAL_IDENTIFIER="TestCafe"
    # overwrite the base url defined in function `common_env` since we are trying out local-testing
    # local testing allows you to test on internal environments like a locally hosted webapp
    echo "local start"
    # start the local binary
    resources/local/BrowserStackLocal --key $BROWSERSTACK_ACCESS_KEY --local-identifier TestCafe --daemon start;
}

end_local(){
    # wait until all the tests complete
    wait
    echo "local end"
    # close the local binary
    resources/local/BrowserStackLocal --key $BROWSERSTACK_ACCESS_KEY --local-identifier TestCafe --daemon stop;
}


run_geolocation(){
    
    export BROWSERSTACK_CAPABILITIES_CONFIG_PATH="/Users/madhav/Desktop/dev/browserstack-testcafe/resources/conf/caps/browserstack-config.json"


    browser="@browserStack/browserstack:Samsung Galaxy S20 Ultra"
    # the login folder contains all the tests associated with the login fixture
    test_file="src/test/suites/offers/test9.js"

    $testcafe "$browser"  $test_file  --test-scheduling   --reporter spec
}

remote_logic(){

    
    # set the common env variables from the `common_env` function defined above
    # these common environment variables are necesaary for the browerstack plugin
    common_env

    #start local 
    start_local

    if   [ $suite == "single" ]; then
        run_single_test 

    elif [ $suite == "parallel" ]; then
        run_parallel_Nt_1b

    elif [ $suite == "parallel-browsers" ]; then
        run_parallel_1t_Nb

    elif [ $suite == "local" ]; then
        export TEST_BASE_URL="http://localhost:3000/"
        run_single_test 

    elif [ $suite == "local-parallel" ]; then
        export TEST_BASE_URL="http://localhost:3000/"
        run_parallel_Nt_1b

    elif [ $suite == "local-parallel-browsers" ]; then
        export TEST_BASE_URL="http://localhost:3000/"
        run_parallel_1t_Nb

    elif [ $suite == "geolocation" ]; then
        run_geolocation

    else
        echo "invalid suite option; suite should be from (\"single\", \"local\", \"parallel-1\", \"parallel-2\", \"parallel-3\", \"e2e_ip_geolocation\""
    fi

    end_local
}


run_single_test_on_prem(){
    browser="chrome"
    test_file="src/test/suites/product/test2.js"
    $testcafe "$browser"  $test_file  --test-scheduling   --reporter spec
}

run_parallel_1t_Nb_on_prem(){
    browser="all"
    test_file="src/test/suites/login/test4.js"
    $testcafe "$browser"  $test_file  --test-scheduling   --reporter spec
}

run_suite_on_prem(){
    browser="chrome"
    test_file1="src/test/suites/product/test1.js"
    test_file2="src/test/suites/product/test2.js"
    test_file3="src/test/suites/login/test3.js"
    test_file4="src/test/suites/login/test4.js"
    test_file5="src/test/suites/user/test5.js"
    test_file6="src/test/suites/user/test6.js"
    test_file7="src/test/suites/user/test7.js"
    test_file8="src/test/suites/e2e/test8.js"
    test_file9="src/test/suites/offers/test9.js"
    $testcafe "$browser"  $test_file1  --test-scheduling   --reporter spec &&
    $testcafe "$browser"  $test_file2  --test-scheduling   --reporter spec &&
    $testcafe "$browser"  $test_file3  --test-scheduling   --reporter spec &&
    $testcafe "$browser"  $test_file4  --test-scheduling   --reporter spec &&
    $testcafe "$browser"  $test_file5  --test-scheduling   --reporter spec &&
    $testcafe "$browser"  $test_file6  --test-scheduling   --reporter spec &&
    $testcafe "$browser"  $test_file7  --test-scheduling   --reporter spec &&
    $testcafe "$browser"  $test_file8  --test-scheduling   --reporter spec &&
    $testcafe "$browser"  $test_file9  --test-scheduling   --reporter spec 
}


on_prem_logic(){
    common_env

    if   [ $suite == "single" ]; then
        run_single_test_on_prem

    elif [ $suite == "parallel" ]; then
        run_parallel_1t_Nb_on_prem

    elif [ $suite == "suite" ]; then
        run_suite_on_prem

    else
        echo "invalid suite option; suite should be from (\"single\", \"local\", \"parallel-1\", \"parallel-2\", \"parallel-3\", \"e2e_ip_geolocation\""
    fi
}


# launch remote or on-prem tests.
# remote tests would run on browserstack, on-prem tests would launch on the local machine.

if   [ $env_type == "remote" ]; then
    remote_logic suite

elif [ $env_type == "on-prem" ]; then
    on_prem_logic suite

else
    echo "invalid run environment; choose between \"remote\" or \"on-prem\""

fi



