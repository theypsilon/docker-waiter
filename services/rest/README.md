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
	theypsilon/docker-wait-for-rest:latest
```

Notice that checking elasticsearch by looking the http status code is not sufficient, and you should use the image 'theypsilon/docker-wait-for-elasticsearch:latest' instead to know when the elasticsearch clusters are ready.