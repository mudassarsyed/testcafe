#!/bin/sh


# read the env type and profile name from commandline arguments
# the env_type can be "on-prem" or "bstack"
# set on-prem to run profile locally, and bstack to run  profile browserstack
# set profile name, we have defined different test combinations depending on profile name which cover 
# a broad range of usecases
env_type=$1
profile=$2
testfile_arg=$3

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

    # if test_name arg was empty set default testname
    if [ -z $testfile_arg ]; then
        test_file="src/test/suites/e2e/E2ETest.js"
    # else set test_file to testfile_arg
    else
        test_file=$testfile_arg
    fi

    #echo "$test_file"
    $testcafe $browser $test_file --test-scheduling --reporter spec

}

# run one test on multiple browsers
run_parallel_1t_Nb(){

    
    #browser_list="@browserStack/browserstack:firefox@74.0:OS X High Sierra,@browserStack/browserstack:chrome@80.0:OS X High Sierra,@browserStack/browserstack:ie@11:Windows 10,@browserStack/browserstack:chrome@80.0:Windows 10,@browserStack/browserstack:firefox@75.0:Windows 8.1"
    test_file="src/test/suites/offers/GPSLocationTest.js"


    #$testcafe "$browser_list"  $test_file --test-scheduling --reporter spec
    $testcafe "@browserStack/browserstack:firefox@74.0:OS X High Sierra"  $test_file --test-scheduling --reporter spec &
    $testcafe "@browserStack/browserstack:chrome@80.0:OS X High Sierra"  $test_file --test-scheduling --reporter spec &
    $testcafe "@browserStack/browserstack:firefox@75.0:Windows 8.1"  $test_file --test-scheduling --reporter spec &
    $testcafe "@browserStack/browserstack:Samsung Galaxy S20@10.0"  $test_file --test-scheduling --reporter spec &
    $testcafe "@browserStack/browserstack:iPhone XS@13.0"  $test_file --test-scheduling --reporter spec


}


run_all_fixtures_temp(){
    test_base_path="src/test/suites/user/"
    browser="browserstack:firefox@74.0:OS X High Sierra"

    testcafe "$browser"  "$test_base_path" -c 3 --test-scheduling 

}

run_all_fixtures_temp1(){
    test_base_path="src/test/suites/user/"
    browser="@browserStack/browserstack:firefox@74.0:OS X High Sierra,@browserStack/browserstack:firefox@74.0:OS X High Sierra,@browserStack/browserstack:firefox@74.0:OS X High Sierra"

    $testcafe "$browser"  "$test_base_path"  --test-scheduling 

}

#
run_all_fixtures(){

    # base path to folder where all the test files are 
    test_base_path="src/test/suites"
    browser="@browserStack/browserstack:firefox@74.0:OS X High Sierra"

    # set this variable to the max number of parallels you have on browserstack
    # we would execute all the tests in batches of max_parallel tests. Thus
    # at a given time a max of max_parallel tests would be running in parallel
    # this helps prevent queuing and test dropping
    max_parallels=5

    # the i counter helps in creating the batches
    i=0

    # iterate through all the files in the test_base_path diretory
    for test_path in $(find $test_base_path -type f -print)
    do
        # this is the case when i max_parallel-1. This signifies the last test ina batch from i=0 to 
        # max_parallel-1 thus after this test we put a wait. A wait basically stops execution until all 
        # processes have finished execution. In our case this means, it waits until a batch of max_parallel 
        # has finished execution
        if [ $((i%max_parallels)) == $((max_parallels-1)) ]; then
            $testcafe "$browser"  "$test_path" --test-scheduling 
            wait
        
        else
        # notice the & at the end. This means that the next test would be run in parallel with this test
        # this command is executed when i=0,1,...,max_parallel-2
            $testcafe "$browser"  "$test_path" --test-scheduling &
        fi
        # increment i
        i=$((i+1))
    done
    wait
    echo ""
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

#$testcafe "$browser"  $test_file  --test-scheduling   -r html:reports/report.html


bstack_logic(){

    
    # set the common env variables from the `common_env` function defined above
    # these common environment variables are necesaary for the browerstack plugin
    common_env

    #start local 
    start_local

    if   [ $profile == "single" ]; then
        run_single_test 

    elif [ $profile == "parallel" ]; then
        run_all_fixtures

    elif [ $profile == "parallel-browsers" ]; then
        run_parallel_1t_Nb

    elif [ $profile == "local" ]; then
        export TEST_BASE_URL="http://localhost:3000/"
        run_single_test 

    elif [ $profile == "local-parallel" ]; then
        export TEST_BASE_URL="http://localhost:3000/"
        run_all_fixtures

    elif [ $profile == "local-parallel-browsers" ]; then
        export TEST_BASE_URL="http://localhost:3000/"
        run_parallel_1t_Nb
    else
        echo "invalid profile option; profile should be from (\"single\", \"local\", \"parallel\", \"parallel-browsers\", \"local-parallel\", \"local-parallel-browsers\""
    fi

    end_local
}






run_single_test_on_prem(){
    browser="chrome"
    # if test_name arg was empty set default testname
    if [ -z $testfile_arg ]; then
        test_file="src/test/suites/e2e/E2ETest.js"
    # else set test_file to testfile_arg
    else
        test_file=$testfile_arg
    fi

    $testcafe "$browser"  $test_file  --test-scheduling   --reporter spec
}


run_suite_on_prem(){
    browser="chrome"
    test_base_path="src/test/suites"


    # iterate through all the files in the test_base_path diretory
    for test_path in $(find $test_base_path -type f -print)
    do
        $testcafe "$browser"  "$test_path"  --test-scheduling   --reporter spec 
        wait
    done
    echo ""

}




on_prem_logic(){
    export TEST_BASE_URL="http://bstackdemo.com/"

    if   [ $profile == "single" ]; then
        run_single_test_on_prem

    elif [ $profile == "suite" ]; then
        run_suite_on_prem

    else
        echo "invalid profile option; profile should be from (\"single\", \"local\", \"parallel-1\", \"parallel-2\", \"parallel-3\", \"e2e_ip_geolocation\""
    fi
}



docker_logic(){
    docker run -e TEST_BASE_URL='http://bstackdemo.com/' -p 1337:1337 -p 1338:1338 -v /Users/madhav/Desktop/dev/browserstack-testcafe/src/test:/test -it testcafe/testcafe firefox  --hostname localhost remote test/suites/login/test3.js
}



#run_all_fixtures
# launch bstack or on-prem tests.
# bstack tests would run on browserstack, on-prem tests would launch on the local machine.

if   [ $env_type == "bstack" ]; then
    bstack_logic 

elif [ $env_type == "on-prem" ]; then
    on_prem_logic 

elif [ $env_type == "docker" ]; then
    docker_logic

else
    echo "invalid run environment; choose between \"bstack\" or \"on-prem\" or \"docker\""

fi



