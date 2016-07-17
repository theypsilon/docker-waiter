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
	theypsilon/docker-wait-for-elasticsearch:latest
```