#!/usr/bin/env bash

set -xeuo pipefail

readonly MODIFIED_FILES=$(git ls-files -m)

if [[ "${MODIFIED_FILES}" != "" ]] ; then
	echo "ERROR: Following files are in a modified status, commit them or stash them."
	echo "${MODIFIED_FILES}"
	exit 1
fi

./scripts/new_version.sh

readonly CANDIDATE_VERSION=$(cat candidate-version.txt)
readonly BACKUP_COMMIT=$(git rev-parse HEAD)

./build.sh

cp README.latest.md README.md

sed -i -e "s/latest/${CANDIDATE_VERSION}/g" README.md
git add README.md
git commit -m "New version ${CANDIDATE_VERSION}" 
git tag ${CANDIDATE_VERSION}

error_handling() {
	git tag -d ${CANDIDATE_VERSION}
	git checkout latest
	git reset HEAD ${BACKUP_COMMIT}
}

trap error_handling EXIT

git checkout ${CANDIDATE_VERSION}

source scripts/common.source

if [[ ${VERSION} != ${CANDIDATE_VERSION} ]] ; then
	echo "ERROR: VERSION does not match CANDIDATE_VERSION."
	exit 1
fi

if [[ ${VERSION} == "latest" ]] ; then
	echo "ERROR: can't release latest, create a tag before running this command."
	exit 1
fi

./scripts/tag.sh

$asdfsd-asdfasd

while read image; do
	docker push ${image}
done < ${TAGGED_IMAGES_FILE}

git push origin ${VERSION}
git checkout latest
git push origin latest

trap - EXIT
