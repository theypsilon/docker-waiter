#!/bin/env/bash

set -euo pipefail

ping_script() {
	if [[ "${WAITER_DEBUG:-false}" == "true" ]] ; then
		source "ping.sh"
	else
		source "ping.sh" >/dev/null 2>&1 < /dev/null
	fi
}

echo "[WAITER] WAITER_ATTEMPTS: ${WAITER_ATTEMPTS} | WAITER_ATTEMPT_SLEEPTIME: ${WAITER_ATTEMPT_SLEEPTIME}"
echo -n "[WAITER] "
for ((i=1;i<=${WAITER_ATTEMPTS};i++)) ; do
	if ! ping_script ; then
		echo -n "."
		sleep ${WAITER_ATTEMPT_SLEEPTIME}s
	else
		echo " OK"
		exit 0
	fi
done
echo
echo "[WAITER] ERROR: No response after ${WAITER_ATTEMPTS} attempts."
exit 1