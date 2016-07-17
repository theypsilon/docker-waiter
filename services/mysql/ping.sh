#!/bin/env/bash

set -euo pipefail

mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} --port ${MYSQL_PORT} --host ${MYSQL_HOST} \
	-e "${MYSQL_QUERY:-select 1}"
