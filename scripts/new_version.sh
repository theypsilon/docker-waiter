#!/usr/bin/env bash

set -xeuo pipefail


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
echo "${CANDIDATE_VERSION}" >> candidate-version.txt
