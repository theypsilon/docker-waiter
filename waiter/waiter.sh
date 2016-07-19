#!/bin/env/bash

set -euo pipefail

WAITER_TIMEOUT=${WAITER_TIMEOUT:-50}
WAITER_ATTEMPT_SLEEPTIME=${WAITER_ATTEMPT_SLEEPTIME:-5}

ping_script() {
	if [[ "${WAITER_DEBUG:-false}" == "true" ]] ; then
		source "ping.sh"
	else
		source "ping.sh" >/dev/null 2>&1 < /dev/null
	fi
}

echo "[WAITER] WAITER_TIMEOUT: ${WAITER_TIMEOUT} | WAITER_ATTEMPT_SLEEPTIME: ${WAITER_ATTEMPT_SLEEPTIME}"
echo -n "[WAITER] "

echo "false" > timeout_done

(
	sleep ${WAITER_TIMEOUT}s
	echo "true" > timeout_done
) &

while [[ "$(cat timeout_done)" != "true" ]] ; do
	if ! (ping_script) ; then
		echo -n "."
		sleep ${WAITER_ATTEMPT_SLEEPTIME}s
	else
		echo " OK"
		exit 0
	fi
done

echo
echo "[WAITER] ERROR: No response after ${WAITER_TIMEOUT} seconds."
exit 1