#!/usr/bin/env bash
echo "] RUNNING TESTS"
set -aeo pipefail
CUSTOM_ENV_ANKA_ENABLE_JOB_DEBUG_LOGGING=true

# CONFIG
echo "]] Testing config.bash"

CONFIG_OUTPUT="$(./config.bash)"
[[ "${CONFIG_OUTPUT}" =~ '
  "job_env" : {
    "ANKA_ENABLE_JOB_DEBUG_LOGGING": "true"
  }
' ]] || (echo "unable to find job_env ANKA_ENABLE_JOB_DEBUG_LOGGING" && exit 1)
[[ "${CONFIG_OUTPUT}" =~ "\"runner_arch\": \"$(arch)\"" ]] || (echo "unable to find job_env ANKA_ENABLE_JOB_DEBUG_LOGGING" && exit 2)

CUSTOM_ENV_ANKA_TEST_ONE=123
[[ "$(./config.bash)" =~ '
  "job_env" : {
    "ANKA_ENABLE_JOB_DEBUG_LOGGING": "true",
"ANKA_TEST_ONE": "123"
  }
' ]] || (echo "unable to find job_env ANKA_TEST_ONE" && exit 3)

# PREPARE
echo "]] Testing prepare.bash"

ANKA_ENABLE_JOB_DEBUG_LOGGING=true
PREPARE_OUTPUT="$(./prepare.bash)"
[[ 
  "${PREPARE_OUTPUT}" =~ 'ANKA_ENABLE_JOB_DEBUG_LOGGING=true'
  && ! "${PREPARE_OUTPUT}" =~ 'ANKA_TEST_ONE=true'
]] || (echo "unable to find ANKA_ENABLE_JOB_DEBUG_LOGGING in output" && exit 4)

# RUN
echo "]] Testing run.bash"


# CLEANUP
echo "]] Testing cleanup.bash"


set +x
echo "] SUCCESS"