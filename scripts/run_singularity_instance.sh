#!/usr/bin/env bash
#
# Created on Mon May 05 2025 14:43:08
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute
#
# Copyright Ⓒ 2025 Mukai (Tom Notch) Yu
#

set -euo pipefail
. "$(dirname "$0")/variables.sh"

# Check if an instance with that name exists (skip the header line)
if singularity instance list | awk 'NR>1 {print $1}' | grep -xq "$CONTAINER_NAME"; then
	echo "An instance named ""$CONTAINER_NAME"" is running, stopping it…"
	singularity instance stop "$CONTAINER_NAME"
	echo "Done"
fi

BASE_DIR="$(cd "$(dirname "$0")"/.. && pwd)"

singularity instance start \
	--nv \
	--containall \
	--no-home \
	--no-init \
	--writable-tmpfs \
	--hostname "$(hostname)" \
	--bind "$BASE_DIR":"$HOME_FOLDER"/"$CODE_FOLDER" \
	--bind /var/lib/systemd/coredump/:/cores \
	"$(dirname "$0")/../${IMAGE_NAME}_${IMAGE_TAG}.sif" \
	"${CONTAINER_NAME}"
