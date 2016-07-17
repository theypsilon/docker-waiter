#!/usr/bin/env bash

set -euo pipefail

readonly CANDIDATE_VERSION=${1}

./build.sh

mv README.latest.md README.md

sed -i -e "s/latest/${CANDIDATE_VERSION}/g" README.md
git add README.md
git commit -m "New version ${CANDIDATE_VERSION}" 
git tag ${CANDIDATE_VERSION}
git checkout ${CANDIDATE_VERSION}

source scripts/common.source

if [[ ${VERSION} != ${CANDIDATE_VERSION} ]] ; then
	echo "ERROR: VERSION does not match CANDIDATE_VERSION."
fi

if [[ ${VERSION} == "latest" ]] ; then
	echo "ERROR: can't release latest, create a tag before running this command."
fi

./scripts/tag.sh

while read image; do
	docker push ${image}
done < ${TAGGED_IMAGES_FILE}

git push origin ${VERSION}
git checkout latest
