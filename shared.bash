set -a # Export all variables
PATH="$PATH:/usr/local/bin"

# Keep this file as lightweight as possible. It runs at the top of EVERY SINGLE SCRIPT.

# needed for local testing/running; gitlab makes these available in the runner
BUILD_FAILURE_EXIT_CODE=${BUILD_FAILURE_EXIT_CODE:-1}
SYSTEM_FAILURE_EXIT_CODE=${SYSTEM_FAILURE_EXIT_CODE:-2}

# Set debug output for scripts
CUSTOM_ENV_ANKA_ENABLE_JOB_DEBUG_LOGGING=${CUSTOM_ENV_ANKA_ENABLE_JOB_DEBUG_LOGGING:-false}
if $CUSTOM_ENV_ANKA_ENABLE_JOB_DEBUG_LOGGING; then
  set -x
fi

########################
# FUNCTIONS

print_error () {
  [[ -n "${2}" ]] && CALLING_FUNCTION_NAME="[${2}] "
  echo -en "\033[91m${CALLING_FUNCTION_NAME}error: ${1}\033[0m\n" >&2
}

print_warning () {
  [[ -n "${2}" ]] && CALLING_FUNCTION_NAME="[${2}] "
  echo -en "\033[93m${CALLING_FUNCTION_NAME}warning: ${1}\033[0m\n" >&2
}

print_info () {
  [[ -n "${2}" ]] && CALLING_FUNCTION_NAME="[${2}] "
  echo -en "\033[94m${CALLING_FUNCTION_NAME}info: ${1}\033[0m\n" >&2
}