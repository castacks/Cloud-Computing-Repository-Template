#!/usr/bin/env bash
#
# Created on Wed Sep 04 2024 18:05:17
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute
#
# Copyright Ⓒ 2024 Mukai (Tom Notch) Yu
#

resolve_host_path() {
	local p="$1"
	[ -n "$p" ] || {
		echo ""
		return 0
	}

	if command -v realpath >/dev/null 2>&1; then
		realpath -m -- "$p" 2>/dev/null || echo "$p"
	elif readlink -f / >/dev/null 2>&1; then
		readlink -f -- "$p" 2>/dev/null || echo "$p"
	else
		python3 - "$p" <<'PY' 2>/dev/null || echo "$p"
import os, sys
print(os.path.realpath(sys.argv[1]))
PY
	fi
}

. "$(dirname "$0")"/../.env

export XSOCK
export XAUTH
export AVAILABLE_CORES

export DOCKER_USER
export IMAGE_NAME
export IMAGE_TAG

export CONTAINER_NAME
export IMAGE_USER
export HOME_FOLDER
export CODE_FOLDER

export HOST_UID
export HOST_GID
export HOST
export HOSTNAME

export BUILDER
