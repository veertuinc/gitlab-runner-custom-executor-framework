set -a # Export all variables
# Keep this file as lightweight as possible. It runs at the top of EVERY SINGLE SCRIPT.

# Set debug output for scripts
${CUSTOM_ENV_ANKA_ENABLE_JOB_DEBUG_LOGGING:-false} && set -x