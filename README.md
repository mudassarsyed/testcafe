![Logo](https://www.browserstack.com/images/static/header-logo.jpg)

# BrowserStack Examples TestCafe <a href="https://devexpress.github.io/testcafe/"><img src="https://raw.githubusercontent.com/DevExpress/testcafe/master/media/testcafe-logo.svg?sanitize=true" alt="TestCafe" height="22" /></a>

## Introduction

TestCafe is a Node.js tool to automate end-to-end web testing.
TestCafe uses a URL-rewriting proxy which allows it to work without the WebDriver. This proxy injects the driver script that emulates user actions into the tested page. TestCafe is a tool that supports page object model, data-driven and behavior-driven development (BDD).

This BrowserStack Example repository demonstrates a TestCafe framework written in TestCafe with parallel testing capabilities. The TestCafe test scripts are written for the open source [BrowserStack Demo web application](https://bstackdemo.com) ([Github](https://github.com/browserstack/browserstack-demo-app)). This BrowserStack Demo App is an e-commerce web application which showcases multiple real-world user scenarios. The app is bundled with offers data, orders data and products data that contains everything you need to start using the app and run tests out-of-the-box.

The TestCafe tests are run on different platforms like on-prem, docker and BrowserStack using various run configurations and test capabilities.

---

## Repository setup

- Clone the repository

- Ensure you have the following dependencies installed on the machine

  - npm >= 8
  - shell

To install bash on windows, just install GIT. During installation of GIT, add GIT Bash to windows context menu by selecting its option. After installation right click in your folder select `GIT Bash Here`. More details over [here](https://stackoverflow.com/questions/26522789/how-to-run-sh-on-windows-command-prompt)

To install all the node modules dependencies, run the following command in the repository root directory

npm:

```sh
npm install
```

## About the tests in this repository

This repository contains the following TestCafe tests:

| Module  | Test name                 | Description                                                                                                                                                                                                                                                                       |
| ------- | ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| E2E     | E2ETest                   | This test scenario verifies successful product purchase lifecycle end-to-end. It demonstrates the [Page Object Model design pattern](https://www.browserstack.com/guide/page-object-model-in-selenium) and is also the default test executed in all the single test run profiles. |
| Login   | RedirectToSignInTest      | This test verifies the redirection to the signin page when user clicks favorite button.                                                                                                                                                                                           |
| Login   | LockedUserTest            | This test verifies the login workflow error for a locked user.                                                                                                                                                                                                                    |
| Offers  | GPSLocationTest           | This test mocks the GPS location for Mumbai and verifies that the product offers applicable for the Mumbai location are shown.                                                                                                                                                    |
| Product | ProductFiltersTest        | This test verifies that the number of product reduces when the vendor filter option is applied.                                                                                                                                                                                   |
| Product | HighToLowFilterTest       | This test verifies that the product prices are in ascending order when the product sort "Lowest to Highest" is applied.                                                                                                                                                           |
| User    | ImageLoadTest             | This test verifies that the product images load for user: "image_not_loading_user" on the e-commerce application. Since the images do not load, the test case assertion fails.                                                                                                    |
| User    | OrdersGreaterThanZeroTest | This test verifies that existing orders are shown for user: "existing_orders_user"                                                                                                                                                                                                |
| User    | AddToFavouritesTest       | This test verifies that a product is added to favourites list after clicking the favourites button on the home page                                                                                                                                                               |

---

## Test infrastructure environments

- [On-premise/self-hosted](#on-premise-self-hosted)
- [Docker](#docker)
- [BrowserStack](#browserstack)

## Configuring the maximum parallel test threads for this repository

For all the parallel run configuration profiles, you can configure the maximum parallel test threads by changing the settings below.

- BrowserStack

  in `runner.sh`, in the function `run_all_fixtures` set `max_parallels` to the number of parallel threads required. The default number of parallels is set to 5

## Test Reporting

- [reports](#generating-reports)

---

# On Premise / Self Hosted

This infrastructure points to running the tests on your own machine using a browser (e.g. Chrome)

## Running Your Tests

### Run a specific test on your own machine

- How to run the test?

  To run the default test scenario (e.g. End to End Scenario) on your own machine, use the following command:

  ```sh
  sh runner.sh on-prem single
  ```

  To run a specific test scenario, use the following command with the additional `<relative-test-path>` argument:

  ```sh
  sh runner.sh on-prem single "<relative-test-path>"
  ```

  where, the argument `<relative-test-path>` can be any relative path to a test in this repository.

  E.g. "src/test/suites/offers/GPSLocationTest.js", "src/test/suites/login/LockedUserTest.js" or any of the other test paths from the project root, as outlined in [About the tests in this repository](#About-the-tests-in-this-repository) section.

  For Example

  ```sh
  sh runner.sh on-prem single src/test/suites/login/LockedUserTest.js
  ```

- Output

  This run profile executes a specific test scenario on a single browser instance on your own machine.

### Run the entire test suite on your own machine

- How to run the test?

  To run the entire test suite on your own machine, use the following command:

  ```sh
  sh runner.sh on-prem suite
  ```

- Output

  This run profile executes the entire test suite sequentially on a single browser, on your own machine.

---

# Docker

[Docker](https://docs.docker.com/get-started/overview/) is an open source platform that provides the ability to package and test applications in an isolated environment called containers.

## Prerequisites

- Install and start [Docker](https://docs.docker.com/get-docker/).
- Note: Docker should be running on the test machine. Ensure Docker Compose is installed as well.
- Run `docker-compose pull` from the current directory of the repository.

## Running Your Tests

### Run a specific test on the docker infrastructure

- How to run the test?

  - Start the Docker by running the following command:

  ```sh
  docker-compose up -d
  ```

  - To run the default test scenario (e.g. End to End Scenario) on your own machine, use the following command:

  ```sh
  sh runner.sh docker
  ```

  To run a specific test scenario, use the following command with the additional `<relative-test-path>` argument:

  ```sh
  sh runner.sh docker single "<relative-test-path>"
  ```

  where, the argument `<relative-test-path>` can be any relative path to a test in this repository.

  E.g. "src/test/suites/offers/GPSLocationTest.js", "src/test/suites/login/LockedUserTest.js" or any of the other test paths from the project root, as outlined in [About the tests in this repository](#About-the-tests-in-this-repository) section.

  For Example

  ```sh
  sh runner.sh docker single src/test/suites/login/LockedUserTest.js
  ```

  - After tests are complete, you can stop the Docker by running the following command:

  ```sh
  docker-compose down
  ```

- Output

  This run profile executes a specific test scenario on a single browser deployed on a docker image.

# BrowserStack

[BrowserStack](https://browserstack.com) provides instant access to 2,000+ real mobile devices and browsers on a highly reliable cloud infrastructure that effortlessly scales as testing needs grow.

## Prerequisites

- Create a new [BrowserStack account](https://www.browserstack.com/users/sign_up) or use an existing one.
- Identify your BrowserStack username and access key from the [BrowserStack Automate Dashboard](https://automate.browserstack.com/) and export them as environment variables using the below commands.

  - For \*nix based and Mac machines:

  ```sh
  export BROWSERSTACK_USERNAME=<browserstack-username> &&
  export BROWSERSTACK_ACCESS_KEY=<browserstack-access-key>
  ```

  - For Windows:

  ```shell
  set BROWSERSTACK_USERNAME=<browserstack-username>
  set BROWSERSTACK_ACCESS_KEY=<browserstack-access-key>
  ```

  Alternatively, you can also hardcode username and access_key objects in the `common_env` function in [runner.sh](runner.sh) file.

- Download the appropriate BrowserStack local binary based on your operating system from [Local Testing docs ](https://www.browserstack.com/local-testing/automate) and set the path to the binary in the `local_binary` variable in the  [runner.sh](runner.sh) file.

  For Example

    After downloaded the appropriate binary from the [local testing docs](https://www.browserstack.com/local-testing/automate) to the `resources/local` directory in the project root directory, then in `runner.sh` set

    ```sh
    local_binary="resources/local/BrowserStackLocal"
    ```


## Running Your Tests

### Run a specific test on BrowserStack

In this section, we will run a single test on Chrome browser on Browserstack. To change test capabilities for this configuration, please refer to the `run_single_test` function in `runner.sh` file.

- How to run the test?

  - To run the default test scenario (e.g. End to End Scenario) on your own machine, use the following command:

  ```sh
  sh runner.sh bstack single
  ```

  To run a specific test scenario, use the following command with the additional `<relative-test-path>` argument:

  ```sh
  sh runner.sh bstack single "<relative-test-path>"
  ```

  where, the argument `<relative-test-path>` can be any relative path to a test in this repository.

  E.g. "src/test/suites/offers/GPSLocationTest.js", "src/test/suites/login/LockedUserTest.js" or any of the other test paths from the project root, as outlined in [About the tests in this repository](#About-the-tests-in-this-repository) section.

  For Example

  ```sh
  sh runner.sh bstack single src/test/suites/login/LockedUserTest.js
  ```

- Output

  This run profile executes a single test on a single browser on BrowserStack. Please refer to your [BrowserStack dashboard](https://automate.browserstack.com/) for test results.

### Run the entire test suite in parallel on a single BrowserStack browser

In this section, we will run the tests in parallel on a single browser on Browserstack. Refer to `run_all_fixtures` object in `runner.sh` file to change test capabilities for this configuration.

- How to run the test?

  To run the entire test suite in parallel on a single BrowserStack browser, use the following command:

  ```sh
  sh runner.sh bstack parallel
  ```

- Output

  This run profile executes the entire test suite in parallel on a single BrowserStack browser. Please refer to your [BrowserStack dashboard](https://automate.browserstack.com/) for test results.

  - Note: By default, this execution would run maximum 5 test threads in parallel on BrowserStack. Refer to the section ["Configuring the maximum parallel test threads for this repository"](#Configuring-the-maximum-parallel-test-threads-for-this-repository) for updating the parallel thread count based on your requirements.

### Run the entire test suite in parallel on multiple BrowserStack browsers

In this section, we will run the tests in parallel on multiple browsers on Browserstack. Refer to the `run_parallel_1t_Nb` function in `runner.sh` file to change test capabilities for this configuration.

- How to run the test?

  To run the entire test suite in parallel on multiple BrowserStack browsers, use the following command:

  ```sh
  sh runner.sh bstack parallel-browsers
  ```

### [Web application hosted on internal environment] Running your tests on BrowserStack using BrowserStackLocal

#### Prerequisites

- Clone the [BrowserStack demo application](https://github.com/browserstack/browserstack-demo-app) repository.
  ```sh
  git clone https://github.com/browserstack/browserstack-demo-app
  ```
- Please follow the README.md on the BrowserStack demo application repository to install and start the dev server on localhost.
- In this section, we will run a single test case to test the BrowserStack Demo app hosted on your local machine i.e. localhost. Refer to the `run_single_test` function in `runner.sh` file to change test capabilities for this configuration.
- Note: You may need to provide additional BrowserStackLocal arguments to successfully connect your localhost environment with BrowserStack infrastructure. (e.g if you are behind firewalls, proxy or VPN).
- Further details for successfully creating a BrowserStackLocal connection can be found here:

  - [Local Testing with Automate](https://www.browserstack.com/local-testing/automate)

### [Web application hosted on internal environment] Run a specific test on BrowserStack using BrowserStackLocal

- How to run the test?

  - To run the default test scenario (e.g. End to End Scenario) on a single BrowserStack browser using BrowserStackLocal, use the following command:

  ```sh
  sh runner.sh bstack local
  ```

  To run a specific test scenario, use the following command with the additional `<relative-test-path>` argument:

  ```sh
  sh runner.sh bstack local "<relative-test-path>"
  ```

  where, the argument `<relative-test-path>` can be any relative path to a test in this repository.

  E.g. "src/test/suites/offers/GPSLocationTest.js", "src/test/suites/login/LockedUserTest.js" or any of the other test paths from the project root, as outlined in [About the tests in this repository](#About-the-tests-in-this-repository) section.

  For Example

  ```sh
  sh runner.sh bstack local src/test/suites/login/LockedUserTest.js
  ```

- Output

  This run profile executes a single test on an internally hosted web application on a single browser on BrowserStack. Please refer to your BrowserStack dashboard(https://automate.browserstack.com/) for test results.

### [Web application hosted on internal environment] Run the entire test suite in parallel on a single BrowserStack browser using BrowserStackLocal

In this section, we will run the test cases to test the internally hosted website in parallel on a single browser on Browserstack. Refer to the `run_all_fixtures` function in `runner.sh` file to change test capabilities for this configuration.

- How to run the test?

  To run the entire test suite in parallel on a single BrowserStack browser using BrowserStackLocal, use the following command:

  ```sh
  sh runner.sh bstack local-parallel
  ```

- Output

  This run profile executes the entire test suite on an internally hosted web application on a single browser on BrowserStack. Please refer to your [BrowserStack dashboard](https://automate.browserstack.com/) for test results.

- Note: By default, this execution would run maximum 5 test threads in parallel on BrowserStack. Refer to the section ["Configuring the maximum parallel test threads for this repository"](#Configuring-the-maximum-parallel-test-threads-for-this-repository) for updating the parallel thread count based on your requirements.

### [Web application hosted on internal environment] Run the entire test suite in parallel on multiple BrowserStack browsers

In this section, we will run the tests in parallel on multiple browsers on Browserstack. Refer to the `run_parallel_1t_Nb` function in `runner.sh` file to change test capabilities for this configuration.

- How to run the test?

  To run the entire test suite in parallel on multiple BrowserStack browsers, use the following command:

  ```sh
  sh runner.sh bstack local-parallel-browsers
  ```

## Generating Reports

- Generate Report using the following flag: `-r html:reports/report.html` in the testcafe command, the node package `testcafe-reporter-html` is used in the package.json for supporting this functionality. Other test reporters, as outlined in the TestCafe documentation [here](https://devexpress.github.io/testcafe/documentation/guides/concepts/reporters.html) can also be used

## Additional Resources

- View your test results on the [BrowserStack Automate dashboard](https://www.browserstack.com/automate)
- Documentation for writing [Automate test scripts in TestCafe](https://www.browserstack.com/docs/automate/selenium/getting-started/nodejs/testcafe)
- Customizing your tests capabilities on BrowserStack using our [test capability generator](https://www.browserstack.com/automate/capabilities)
- [List of Browsers & mobile devices](https://www.browserstack.com/list-of-browsers-and-platforms?product=automate) for automation testing on BrowserStack #{ Replace link for non-Selenium frameworks. }
- [Using Automate REST API](https://www.browserstack.com/automate/rest-api) to access information about your tests via the command-line interface
- Understand how many parallel sessions you need by using our [Parallel Test Calculator](https://www.browserstack.com/automate/parallel-calculator?ref=github)
- For testing public web applications behind IP restriction, [Inbound IP Whitelisting](https://www.browserstack.com/local-testing/inbound-ip-whitelisting) can be enabled with the [BrowserStack Enterprise](https://www.browserstack.com/enterprise) offering

## Observations

## Open Issues
