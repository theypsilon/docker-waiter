# Docker Waiter

This is an image collection of utilities meant to introduce wait logic for a number of services.

All images will use a [waiter script](scripts/waiter.sh) as default command that can be configured with the following environment variables:

* **WAITER_ATTEMPTS** (mandatory): Number of attempts the waiter will ping the service.
* **WAITER_ATTEMPT_SLEEPTIME** (mandatory): Amount of time the waiter will wait in seconds after an unsuccesful ping attempt.
* **WAITER_DEBUG** (optional, default: false): If true, it will show in console the response of the ping command executed on attemps, otherwise it will be hidden.

# List of Images

* **theypsilon/docker-waiter-mysql:0.1.20**: Waits until MySQL is able to execute queries.
* **theypsilon/docker-waiter-rest:0.1.20**: Waits until the expected HTTP STATUS CODE is returned from a given HTTP URL
* **theypsilon/docker-waiter-elasticsearch:0.1.20**: Waits until Elastic Search server is up and the cluster health status is green or yellow.

# How to use the Images

### theypsilon/docker-waiter-elasticsearch:0.1.20

Configuration of the Elastic Search Waiter can be done through the following environment variables:

* **ELASTICSEARCH_HOST** (mandatory)
* **ELASTICSEARCH_PORT** (mandatory)

Example:
```
$ docker run --name elasticsearch_server -d elasticsearch:1.5.2

51321a23d283005344502b330b5249248f70f0c5ac4cee36fb6356a17f078034

$ docker run -it --rm --link elasticsearch_server:elasticsearch_server \
	-e ELASTICSEARCH_HOST=elasticsearch_server \
	-e ELASTICSEARCH_PORT=9200 \
	-e WAITER_DEBUG=false \
	-e WAITER_ATTEMPTS=20 \
	-e WAITER_ATTEMPT_SLEEPTIME=1 \
	theypsilon/docker-waiter-elasticsearch:0.1.20

[WAITER] WAITER_ATTEMPTS: 20 | WAITER_ATTEMPT_SLEEPTIME: 1
[WAITER] ....... OK
```


### theypsilon/docker-waiter-mysql:0.1.20

Configuration of the MySQL Waiter can be done through the following environment variables:

* **MYSQL_HOST** (mandatory)
* **MYSQL_PORT** (mandatory)
* **MYSQL_USER** (mandatory)
* **MYSQL_PASSWORD** (mandatory)
* **MYSQL_QUERY** (optional, default value is 'select 1'): As long as the query produce an Error, the ping will be valid.

Example:
```
$ docker run --name mysql_server -d \
	-e MYSQL_ROOT_PASSWORD=root \
	-e MYSQL_USER=test \
	-e MYSQL_PASSWORD=test \
	-e MYSQL_DATABASE=test \
	mysql:5.6.28

c03b737671099e1454e65e03cb1d4d1c05fdb4ddfd7bf725112d495ad637605a

$ docker run -it --rm --link mysql_server:mysql_server \
	-e MYSQL_HOST=mysql_server \
	-e MYSQL_PORT=3306 \
	-e MYSQL_USER=test \
	-e MYSQL_PASSWORD=test \
	-e WAITER_DEBUG=true \
	-e WAITER_ATTEMPTS=20 \
	-e WAITER_ATTEMPT_SLEEPTIME=1 \
	theypsilon/docker-waiter-mysql:0.1.20 && echo DONE!

[WAITER] WAITER_ATTEMPTS: 20 | WAITER_ATTEMPT_SLEEPTIME: 1
[WAITER] ...... OK
DONE!
```


### theypsilon/docker-waiter-rest:0.1.20

Configuration of the REST Waiter can be done through the following environment variables:

* **HTTP_URL** (mandatory)
* **HTTP_STATUS_CODE** (mandatory)

Example:
```
$ docker run --name elasticsearch_server -d elasticsearch:1.5.2

f14ac8441f2614748e461acd4ab0417d77a59a06e25fab240a88406736d15107

$ docker run -it --rm --link elasticsearch_server:elasticsearch_server \
	-e HTTP_URL=http://elasticsearch_server:9200/_cluster/health \
	-e HTTP_STATUS_CODE=200 \
	-e WAITER_DEBUG=false \
	-e WAITER_ATTEMPTS=20 \
	-e WAITER_ATTEMPT_SLEEPTIME=1 \
	theypsilon/docker-waiter-rest:0.1.20 && echo DONE!

[WAITER] WAITER_ATTEMPTS: 20 | WAITER_ATTEMPT_SLEEPTIME: 1
[WAITER] .. OK
DONE!
```

**NOTE**: Notice that checking elasticsearch by looking the http status code is not sufficient, and you should use the image '**theypsilon/docker-waiter-elasticsearch:0.1.20**' instead to know when the elasticsearch clusters are ready.

# Contribute

This repository accepts pull requests. If you want to add a new service, just create a new folder within the 'services' folder containing at least the following files:

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

# License

[LICENSE.md](LICENSE.md)
