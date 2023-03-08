# Gitlab Runner Custom Executor Framework

This repo contains a framework for [Gitlab Runner Custom Executors](https://docs.gitlab.com/runner/executors/custom.html). Clone, fork, or use the Template to create your own. All you need to do is modify occurrences of `ANKA_` with your own unique prefix and then add various changes throughout the various .bash scripts for your executor.

---

## Before You Begin

- All `CUSTOM_ENV_` found will be converted into `ANKA_` versions (without `CUSTOM_ENV_`) in the `config.bash>job_env`. This is so any variables we generate inside `config.bash` can be overwritten in the `config.toml` or `yml` for the job. For devs/TLDR: The only files that should care about `CUSTOM_ENV_` ENVs in are `config.bash` and `shared.bash`; all others should use `ANKA_`.

## Environment Variables

- ENVs are added under the `[[runners]]` (not `[runners.custom]`) and then under its `environment = [`.
- These are applied to all jobs that run through the gitlab-runner instance.
- Variables set in `.gitlab-ci.yml` override what is in the `config.toml`.

### ANKA_ENABLE_JOB_DEBUG_LOGGING (string+boolean)

Allows users to enable debug output for the **job log** showing CUSTOM_ENVs and other custom executor script STDOUT/ERR.

#### config.toml

```toml
[[runners]]
  . . .
  environment = [
    "ANKA_ENABLE_JOB_DEBUG_LOGGING=true",
  . . .
```

#### .gitlab-ci.yml

```yaml
test:
  tags:
    - anka
  . . .
  variables:
    ANKA_ENABLE_JOB_DEBUG_LOGGING: "true"
  . . .
```

## Tests

- Execute `.tools/test.bash`.
- Tests check output of various scripts to ensure they're doing what they are supposed to.
- Runs through Github Actions too on PR and manually.
