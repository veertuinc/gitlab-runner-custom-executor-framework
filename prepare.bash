#!/usr/bin/env bash
echo "======================="
echo "] Preparing..."
SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
. "${SCRIPT_DIR}/shared.bash"
${CUSTOM_ENV_ANKA_ENABLE_JOB_DEBUG_LOGGING:-false} && env | grep "ANKA_"
set -eo pipefail
# LAST_RC will allow us to capture if a function throws $BUILD_FAILURE_EXIT_CODE (not retryable) or $SYSTEM_FAILURE_EXIT_CODE (retryable)
cleanup () {
  LAST_RC=$?
  exit $LAST_RC
}
trap cleanup ERR