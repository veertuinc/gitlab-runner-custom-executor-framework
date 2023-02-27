#!/usr/bin/env bash
# DO NOT USE CUSTOM_ENV_ ENVS IN THIS FILE. USE ANKA_ VERSIONS
echo "======================="
echo "] Preparing..."
SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
. "${SCRIPT_DIR}/shared.bash"
${ANKA_ENABLE_JOB_DEBUG_LOGGING:-false} && env | grep "ANKA_"
set -eo pipefail