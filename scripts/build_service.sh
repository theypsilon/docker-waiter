#!/usr/bin/env bash

set -euo pipefail

source scripts/common.source

(
	cd services/${1}
	docker build -t waiter-base:latest .
)

cp services/${1}/ping.sh waiter/

(
	cd waiter
	docker build -t ${IMAGE_TEMPLATE/SERVICE/${1}}:latest .
	rm ping.sh
)
