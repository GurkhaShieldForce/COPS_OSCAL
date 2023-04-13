#!/usr/bin/env bash
# Build and tag the oscal-common-env dockerfile
#
# By default the tag is the sanitized branch name, but can be overidden
#     by an argument.

set -Eeuo pipefail

IMAGE="csd773/oscal-common-env"
BRANCH=$(git branch --show-current)
BRANCH_SANITIZED=${BRANCH/\//_}

TAG="${1:-$BRANCH_SANITIZED}"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

docker build \
    -f "$SCRIPT_DIR/Dockerfile" \
    -t "$IMAGE:$TAG" \
    "$SCRIPT_DIR"

echo "Built and tagged $IMAGE:$TAG, to push run:"
echo "    docker push $IMAGE:$TAG"
