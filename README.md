# ansible-playbook for personal macOS setup

For Homebrew GitHub API Token, set communication to SSH instead of HTTPS.
```
git config --global --add url."git@github.com:".insteadOf "https://github.com/"
```
Source: [https://gist.github.com/bef/37d481764819187bad996cef0a30143b](https://gist.github.com/bef/37d481764819187bad996cef0a30143b)

Provision your macOS by running:

```bash
ansible-playbook main.yml --ask-become-pass
```


# Requirements

On a fresh Mac, in order:

```bash
xcode-select --install
```

Install [Homebrew](https://brew.sh/), then:

```bash
brew install uv
uv tool install --with-executables-from ansible-core,ansible-lint ansible
uv tool update-shell
```

uv fetches its own Python, no pyenv or pip needed. Homebrew's own `python@3.x` formulae are dependencies of other formulae; leave them alone.

# Agent harnesses migration

Only generic, personal AI tool config is bootstrapped from here (`--tags ai`). Everything project-specific stays in the project (e.g. `.claude/settings.local.json`) or is migrated by hand.

* **Skills, MCP servers:** `roles/skillshare`. Own skills live in `skills/` and are linked into Skillshare. Third-party skills and MCP servers are lists in `roles/skillshare/defaults/main.yml`, installed at bootstrap. Skillshare's `config.yaml` is seeded only when missing. The sync is one-way: whatever is installed or tried later stays on that machine until it is added here on purpose.
* **Tool settings:** one role per tool.
   * `roles/claude-code`: `~/.claude/settings.json` is a symlink to the file in the repo.
   * `roles/cursor`: settings.json and keybindings.json are symlinked from the repo, `~/.cursor/cli-config.json` is seeded once (Cursor CLI writes state into it). `mcp.json` is Skillshare's.
* **Secret scan:** `--tags gitleaks` installs gitleaks and points `core.hooksPath` at `.githooks`, so staged changes are scanned on commit. For a false positive add `# gitleaks:allow` on the line or the fingerprint to `.gitleaksignore`.
* **Manual, not synced:**
   * `~/.junie/allowlist.json`: project paths, recreate per project.

# Other notes / TODO

- macOS settings
-- Change Mission control bindings for Ctrl+&larr; & Ctrl+&rarr;: Keyboard -> Shortcuts -> Mission Control
-- Remove Cmd+Shift+A "Open man page" keyboard shortcut from Services section
-- Set Screenshots location `defaults write com.apple.screencapture location ~/Screenshots`
- https://adoptopenjdk.net/
- iTerm + Solarized: Color -> Color Presets -> Solarized (https://gist.github.com/kevin-smets/8568070)

# Hints

## Set of tags for different use cases

### Essentials

- --tags bin,git,zsh,bash,bat,fzf,scripts,launchd --skip-tags vscodium,chromedriver,geckodriver,hashicorp,lein

## Completion

<!-- https://unix.stackexchange.com/a/606305 -->
> press ^X? (Ctrl+X ?) instead of Tab to run _complete_debug.
