# DOCKER WAITER

This is an utility mean to introduce wait logic in a number of services.

The waiter can be configured for all those services through the following env vars:

* WAITER_ATTEMPTS (mandatory): Number of attempts the waiter will ping the service.
* WAITER_ATTEMPT_SLEEPTIME (mandatory): Amount of time the waiter will wait in seconds after an unsuccesful ping attempt.
* WAITER_DEBUG (optional, default: false): If true, it will show in console the response of the ping command executed on attemps, otherwise it will be hidden.

## We have following images ready to be used


## theypsilon/docker-wait-for-elasticsearch:master

Configuration of elasticsearch would be done with following vars:

* ELASTICSEARCH_HOST (mandatory)
* ELASTICSEARCH_PORT (mandatory)


## theypsilon/docker-wait-for-mysql:master

Configuration of mysql would be done with following vars:

* MYSQL_HOST (mandatory)
* MYSQL_PORT (mandatory)
* MYSQL_USER (mandatory)
* MYSQL_PASSWORD (mandatory)

