#!/usr/bin/env bash

set -euo pipefail

source scripts/common.source

# building
for service in ${SERVICES}; do
	./scripts/build_service.sh ${service}
done
