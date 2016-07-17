#!/usr/bin/env bash

set -euo pipefail

source scripts/common.source


readonly CANDIDATE_VERSION=$(get_candidate_version "$@")

./build.sh

cp README.latest.md README.md

sed -i -e "s/latest/${CANDIDATE_VERSION}/g" README.md
git add README.md
git commit -m "New version ${CANDIDATE_VERSION}" 
git tag ${CANDIDATE_VERSION}

error_handling() {
	echo "ROLLING BACK"
	git tag -d ${CANDIDATE_VERSION}
	git checkout latest
	git reset --hard HEAD~1
}

trap error_handling EXIT

git checkout ${CANDIDATE_VERSION}

./scripts/tag.sh
./scripts/push.sh

git push origin ${CANDIDATE_VERSION}

trap - EXIT

git checkout latest
git pull
git push origin latest
