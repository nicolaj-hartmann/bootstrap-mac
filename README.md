# bootstrap-mac

My Mac, as code. New machine:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/nicolaj-hartmann/bootstrap-mac/main/start.sh)"
```

`start.sh` installs the Xcode Command Line Tools, Homebrew, gh and Ansible, logs in to
GitHub, clones this repo to `~/bootstrap-mac` and runs `setup.yml`.

## What it manages

- `setup.yml`: the `packages`, `taps` and `casks` lists at the top are the Homebrew
  inventory. Everything else Homebrew has installed is removed on each run. Personal extras
  on one machine go in a gitignored `setup.local.yml`, see the example.
- `mise.toml`: CLI tools at exact versions, linked into mise's `conf.d`. The `bump`
  workflow opens a PR with new versions every Monday.
- `aliases.yml`: a managed block in `.zshrc`. `resources/zshrc` seeds the file on a fresh
  machine and is never written again.
- `allowed-apps`: apps in `/Applications` that did not come from a cask and should not be
  reported.
- `pins`: formulae held at their installed version.

## Running

First run and whenever the `system` tasks change:

```sh
cd ~/bootstrap-mac && ansible-playbook setup.yml --ask-become-pass
```

Every Monday 09:00 a launchd agent pulls this repo and runs everything except the `system`
tasks, logging to `~/Library/Logs/bootstrap-mac.log` and showing a notification on failure.
`confsync` runs the full thing by hand.
