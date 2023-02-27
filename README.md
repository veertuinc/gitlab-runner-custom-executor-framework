# Gitlab Runner Custom Executor Framework

This repo shows how to build a [custom executor for Gitlab Runners](https://docs.gitlab.com/runner/executors/custom.html). Simply clone this repo, and then add the appropriate code to the various scripts where needed.

Before you start:

- All `CUSTOM_ENV_` found will be converted into `ANKA_` versions (without `CUSTOM_ENV_`) in the `config.bash>job_env`. This is so any variables we generate inside `config.bash` can be overwritten in the `config.toml` or `yml` for the job. For devs/TLDR: The only files that should care about `CUSTOM_ENV_` ENVs in are `config.bash` and `shared.bash`; all others use `ANKA_`.

---

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
