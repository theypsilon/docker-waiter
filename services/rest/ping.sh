#!/bin/env/bash

set -euo pipefail

RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" ${HTTP_URL})

if [[ "${RESPONSE}" == "${HTTP_STATUS_CODE}" ]] ; then
	return 0;
else
	echo "WRONG RESPONSE: $RESPONSE"
	return 1;
fi
