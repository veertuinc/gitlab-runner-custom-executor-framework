#!/usr/bin/env bash
# cleanup stage does not retry using $SYSTEM_FAILURE_EXIT_CODE
echo "] Cleaning..."
SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
. "${SCRIPT_DIR}/shared.bash"
set -eo pipefail
cleanup () {
  echo "logic you have to ensure runs, regardless of failures"
}
trap cleanup EXIT
RETRIES=4
while [[ $((RETRIES=RETRIES-1)) -gt 0 ]] || (echo "ERROR: cleanup hit max retries" && false); do
  sleep 5
  (
    echo "cleanup code here"
  ) || [[ $? -ne $RETRY_STEP_EXIT_CODE ]] && break
done

