#!/usr/bin/env bash

set -euo pipefail

source scripts/common.source

cp scripts/README.header.md README.latest.md
for service in ${SERVICES}; do
	echo >> README.latest.md
	echo "### ${IMAGE_TEMPLATE/SERVICE/${service}}:${VERSION}" >> README.latest.md
	echo >> README.latest.md
	echo "Configuration of ${service} would be done with following vars:">> README.latest.md
	echo >> README.latest.md
	echo "$(cat services/${service}/README.latest.md)" >> README.latest.md
	echo >> README.latest.md
done
