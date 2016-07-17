#!/usr/bin/env bash

set -euo pipefail

source scripts/common.source

if [[ ${VERSION} == "latest" ]] ; then
	echo "ERROR: can't release latest, create a tag before running this command."
fi

while read image; do
	docker push ${image}
done < ${TAGGED_IMAGES_FILE}

git push origin ${VERSION}

./scripts/docs.sh

git stash
git checkout -f latest
git stash pop
git add README.md
git commit -m "New version ${VERSION}"
git push origin
