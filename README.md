# Gitlab Runner Custom Executor Framework

This repo contains a framework for [Gitlab Runner Custom Executors](https://docs.gitlab.com/runner/executors/custom.html). Clone, fork, or use the Template to create your own. All you need to do is modify occurrences of `ANKA_` with your own unique prefix and then add various changes throughout the various .bash scripts for your executor's logic.

---

## Setup

1. Obtain a **Registration Token** from your Gitlab instance/admin.
2. Create a **Runner Token** through the API (be sure to set `${REGISTRATION_TOKEN}` & take note of the token returned in STDOUT):

    ```bash
    curl -s --request POST -H "PRIVATE-TOKEN: ${YOUR_API_TOKEN}" "http://anka.gitlab:8093/api/v4/runners" --form "token=${REGISTRATION_TOKEN}" --form "description=anka-custom-executor" --form "tag_list=anka-macos-vm"
    ```

3. Create your `config.toml`, and update the `_YOUR_GITLAB_INSTANCE_URL_`, `_RUNNER_TOKEN_`, and `_PATH_` to the appropriate values.

    ```toml
    concurrent = 2
    check_interval = 0
    shutdown_timeout = 0
    [session_server]
      session_timeout = 1800
    [[runners]]
      name = "anka-custom-executor"
      url = "_YOUR_GITLAB_INSTANCE_URL_"
      token = "_RUNNER_TOKEN_"
      executor = "custom"
      environment = [
        "ANKA_ENABLE_JOB_DEBUG_LOGGING=false"
      ]
      [runners.custom]
        config_exec = "_PATH_/config.bash"
        config_exec_timeout = 200
        prepare_exec = "_PATH_/prepare.bash"
        prepare_exec_timeout = 200
        run_exec = "_PATH_/run.bash"
        cleanup_exec = "_PATH_/cleanup.bash"
        cleanup_exec_timeout = 200
        graceful_kill_timeout = 200
        force_kill_timeout = 200
    ```

4. Execute `gitlab-runner install`, `gitlab-runner start`, and finally `gitlab-runner verify`.

---

### Environment Variables

- ENVs are added under the `[[runners]]` (not `[runners.custom]`) and then under its `environment = [`.
- These are applied to all jobs that run through the gitlab-runner instance.
- Variables set in `.gitlab-ci.yml` override what is in the `config.toml`.

#### ANKA_ENABLE_JOB_DEBUG_LOGGING (string+boolean)

Allows users to enable debug output for the **job log** showing CUSTOM_ENVs and other custom executor script STDOUT/ERR.

##### config.toml

```toml
[[runners]]
  . . .
  environment = [
    "ANKA_ENABLE_JOB_DEBUG_LOGGING=true",
  . . .
```

##### .gitlab-ci.yml

```yaml
test:
  tags:
    - anka-macos-vm
  . . .
  variables:
    ANKA_ENABLE_JOB_DEBUG_LOGGING: "true"
  . . .
```

## Tests

- Execute `.tools/test.bash`.
- Tests check output of various scripts to ensure they're doing what they are supposed to.
- Runs through Github Actions too on PR and manually.
