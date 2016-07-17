# Contributing

This repository accepts pull requests.

If you want to add a new service, just create a new folder within the 'services' folder containing at least the following files:

1. `Dockerfile`: This needs to be the base where the 'waiter' script will be injected. Bonus points if you make the resulting image as tiny as possible.
2. `ping.sh`: This file needs to have the instructions for knowing when a given service is considered to be ready. Adding text information will be useful when the image is run with '**WAITER_DEBUG**=true' environment configuration.
3. `service.yml`: This makes possible to test your image against the service you want to wait for, by defining a **docker-compose** configuration that will be used during the tests. Configure the service image in a way that you can access it from a properly configured waiter container.
4. `client.env`: This is also needed for testing. Here you need to inject the configuration in the waiter container in order to fulfill the interface you defined in your `ping.sh` and `service.yml`.
5. `test_success.env`: Another environment configuration for testing. In this one you just declare the **WAITER_*** vars that give enough time to the service to be ready.
6. `test_failure.env` (optional, but recommended): Last configuration for testing, this allows to run a test to cover false positives. In this one you declare **WAITER_*** vars that don't give enough time to the service in order to be ready.

The versions are centralized in order to make the project easy to manage. As soon as there is an increment in functionability or a fix, a new release will be created and the resulting images will be pushed to Docker Hub.

Version of **docker-compose >= 1.6** is needed to run the build.

No pull request that break the build will be accepted. Make sure you run `./build.sh` in your local environment to make sure that your pull request is fine. 

In order to speed up the development cycle, you can run `$ ./scripts/build_service.sh %YOUR_SERVICE && ./scripts/test_service.sh %YOUR_SERVICE` to validate that `%YOUR_SERVICE` works fine without having to run the whole build.

Also, pull request to improve the documentation are very welcomed.

