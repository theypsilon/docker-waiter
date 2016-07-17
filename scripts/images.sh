#!/usr/bin/env bash

set -euo pipefail

source scripts/common.source

# building
for service in ${SERVICES}; do
	(
		cd services/${service}
		docker build -t theypsilon/waiter-base:latest .
	)
	cp services/${service}/ping.sh waiter/
	(
		cd waiter
		docker build -t ${IMAGE_TEMPLATE/SERVICE/${service}}:latest .
		rm ping.sh
	)
done

