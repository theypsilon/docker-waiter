#!/usr/bin/env bash

set -euo pipefail

./scripts/build_images.sh
./scripts/test.sh

echo
echo "BUILD DONE"
echo

docker images --format '{{.Repository}}:{{.Tag}}' \
	| grep theypsilon/waiter- \
	| grep -v theypsilon/waiter-base:latest \
	| grep latest 
