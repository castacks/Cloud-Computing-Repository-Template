#!/usr/bin/env bash
#
# Created on Wed Sep 04 2024 18:04:23
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute
#
# Copyright Ⓒ 2024 Mukai (Tom Notch) Yu
#

. "$(dirname "$0")"/variables.sh

# Determine the local platform
if [[ "$(uname -m)" == "x86_64" ]]; then
	LOCAL_PLATFORM="linux/amd64"
elif [[ "$(uname -m)" == "arm64" ]]; then
	LOCAL_PLATFORM="linux/arm64"
else
	echo "Unsupported local platform: $(uname -m)"
	exit 1
fi

# Desired builder name
BUILDER_NAME="multi-platform"

# Check if the builder already exists
if ! docker buildx ls | grep -q "^${BUILDER_NAME} "; then
	echo "Creating Docker Buildx builder '${BUILDER_NAME}'..."
	docker buildx create \
		--name "${BUILDER_NAME}" \
		--use --platform linux/amd64,linux/arm64 \
		--driver docker-container
else
	echo "Docker Buildx builder '${BUILDER_NAME}' already exists."
fi

# Build the Docker image for only the local platform, push.sh will push multi-platform version
docker buildx bake --file "$(dirname "$0")"/../docker-compose.yml --load --set "*.platform=$LOCAL_PLATFORM"
