# Docker Waiter [![Build Status](https://travis-ci.org/theypsilon/docker-waiter.svg?branch=latest)](https://travis-ci.org/theypsilon/docker-waiter)

This is an image collection of "waiters", images that are meant to be run as one-off processes, exiting succesfully when the matching service they are waiting for is *ready*.

All waiter images will use exactly the same [waiter script](waiter/waiter.sh) as default command that can be configured with the following environment variables:

* **WAITER_ATTEMPTS** (mandatory): Number of attempts the waiter will *ping* the service. If there is no succesful ping after that given number of attempts, it means that the service is expected to never be ready for the current context, so the process will exit with error code 1.
* **WAITER_ATTEMPT_SLEEPTIME** (mandatory): Amount of time the waiter will wait in seconds after an unsuccesful *ping* attempt. After that time, a new attempt will begin.
* **WAITER_DEBUG** (optional, default: false): If true, it will show in console the response of the *ping* command executed on attemps, otherwise it will be hidden.

In order to provide wait logic for a heterogeneous number of services, every *waiter* here provides a different definition of *ping* that is useful for its correspoding service.

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
* **MYSQL_QUERY** (optional, default value is `select 1`): As long as the query produce an Error, the ping will be valid.

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

* **HTTP_URL** (mandatory): URL of the shape `http://%SERVICE_DOMAIN:%SERVICE_PORT/route/ping`
* **HTTP_STATUS_CODE** (mandatory): The expected HTTP STATUS CODE meaning that the resource behind the given HTTP URL is OK, typically **200**.

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

# Contributing

This repository accepts pull requests.

More details at [CONTRIBUTING.md](CONTRIBUTING.md)

# License

[LICENSE.md](LICENSE.md)
