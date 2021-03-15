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
    export BROWSERSTACK_USERNAME=""
    export BROWSERSTACK_ACCESS_KEY=""

    # set the build name, a build is a logical grouping of tests on the automate dashboard
    export BROWSERSTACK_BUILD_ID="test-cafe"

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

    common_env
    browser_list="@browserStack/browserstack:firefox@74.0:OS X High Sierra,@browserStack/browserstack:chrome@80.0:OS X High Sierra,@browserStack/browserstack:ie@11:Windows 10,@browserStack/browserstack:chrome@80.0:Windows 10,@browserStack/browserstack:firefox@75.0:Windows 8.1"
    test_file="src/test/suites/login/test3.js"
    num_parallels=4


    #$testcafe "$browser_list"  $test_file --test-scheduling --reporter spec
    $testcafe "@browserStack/browserstack:firefox@74.0:OS X High Sierra"  $test_file --test-scheduling --reporter spec &
    $testcafe "@browserStack/browserstack:chrome@80.0:OS X High Sierra"  $test_file --test-scheduling --reporter spec &
    $testcafe "@browserStack/browserstack:ie@11:Windows 10"  $test_file --test-scheduling --reporter spec &
    $testcafe "@browserStack/browserstack:firefox@75.0:Windows 8.1"  $test_file --test-scheduling --reporter spec


}

# run multiple tests concurrently on a single browser
run_parallel_Nt_1b(){

    common_env
    browser="@browserStack/browserstack:firefox@74.0:OS X High Sierra"

    test_file1="src/test/suites/login/test3.js"
    test_file2="src/test/suites/login/test4.js"
    test_file3="src/test/suites/product/test1.js"

    max_parallels=3
    
    $testcafe "$browser"  $test_file1 $test_file2 $test_file3 -c $max_parallels --test-scheduling

}

# run all tests in a fixture concurrently on a single browser
run_parallel_fixture_1b(){

    common_env
    browser="@browserStack/browserstack:firefox@74.0:OS X High Sierra"

    # the login folder contains all the tests associated with the login fixture
    fixture="src/test/suites/user/*"
    
    max_parallels=3

    $testcafe "$browser"  $fixture -c $max_parallels --test-scheduling

}


start_local()
{
    resources/local/BrowserStackLocal --key $BROWSERSTACK_ACCESS_KEY --local-identifier TestCafe --daemon start;
}

end_local(){
    resources/local/BrowserStackLocal --key $BROWSERSTACK_ACCESS_KEY --local-identifier TestCafe --daemon stop;
}

# run a test with local testing enabled
run_local_test(){
    common_env

    export BROWSERSTACK_LOCAL_IDENTIFIER="TestCafe"


    # overwrite the base url defined in function `common_env` since we are trying out local-testing
    # local testing allows you to test on internal environments like a locally hosted webapp
    export TEST_BASE_URL="http://localhost:3000/"

    # the `start_local` function defined above, starts the local binary. 
    start_local


    browser="@browserStack/browserstack:chrome@84.0:Windows 10"
    test_file="src/test/suites/login/test3.js"

    $testcafe $browser  $test_file --test-scheduling
    
    # the `end_local` function defined above, stops the local binary. 
    # stopping the binary is extremely important, an unclosed binary can interfere with future
    # test executions
    end_local

}

run_ip_geolocation(){

    export BROWSERSTACK_GEO_LOCATION="IN"

    browser="@browserStack/browserstack:firefox@74.0:OS X High Sierra"

    # the login folder contains all the tests associated with the login fixture
    test_file="src/test/suites/offers/test9.js"

    $testcafe "$browser"  $test_file  --test-scheduling   --reporter spec
}

remote_logic(){

    # set the common env variables from the `common_env` function defined above
    # these common environment variables are necesaary for the browerstack plugin
    common_env

    if   [ $suite == "single" ]; then
        run_single_test 

    elif [ $suite == "local" ]; then
        run_local_test

    elif [ $suite == "parallel-1" ]; then
        run_parallel_1t_Nb

    elif [ $suite == "parallel-2" ]; then
        run_parallel_Nt_1b
    
    elif [ $suite == "parallel-3" ]; then
        run_parallel_fixture_1b

    elif [ $suite == "ip_geolocation" ]; then
        run_ip_geolocation

    else
        echo "invalid suite option; suite should be from (\"single\", \"local\", \"parallel-1\", \"parallel-2\", \"parallel-3\", \"e2e_ip_geolocation\""
    fi
}


run_single_test_on_prem(){
    browser="chrome"
    test_file="src/test/suites/login/test4.js"
    $testcafe "$browser"  $test_file  --test-scheduling   --reporter spec
}

run_parallel_1t_Nb_on_prem(){
    browser="all"
    test_file="src/test/suites/login/test4.js"
    $testcafe "$browser"  $test_file  --test-scheduling   --reporter spec
}






on_prem_logic(){
    common_env

    if   [ $suite == "single" ]; then
        run_single_test_on_prem

    elif [ $suite == "parallel" ]; then
        run_parallel_1t_Nb_on_prem

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



