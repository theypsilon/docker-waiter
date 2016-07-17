#!/bin/env/bash

set -euo pipefail

mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} --port ${MYSQL_PORT} --host ${MYSQL_HOST} \
	-e 'select 1'
