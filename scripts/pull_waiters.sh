#!/usr/bin/env bash

set -euo pipefail

for image in $(grep -o '[a-zA-Z0-9]\+/docker-waiter-[a-zA-Z0-9]\+:[0-9]\+\.[0-9]\+\.[0-9]\+' README.md | sort | uniq) ; do
    docker  pull ${image}
done
