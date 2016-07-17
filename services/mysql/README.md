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
	theypsilon/docker-wait-for-mysql:latest && echo DONE!

[WAITER] WAITER_ATTEMPTS: 20 | WAITER_ATTEMPT_SLEEPTIME: 1
[WAITER] ...... OK
DONE!
```