#!/usr/bin/env bash

set -euo pipefail

dc_test() {
	IMAGE_NAME=${IMAGE_NAME} \
	SERVICE_FOLDER=$(pwd)/${SERVICE_FOLDER} \
	docker-compose \
	-f scripts/test_service.yml \
	-f ${SERVICE_FOLDER}/service.yml \
	"$@"
}

cleanup() {
	dc_test kill
	dc_test down
}

cleanup || true
trap cleanup EXIT

echo
echo "[TEST] Expect a large amount of attempts to be sufficient" 
echo

if ! dc_test run --rm test_waiter_success ; then
	echo "TEST FAILED"
	exit 1
fi

if [ -f ${SERVICE_FOLDER}/test_failure.env ] ; then
	cleanup

	echo
	echo "[TEST] Expect a small amount of attempts to cause an error"
	echo
	if dc_test run --rm test_waiter_failure ; then
		echo "TEST FAILED"
		exit 1
	fi
fi

echo
echo "TEST SUCCEDED"
echo
