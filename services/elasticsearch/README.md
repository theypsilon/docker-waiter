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
	theypsilon/docker-wait-for-elasticsearch:latest

[WAITER] WAITER_ATTEMPTS: 20 | WAITER_ATTEMPT_SLEEPTIME: 1
[WAITER] ....... OK
```