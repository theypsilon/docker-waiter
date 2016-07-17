# DOCKER WAIT-FOR

This is an image collection of utilities meant to introduce wait logic for a number of services.

All images will use a waiter script as default command that can be configured with the following environment variables:

* **WAITER_ATTEMPTS** (mandatory): Number of attempts the waiter will ping the service.
* **WAITER_ATTEMPT_SLEEPTIME** (mandatory): Amount of time the waiter will wait in seconds after an unsuccesful ping attempt.
* **WAITER_DEBUG** (optional, default: false): If true, it will show in console the response of the ping command executed on attemps, otherwise it will be hidden.

# IMAGES

