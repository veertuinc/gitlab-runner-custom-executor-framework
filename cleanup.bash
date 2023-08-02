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
set -E # required to get exit code from while ()
BASE=${BACKOFF_BASE:-1}
MAX=${BACKOFF_MAX:-60}
FAILURES=0
while (
  # cleanup logic here
) 2>&1; RC=$?; [[ $RC -ne 0 ]]; do
  FAILURES=$(( $FAILURES + 1 ))
  SECONDS=$(( ($BASE * 2) ** ($FAILURES - 1) ))
  if [[ $SECONDS -ge $MAX ]]; then
    SECONDS=$MAX
  fi
  print_warning "$FAILURES failure(s), retrying in $SECONDS second(s)" >&2
  sleep $SECONDS
  echo
done
