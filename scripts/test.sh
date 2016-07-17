#!/usr/bin/env bash

set -euo pipefail

source scripts/common.source

# testing
for service in ${SERVICES}; do
	./scripts/test_service.sh ${service}
done

