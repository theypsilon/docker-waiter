#!/bin/env/bash

set -euo pipefail

RESPONSE=$(curl --silent  "http://${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/_cluster/health")
if [[ $( echo "${RESPONSE}" | jq .status ) == '"green"' ]] || [[ $( echo "${RESPONSE}" | jq .status ) == '"yellow"' ]] ; then
	return 0;
else
	echo "WRONG RESPONSE: $RESPONSE"
	return 1;
fi

