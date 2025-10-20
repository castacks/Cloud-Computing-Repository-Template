#!/usr/bin/env bash
#
# Created on Wed Sep 04 2024 18:05:17
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute
#
# Copyright Ⓒ 2024 Mukai (Tom Notch) Yu
#

set -euo pipefail

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

set -a
set +u
. "$(dirname "$0")"/../.env
set -u
set +a

# export additional derived variables below if needed, e.g. resolved absolute paths
# SOME_PATH="$(resolve_host_path "${SOME_PATH:-}")"
# export SOME_PATH
BASE_FOLDER="$(resolve_host_path "$(dirname "$0")"/..)"
export BASE_FOLDER
