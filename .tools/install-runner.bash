#!/bin/bash
set -exo pipefail
SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd)
cd $SCRIPT_DIR

SHARED_RUNNER_NAME="anka-custom-executor"
GITLAB_RUNNER_DESTINATION="/usr/local/bin/gitlab-runner"

# Cleanup
echo "]] Cleaning up previous runners..."
"${GITLAB_RUNNER_DESTINATION}" stop || true
"${GITLAB_RUNNER_DESTINATION}" unregister -n "${SHARED_RUNNER_NAME}" || true
# "${GITLAB_RUNNER_DESTINATION}" unregister -n "localhost specific runner" || true
"${GITLAB_RUNNER_DESTINATION}" uninstall || true
[[ -e "${GITLAB_RUNNER_DESTINATION}" ]] && rm -f "${GITLAB_RUNNER_DESTINATION}"

if [[ $1 != "--uninstall" ]]; then

  # Install
  [[ ! -f "${GITLAB_RUNNER_DESTINATION}" ]] && \
    curl --output "${GITLAB_RUNNER_DESTINATION}" "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-darwin-amd64"
  sudo chmod +x "${GITLAB_RUNNER_DESTINATION}"

  # register it
  export SHARED_REGISTRATION_TOKEN="$(docker exec -i anka.gitlab bash -c "gitlab-rails runner -e production \"puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token\"")"
  export SHARED_RUNNER_TOKEN=$(curl -s --request POST -H "PRIVATE-TOKEN: token-string-here123" "http://anka.gitlab:8093/api/v4/runners" --form "token=${SHARED_REGISTRATION_TOKEN}" --form "description=custom-executor-test" --form "tag_list=anka-macos-vm" | jq -r '.token' )

mkdir -p ~/.gitlab-runner
cat << EOF > ~/.gitlab-runner/config.toml
concurrent = 2
log_level = "debug" # needed for gitlab-runner to log cleanup.bash STDOUT/ERR (not in job logs)
log_format = "text"
check_interval = 0
shutdown_timeout = 0
[session_server]
  session_timeout = 1800
[[runners]]
  name = "${SHARED_RUNNER_NAME}"
  url = "http://anka.gitlab:8093/"
  token = "${SHARED_RUNNER_TOKEN}"
  executor = "custom"
  # ENVs below will be prefixed with CUSTOM_ENV_
  environment = [
    "ANKA_ENABLE_JOB_DEBUG_LOGGING=true",
    "ANKA_CONTROLLER_API_TOKEN=in-runner-toml",
    "ANKA_CONTROLLER_CERT_LOCATION=",
    "ANKA_REGISTRY_CERT_LOCATION=",
    "ANKA_CONTROLLER_CA_CERT_LOCATION=",
    "ANKA_REGISTRY_CA_CERT_LOCATION=",
    "ANKA_CONTROLLER_SKIP_TLS_VERIFY=false",
    "ANKA_REGISTRY_SKIP_TLS_VERIFY=false"
  ]
  [runners.custom]
    config_exec = "${SCRIPT_DIR}/config.bash"
    config_exec_timeout = 200
    prepare_exec = "${SCRIPT_DIR}/prepare.bash"
    prepare_exec_timeout = 200
    run_exec = "${SCRIPT_DIR}/run.bash"
    cleanup_exec = "${SCRIPT_DIR}/cleanup.bash"
    cleanup_exec_timeout = 200
    graceful_kill_timeout = 200
    force_kill_timeout = 200
EOF

  pushd ~/ # set working dir
    "${GITLAB_RUNNER_DESTINATION}" install
    "${GITLAB_RUNNER_DESTINATION}" start
    "${GITLAB_RUNNER_DESTINATION}" verify
  popd
fi
