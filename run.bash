#!/usr/bin/env bash
# DO NOT USE CUSTOM_ENV_ ENVS IN THIS FILE. USE ANKA_ VERSIONS
echo "======================="
echo "] Running ${!#}..."
SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
. "${SCRIPT_DIR}/shared.bash"
set -eo pipefail
# ${@: -2} is necessary since config.toml run_args come before the actual script and step name arguments
"${@: -2}"