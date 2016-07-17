#!/usr/bin/env bash

set -euo pipefail

source scripts/common.source

# tagging
for service in ${SERVICES}; do
	IMAGE_LATEST="${IMAGE_TEMPLATE/SERVICE/${service}}:latest"
	IMAGE_TAGGED="${IMAGE_TEMPLATE/SERVICE/${service}}:${BRANCH}"
	docker tag ${IMAGE_LATEST} ${IMAGE_TAGGED}
done
