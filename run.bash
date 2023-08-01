#!/usr/bin/env bash
echo "======================="
echo "] Running ${!#}..."
SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
. "${SCRIPT_DIR}/shared.bash"
set -eo pipefail
# ensure we only ever retry the specific step, not the whole job (and all steps)
cleanup_run () {
  [[ $? -eq $BUILD_FAILURE_EXIT_CODE ]] && exit $BUILD_FAILURE_EXIT_CODE || exit $RETRY_STEP_EXIT_CODE
}
trap cleanup_run ERR
# ${@: -2} is necessary since config.toml run_args come before the actual script and step name arguments
"${@: -2}"
