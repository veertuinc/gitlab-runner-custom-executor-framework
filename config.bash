#!/usr/bin/env bash
# DO NOT RETURN ANYTHING BUT THE JSON BELOW UNLESS IT'S TO STDERR
# DO NOT USE ANKA_ VERSIONS OF ENVS IN ONLY THIS FILE
echo "=======================" >&2
echo "] Configuring..." >&2
# get current script path
SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
. "${SCRIPT_DIR}/shared.bash"
ANKA_CUSTOM_EXECUTOR_VERSION="$(cat ${SCRIPT_DIR}/VERSION)"
set -eo pipefail
####################################
# We can generate api tokens here and set the results to variables which are then added to job_env below.
## Be sure to assign them to ANKA_ ENVs so that users can override them with CUSTOM_ENVs passed in under yml or config.toml
# We could use a user passed in CUSTOM_ENV_ANKA_CUSTOM_EXECUTOR_VERSION to trigger specific logic, if needed


#############################
# job_env is where we can put ENVs that will be available to all steps in the executor.
# We need to interpolate the CUSTOM_ENVS* into the job_env to override ones generated earlier in this script
CUSTOM_ENVS="$(env | grep CUSTOM_ENV_ANKA)"
CUSTOM_ENVS_COUNT="$(echo "${CUSTOM_ENVS}" | wc -l | xargs)"
CONFIG=$(cat <<EOS
{
  "builds_dir": "${HOME}/builds/${CUSTOM_ENV_CI_CONCURRENT_PROJECT_ID}/${CUSTOM_ENV_CI_PROJECT_PATH_SLUG}",
  "cache_dir": "${HOME}/caches/${CUSTOM_ENV_CI_CONCURRENT_PROJECT_ID}/${CUSTOM_ENV_CI_PROJECT_PATH_SLUG}",
  "builds_dir_is_shared": true,
  "runner_hostname": "$(hostname)",
  "runner_arch": "$(arch)",
  "driver": {
    "name": "Anka Gitlab Custom Executor",
    "version": "${ANKA_CUSTOM_EXECUTOR_VERSION}"
  },
  "job_env" : {
    $(for FOUND_ENV in ${CUSTOM_ENVS}; do
      [[ ${CUSTOM_ENVS_COUNT} -gt 1 ]] && COMMA="," || COMMA=
      FOUND_ENV="${FOUND_ENV#CUSTOM_ENV_}"
      FOUND_ENV="\"${FOUND_ENV/=/\": \"}\"${COMMA}"
      echo "${FOUND_ENV}"
      ((CUSTOM_ENVS_COUNT--))
    done)
  }
}
EOS
)

set +x;echo "${CONFIG}";
if ${CUSTOM_ENV_ANKA_ENABLE_JOB_DEBUG_LOGGING:-false}; then set -x; fi