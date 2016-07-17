#!/usr/bin/env bash

set -euo pipefail

./scripts/images.sh
./scripts/test.sh
