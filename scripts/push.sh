#!/usr/bin/env bash

set -xeuo pipefail

source scripts/common.source

# pushing
for service in ${SERVICES}; do
	IMAGE_LATEST="${IMAGE_TEMPLATE/SERVICE/${service}}:latest"
	IMAGE_TAGGED="${IMAGE_TEMPLATE/SERVICE/${service}}:${VERSION}"
	docker push ${IMAGE_LATEST} ${IMAGE_TAGGED}
done
