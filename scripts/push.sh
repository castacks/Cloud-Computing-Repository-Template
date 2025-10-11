#!/usr/bin/env bash
#
# Created on Wed Sep 04 2024 18:04:56
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute
#
# Copyright Ⓒ 2024 Mukai (Tom Notch) Yu
#

. "$(dirname "$0")"/variables.sh

# docker push "$DOCKER_USER"/"$IMAGE_NAME":"$IMAGE_TAG"

docker buildx bake --file "$(dirname "$0")"/../docker-compose.yml --push
