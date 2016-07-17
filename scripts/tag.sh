#!/usr/bin/env bash

set -euo pipefail

source scripts/common.source

# tagging
rm ${TAGGED_IMAGES_FILE} || true
for service in ${SERVICES}; do
	IMAGE_LATEST="${IMAGE_TEMPLATE/SERVICE/${service}}:latest"
	IMAGE_TAGGED="${IMAGE_TEMPLATE/SERVICE/${service}}:${VERSION}"
	docker tag ${IMAGE_LATEST} ${IMAGE_TAGGED}
	echo ${IMAGE_LATEST} >> ${TAGGED_IMAGES_FILE}
	echo ${IMAGE_TAGGED} >> ${TAGGED_IMAGES_FILE}
done

