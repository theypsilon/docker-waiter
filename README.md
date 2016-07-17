# DOCKER WAIT-FOR

This is image collection of utilities meant to introduce wait logic for a number of services.

All images will use a waiter script as default command that can be configured with the following environment variables:

* **WAITER_ATTEMPTS** (mandatory): Number of attempts the waiter will ping the service.
* **WAITER_ATTEMPT_SLEEPTIME** (mandatory): Amount of time the waiter will wait in seconds after an unsuccesful ping attempt.
* **WAITER_DEBUG** (optional, default: false): If true, it will show in console the response of the ping command executed on attemps, otherwise it will be hidden.

# IMAGES


### theypsilon/docker-wait-for-elasticsearch:0.1.16

Configuration of elasticsearch would be done with following vars:

* **ELASTICSEARCH_HOST** (mandatory)
* **ELASTICSEARCH_PORT** (mandatory)

Example:
```
docker run --name elasticsearch_server -d \
	-e MYSQL_ROOT_PASSWORD=root \
	-e MYSQL_USER=test \
	-e MYSQL_PASSWORD=test \
	-e MYSQL_DATABASE=test \
	elasticsearch:5.6.28

docker run --rm --link elasticsearch_server:elasticsearch_server \
	-e MYSQL_HOST=elasticsearch_server \
	-e MYSQL_PORT=3306 \
	-e MYSQL_USER=test \
	-e MYSQL_PASSWORD=test \
	-e WAITER_DEBUG=true \
	-e WAITER_ATTEMPTS=20 \
	-e WAITER_ATTEMPT_SLEEPTIME=1 \
	theypsilon/docker-wait-for-elasticsearch:0.1.16
```


### theypsilon/docker-wait-for-mysql:0.1.16

Configuration of mysql would be done with following vars:

* **MYSQL_HOST** (mandatory)
* **MYSQL_PORT** (mandatory)
* **MYSQL_USER** (mandatory)
* **MYSQL_PASSWORD** (mandatory)
* **MYSQL_QUERY** (optional, default value is 'select 1'): As long as the query produce an Error, the ping will be valid.

Example:
```
docker run --name mysql_server -d \
	-e MYSQL_ROOT_PASSWORD=root \
	-e MYSQL_USER=test \
	-e MYSQL_PASSWORD=test \
	-e MYSQL_DATABASE=test \
	mysql:5.6.28

docker run -it --rm --link mysql_server:mysql_server \
	-e MYSQL_HOST=mysql_server \
	-e MYSQL_PORT=3306 \
	-e MYSQL_USER=test \
	-e MYSQL_PASSWORD=test \
	-e WAITER_DEBUG=true \
	-e WAITER_ATTEMPTS=20 \
	-e WAITER_ATTEMPT_SLEEPTIME=1 \
	theypsilon/docker-wait-for-mysql:0.1.16
```


### theypsilon/docker-wait-for-rest:0.1.16

Configuration of rest would be done with following vars:

* **HTTP_URL** (mandatory)
* **HTTP_STATUS_CODE** (mandatory)

Example:
```
docker run --name elasticsearch_server -d elasticsearch:1.5.2

docker run -it --rm --link elasticsearch_server:elasticsearch_server \
	-e HTTP_URL=http://elasticsearch_server:9200/_cluster/health \
	-e HTTP_STATUS_CODE=200 \
	-e WAITER_DEBUG=false \
	-e WAITER_ATTEMPTS=20 \
	-e WAITER_ATTEMPT_SLEEPTIME=1 \
	theypsilon/docker-wait-for-rest:0.1.16
```

Notice that checking elasticsearch by looking the http status code is not sufficient, and you should use the image 'theypsilon/docker-wait-for-elasticsearch:0.1.16' instead to know when the elasticsearch clusters are ready.



# LICENSE

[LICENSE.md](LICENSE.md)
