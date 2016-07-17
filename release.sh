#!/usr/bin/env bash

set -xeuo pipefail

readonly MODIFIED_FILES=$(git ls-files -m)

if [[ "${MODIFIED_FILES}" != "" ]] ; then
	echo "ERROR: Following files are in a modified status, commit them or stash them."
	echo "${MODIFIED_FILES}"
	exit 1
fi


readonly LATEST_TAG=$(git describe --tag)
if ! [[ ${LATEST_TAG} =~ ([0-9]*).([0-9]*).([0-9]*) ]] ; then
	echo "ERROR: last tag is wrong formatted"
fi

MAJOR=${BASH_REMATCH[1]}
MINOR=${BASH_REMATCH[2]}
PATCH=${BASH_REMATCH[3]}

case "${1:---patch}" in
	--minor)
		echo -n "Realeasing MINOR: "
	    MINOR=$(($MINOR + 1))
	    ;;
	--major)
		echo -n "Realeasing MAJOR: "
	    MAJOR=$(($MAJOR + 1))
	    ;;
	--patch)
		echo -n "Realeasing PATCH: " 
	    PATCH=$(($PATCH + 1))
	    ;;
	*)
		echo "ERROR: Unrecognized option '${1}'"
		echo "Usage: ${0} [--major] | [--minor] | [--patch]"
		exit 1
esac
readonly CANDIDATE_VERSION="${MAJOR}.${MINOR}.${PATCH}"

echo "VERSION: ${CANDIDATE_VERSION}"

readonly BACKUP_COMMIT=$(git rev-parse HEAD)

#./build.sh

mv README.latest.md README.md

sed -i -e "s/latest/${CANDIDATE_VERSION}/g" README.md
git add README.md
git commit -m "New version ${CANDIDATE_VERSION}" 
git tag ${CANDIDATE_VERSION}

(
	git checkout ${CANDIDATE_VERSION}

	source scripts/common.source

	if [[ ${VERSION} != ${CANDIDATE_VERSION} ]] ; then
		echo "ERROR: VERSION does not match CANDIDATE_VERSION."
	fi

	if [[ ${VERSION} == "latest" ]] ; then
		echo "ERROR: can't release latest, create a tag before running this command."
	fi

	./scripts/tag.sh

	$asdfsd-asdfasd

	while read image; do
		docker push ${image}
	done < ${TAGGED_IMAGES_FILE}

	git push origin ${VERSION}
	git checkout latest
	git push origin latest

) || (
	git tag -d ${CANDIDATE_VERSION}
	git checkout latest
	git reset HEAD ${BACKUP_COMMIT}
)
