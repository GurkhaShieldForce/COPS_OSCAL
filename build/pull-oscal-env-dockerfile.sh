#!/usr/bin/env bash
# Pull the oscal-common-env from the registry using a defined set of tags, and
#   retag the first working image with a new tag.
# This is intended to be used in CI/CD environments where rebuilding the 
#   oscal-common-env would be expensive, but an escape hatch to allow for a
#   "special" image for a run is preferred.

set -Eeuo pipefail

if [ "${GITHUB_REF-}" ]; then
    BRANCH=${GITHUB_REF#refs/heads/}
else
    BRANCH=$(git branch --show-current)
fi

# Docker tags cannot have "/" in them
SANITIZED_BRANCH=${BRANCH/\//_}

TAGS=("${SANITIZED_BRANCH}" "develop")

SOURCE_IMAGE="csd773/oscal-common-env"

# the output image and tag to write to
OUTPUT_IMAGE="oscal-common-env"
OUTPUT_TAG="selected"
OUTPUT_REF="${OUTPUT_IMAGE}:${OUTPUT_TAG}"

for REF in "${SOURCE_IMAGE}:${TAGS[@]}"; do
    docker pull "${REF}" && {
        docker tag "${REF}" "${OUTPUT_REF}"
        echo "Successsfully pulled ${REF} and retagged it as ${OUTPUT_REF}"
        exit 0
    } || echo "Pulling tag ${REF} failed..."
done

echo "Failed to pull any images in"
exit 1
