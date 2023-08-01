#!/usr/bin/env bash
echo "] Cleaning..."
SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
. "${SCRIPT_DIR}/shared.bash"
set -eo pipefail
# cleanup stage does not retry using $SYSTEM_FAILURE_EXIT_CODE
RETRIES=3
while ! (
  [[ $RETRIES -gt 0 ]] || (echo "ERROR: cleanup hit max retries" && exit $BUILD_FAILURE_EXIT_CODE)
  echo "cleanup logic here"
) ; do
  ((RETRIES=RETRIES-1))
  sleep 1
done
