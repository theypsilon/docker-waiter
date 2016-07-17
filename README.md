# DOCKER WAITER

This is an image collection of utilities meant to introduce wait logic for a number of services.

All images will use a [waiter script](scripts/waiter.sh) as default command that can be configured with the following environment variables:

* **WAITER_ATTEMPTS** (mandatory): Number of attempts the waiter will ping the service.
* **WAITER_ATTEMPT_SLEEPTIME** (mandatory): Amount of time the waiter will wait in seconds after an unsuccesful ping attempt.
* **WAITER_DEBUG** (optional, default: false): If true, it will show in console the response of the ping command executed on attemps, otherwise it will be hidden.

# IMAGES


### theypsilon/docker-waiter-elasticsearch:0.1.19

Configuration of elasticsearch would be done with following vars:

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
	theypsilon/docker-waiter-elasticsearch:0.1.19

[WAITER] WAITER_ATTEMPTS: 20 | WAITER_ATTEMPT_SLEEPTIME: 1
[WAITER] ....... OK
```


### theypsilon/docker-waiter-mysql:0.1.19

Configuration of mysql would be done with following vars:

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
	theypsilon/docker-waiter-mysql:0.1.19 && echo DONE!

[WAITER] WAITER_ATTEMPTS: 20 | WAITER_ATTEMPT_SLEEPTIME: 1
[WAITER] ...... OK
DONE!
```


### theypsilon/docker-waiter-rest:0.1.19

Configuration of rest would be done with following vars:

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
	theypsilon/docker-waiter-rest:0.1.19 && echo DONE!

[WAITER] WAITER_ATTEMPTS: 20 | WAITER_ATTEMPT_SLEEPTIME: 1
[WAITER] .. OK
DONE!
```

Notice that checking elasticsearch by looking the http status code is not sufficient, and you should use the image 'theypsilon/docker-waiter-elasticsearch:0.1.19' instead to know when the elasticsearch clusters are ready.



# LICENSE

[LICENSE.md](LICENSE.md)
