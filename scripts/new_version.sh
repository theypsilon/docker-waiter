#!/usr/bin/env bash

set -xeuo pipefail

new_version() {
	readonly LATEST_TAG=$(git describe --tag)
	if ! [[ ${LATEST_TAG} =~ ([0-9]*).([0-9]*).([0-9]*) ]] ; then
		echo "ERROR: last tag is wrong formatted"
	fi

	MAJOR=${BASH_REMATCH[1]}
	MINOR=${BASH_REMATCH[2]}
	PATCH=${BASH_REMATCH[3]}

	case "${1:---patch}" in
		--minor)
		    MINOR=$(($MINOR + 1))
		    ;;
		--major)
		    MAJOR=$(($MAJOR + 1))
		    ;;
		--patch)
		    PATCH=$(($PATCH + 1))
		    ;;
		*)
			echo "ERROR: Unrecognized option '${1}'"
			echo "Usage: ${0} [--major] | [--minor] | [--patch]"
			exit 1
	esac
	readonly CANDIDATE_VERSION="${MAJOR}.${MINOR}.${PATCH}"

	echo "${CANDIDATE_VERSION}"	
}
