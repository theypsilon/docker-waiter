#!/usr/bin/env bash

set -euo pipefail

source scripts/common.source

cp scripts/README.header.md README.md
for service in ${SERVICES}; do
	echo >> README.md
	echo "## ${IMAGE_TEMPLATE/SERVICE/${service}}:${VERSION}" >> README.md
	echo >> README.md
	echo "Configuration of ${service} would be done with following vars:">> README.md
	echo >> README.md
	echo "$(cat services/${service}/README.md)" >> README.md
	echo >> README.md
done
