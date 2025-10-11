#!/usr/bin/env bash
#
# Created on Mon May 05 2025 13:55:27
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute
#
# Copyright Ⓒ 2025 Mukai (Tom Notch) Yu
#

set -euo pipefail

before_env="$(mktemp)"
after_env="$(mktemp)"
tmp_def="$(mktemp)"
cleanup() { rm -f "${before_env}" "${after_env}" "${tmp_def}"; }
trap cleanup EXIT

env | sort >"${before_env}"

set -a
. "$(dirname "$0")"/variables.sh
set +a

after_env="$(mktemp)"
trap 'rm -f "$after_env"' RETURN
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

envsubst "${diff_env}" <"$(dirname "$0")/../singularity/default.def" >"${tmp_def}"

echo ">>> Substituted def file:"
echo "----------------------------------------"
cat "${tmp_def}"
echo "----------------------------------------"

singularity build \
	--fix-perms \
	"$(dirname "$0")/../${IMAGE_NAME}_${IMAGE_TAG}.sif" \
	"${tmp_def}"
