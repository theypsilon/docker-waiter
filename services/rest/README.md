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
	theypsilon/docker-wait-for-rest:latest && echo DONE!

[WAITER] WAITER_ATTEMPTS: 20 | WAITER_ATTEMPT_SLEEPTIME: 1
[WAITER] .. OK
DONE!
```

Notice that checking elasticsearch by looking the http status code is not sufficient, and you should use the image 'theypsilon/docker-wait-for-elasticsearch:latest' instead to know when the elasticsearch clusters are ready.