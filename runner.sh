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



# select binary based on OS detected
if [ "$(uname)" == "Darwin" ]; then
    # set local binary path to mac os local binary
    local_binary="resources/local/BrowserStackLocal_mac_os"

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # check for 64 bit vs 32 bit and set path to appropriate binary
    if $(uname -m | grep '64'); then
        local_binary="resources/local/BrowserStackLocal_linux_64"
    else
        local_binary="resources/local/BrowserStackLocal_linux_32"
    fi

elif [ "$(expr substr $(uname -s) 1 5)" == "MINGW" ]; then
    # windows detected, use the windows binary
    local_binary="resources/local/BrowserStackLocal.exe"

else
    echo "couldn't detect OS, comment out the above if else ladder for binary selection  and hardcode the path to the appropriate binary file in ./resources/local/ based on OS"
    exit 0

fi




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
    # uncomment the line below if build id should be date + time
    # export BROWSERSTACK_BUILD_ID="test-cafe-{$(date +"%Y-%m-%d %H:%M:%S")}"

    # you can overwrite this name to set the buildname
    BROWSERSTACK_BUILD_NAME="browserstack-examples-testcafe"
    # set buildname to <BROWSERSTACK_BUILD_NAME>-epoch
    export BROWSERSTACK_BUILD_ID=$BROWSERSTACK_BUILD_NAME+"-$(date +"%s")" 

    # enable/ disable the debugging logs generated
    export BROWSERSTACK_DEBUG="true"
    export BROWSERSTACK_CONSOLE="errors"
    export BROWSERSTACK_VIDEO="true"
    export BROWSERSTACK_NETWORK_LOG="true"

    # config file for extra browserstack capaabilities, we will be using it for
    # the `maskCommands` capability which hides any typed test in the browserstack 
    # text logs
    export BROWSERSTACK_CAPABILITIES_CONFIG_PATH="$(pwd)/resources/config/browserstack-config.json"

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

    test_base_path="src/test/suites"

    for test_path in $(find $test_base_path -type f -print)
    do
    
        $testcafe "@browserStack/browserstack:firefox@74.0:OS X High Sierra"  $test_path --test-scheduling --reporter spec &
        $testcafe "@browserStack/browserstack:chrome@80.0:OS X High Sierra"  $test_path --test-scheduling --reporter spec &
        $testcafe "@browserStack/browserstack:firefox@75.0:Windows 8.1"  $test_path --test-scheduling --reporter spec &
        $testcafe "@browserStack/browserstack:Samsung Galaxy S20@10.0"  $test_path --test-scheduling --reporter spec &
        $testcafe "@browserStack/browserstack:iPhone XS@13.0"  $test_path --test-scheduling --reporter spec
        wait
    
    done

}



# run all tests on bstack in parallel on one browser
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
    # local testing allows you to test on internal environments like a locally hosted webapp
    echo "local start"
    # start the local binary
    $local_binary --key $BROWSERSTACK_ACCESS_KEY --local-identifier TestCafe --daemon start;
}

end_local(){
    # wait until all the tests complete
    wait
    echo "local end"
    # close the local binary
    $local_binary --key $BROWSERSTACK_ACCESS_KEY --local-identifier TestCafe --daemon stop;
}

#$testcafe "$browser"  $test_file  --test-scheduling   -r html:reports/report.html


bstack_logic(){

    
    # set the common env variables from the `common_env` function defined above
    # these common environment variables are necesaary for the browerstack plugin
    common_env

    #start local 
    start_local


    if [ -z $profile ]; then
        # runs single test
        run_single_test

    elif [ $profile == "single" ]; then
        # runs single test
        run_single_test 

    elif [ $profile == "parallel" ]; then
        # runs all test in parallel, you can set max parallels in the run_all_fixtures
        # function. 
        run_all_fixtures

    elif [ $profile == "parallel-browsers" ]; then
        # runs a single test on multiple browsers in parallel
        # covers both mobile and desktop browsers
        run_parallel_1t_Nb

    # all the below profiles are similar to the above profiles except, 
    # the test base url is set to a localhost address. 
    # overwrites the base_url set in function `common_env` since we are trying out local-testing


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

    # end local binary
    end_local
}





# function runs a single test on-premise
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

# function runs entire suite sequentially on-premise
run_suite_on_prem(){
    browser="chrome"
    test_base_path="src/test/suites"


    # iterate through all the files in the test_base_path diretory
    for test_path in $(find $test_base_path -type f -print)
    do
        $testcafe "$browser"  "$test_path"  --test-scheduling   --reporter spec 
        
    done
    echo ""

}




on_prem_logic(){
    export TEST_BASE_URL="http://bstackdemo.com/"

    if [ -z $profile ]; then
        # if profile name is empty run single test
        run_single_test_on_prem

    elif [ $profile == "single" ]; then
        # runs a single test
        run_single_test_on_prem

    elif [ $profile == "suite" ]; then
        # runs all 9 tests sequentially
        run_suite_on_prem

    else
        echo "invalid profile option; profile should be from (\"single\", \"suite\")"
    fi
}



docker_logic(){

    # starting docker compose
    docker-compose up -d

    # in docker the second arg is missing
    testfile_arg=$profile

    # if test_name arg was empty set default testname
    if [ -z $testfile_arg ]; then
        test_file="src/test/suites/login/LockedUserTest.js"
    # else set test_file to testfile_arg
    else
        test_file=$testfile_arg
    fi

    docker run -e TEST_BASE_URL='http://bstackdemo.com/' -p 1337:1337 -p 1338:1338 -v "$(pwd)/src:/src" -it testcafe/testcafe firefox  --hostname localhost remote $test_file

    # close docker compose
    wait
    docker-compose down

}




#run_all_fixtures
# launch bstack or on-prem tests.
# bstack tests would run on browserstack, on-prem tests would launch on the local machine.

if   [ $env_type == "bstack" ]; then
    # running tests on browserstack
    bstack_logic 

elif [ $env_type == "on-prem" ]; then
    # running tests on premise (locally)
    on_prem_logic 

elif [ $env_type == "docker" ]; then
    # runner tests on your testcafe docker instance
    docker_logic

else
    echo "invalid run environment; choose between \"bstack\" or \"on-prem\" or \"docker\""

fi



