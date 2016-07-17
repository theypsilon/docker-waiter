#!/usr/bin/env bash

set -xeuo pipefail

source scripts/common.source

# pushing
for service in ${SERVICES}; do
	docker push "${IMAGE_TEMPLATE/SERVICE/${service}}:${VERSION}"
done
