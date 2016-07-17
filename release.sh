#!/usr/bin/env bash

set -euo pipefail

source scripts/common.source

readonly VERSION=$(get_candidate_version "$@")
readonly RELEASE_BRANCH=release-${VERSION}
readonly MODIFIED_FILES=$(git ls-files -m)

if [[ "${MODIFIED_FILES}" != "" ]] ; then
	echo "ERROR: Following files are in a modified status, commit them or stash them."
	echo "${MODIFIED_FILES}"
	exit 1
fi

git checkout ${BRANCH} -b ${RELEASE_BRANCH}

cleanup() {
	git checkout ${BRANCH}
	git tag -d ${VERSION} || true
	git branch -D ${RELEASE_BRANCH} || true
}

trap cleanup EXIT

./build.sh

cp README.latest.md README.md

sed -i -e "s/latest/${VERSION}/g" README.md
echo "${VERSION}" > version.txt

git add README.md version.txt
git commit -m "New version ${VERSION}" 

git tag -a ${VERSION} -m "Version ${VERSION}"

git checkout ${VERSION}

git push origin ${VERSION}

./scripts/tag.sh
./scripts/push.sh

git checkout latest
git pull
git merge ${RELEASE_BRANCH}
git push origin latest
git checkout ${BRANCH}
git merge latest
git push origin ${BRANCH}

