#!/usr/bin/env bash
#
# Created on Wed Sep 04 2024 18:04:56
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute
#
# Copyright Ⓒ 2024 Mukai (Tom Notch) Yu
#

set -euo pipefail

before_env="$(mktemp)"
after_env="$(mktemp)"
tmp_dockerfile="$(mktemp)"
cleanup() { rm -f "${before_env}" "${after_env}" "${tmp_dockerfile}"; }
trap cleanup EXIT

env | sort >"${before_env}"

set -a
. "$(dirname "$0")"/variables.sh
set +a

env | sort >"${after_env}"

diff_env="$(
	awk -F= '
    NR==FNR { before[$1]=$0; next }
    {
      name=$1
      if (!(name in before) || before[name] != $0)
        printf " ${%s}", name
    }
  ' "${before_env}" "${after_env}"
)"
diff_env="${diff_env# }" # trim leading space

# Check if the builder already exists
if ! docker buildx inspect "${BUILDER}" &>/dev/null; then
	echo "Creating Docker Buildx builder '${BUILDER}'..."
	docker buildx create \
		--name "${BUILDER}" \
		--use --platform linux/amd64,linux/arm64 \
		--driver docker-container
else
	echo "Docker Buildx builder '${BUILDER}' already exists."
	docker buildx use "${BUILDER}"
fi

# environment variable substitution trick
envsubst "${diff_env}" <"$(dirname "$0")/../docker/${IMAGE_TAG}/Dockerfile" >"${tmp_dockerfile}"

echo ">>> Substituted dockerfile:"
echo "----------------------------------------"
cat "${tmp_dockerfile}"
echo "----------------------------------------"

# docker push "${DOCKER_USER}"/"${IMAGE_NAME}":"${IMAGE_TAG}"

docker buildx bake --file "$(dirname "$0")"/../docker-compose.yml --push --set "*.dockerfile=${tmp_dockerfile}"
