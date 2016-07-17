#!/usr/bin/env bash

set -euo pipefail

./scripts/images.sh
./scripts/test.sh
./scripts/tag.sh
./scripts/docs.sh
