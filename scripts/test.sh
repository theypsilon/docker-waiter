#!/usr/bin/env bash

set -euo pipefail

source scripts/common.source

# testing
for service in ${SERVICES}; do
	IMAGE_NAME=${IMAGE_TEMPLATE/SERVICE/${service}} \
	SERVICE_FOLDER=services/${service} \
	./scripts/test_service.sh
done

