# ansible-playbook for personal macOS setup

## Fresh Mac

1. Command line tools and [Homebrew](https://brew.sh/). Run the `brew shellenv` lines the Homebrew installer prints, so `brew` is on PATH in this terminal.

   ```bash
   xcode-select --install
   ```

2. iTerm2 (optional), then continue in it. Colors: Settings → Profiles → Colors → Color Presets → Solarized Dark.

   ```bash
   brew install --cask iterm2
   ```

3. GitHub over SSH: set up the SSH key, then make HTTPS GitHub URLs use SSH (also avoids Homebrew's GitHub API token, [source](https://gist.github.com/bef/37d481764819187bad996cef0a30143b)):

   ```bash
   git config --global --add url."git@github.com:".insteadOf "https://github.com/"
   ```

4. Clone to exactly this path (Claude, Cursor and Skillshare symlink into it), then copy `.vault-pw` (gitignored) into the repo root. If SSH isn't working yet, try HTTPS (`https://github.com/Snurppa/snurppa-ansible.git`) while the repo is public, before step 3's `insteadOf` turns it back into SSH.

   ```bash
   git clone git@github.com:Snurppa/snurppa-ansible.git ~/code/snurppa-ansible
   ```

5. Ansible via uv, then open a new terminal:

   ```bash
   brew install uv
   uv tool install --with-executables-from ansible-core,ansible-lint ansible
   uv tool update-shell
   ```

6. Everything that doesn't need sudo:

   ```bash
   cd ~/code/snurppa-ansible && ansible-playbook main.yml --skip-tags sudo
   ```

   Casks that install a `.pkg` call sudo themselves and can fail here; install those by hand with `brew install --cask <name>`.

7. The sudo tasks: Homebrew zsh as login shell (needs step 6's zsh), open files limit. The password is your login password.

   ```bash
   ansible-playbook main.yml --tags sudo --ask-become-pass
   ```

8. Private git signing setup (not in this repo): `~/.gitconfig.local` with `commit.gpgsign`, `user.signingkey`, `gpg.format`, `gpg.ssh.program` and `gpg.ssh.allowedSignersFile`, plus the allowed signers file. Claude Code commits unsigned (`GIT_CONFIG_*` env in its settings).

9. Open a new terminal.

## Existing Mac

Bring the machine back in line with the repo (re-running is safe, finished tasks are skipped):

```bash
ansible-playbook main.yml --skip-tags sudo
```

Single parts with tags, e.g. `--tags ai`, `--tags zsh`. Run `--tags sudo --ask-become-pass` only when the sudo tasks changed.

## How it runs

Order: Homebrew packages (`pre_tasks`) → roles (zsh, [mise](https://mise.jdx.dev), skillshare, claude-code, cursor, …) → tasks. `--tags ai` also brings mise along.

uv fetches its own Python, no pyenv or pip needed. Homebrew's own `python@3.x` formulae are dependencies of other formulae; leave them alone.

Repo tools such as gitleaks are pinned in `mise.toml`; `--tags gitleaks` trusts and installs them, or by hand: `mise trust && mise install`.

# Agent harnesses migration

Only generic, personal AI tool config is bootstrapped from here (`--tags ai`). Everything project-specific stays in the project (e.g. `.claude/settings.local.json`) or is migrated by hand.

* **Skills, MCP servers:** `roles/skillshare`. Own skills live in `skills/` and are linked into Skillshare. Third-party skills and MCP servers are lists in `roles/skillshare/defaults/main.yml`, installed at bootstrap. Skillshare's `config.yaml` is created with `skillshare init` only when missing. The sync is one-way: whatever is installed or tried later stays on that machine until it is added here on purpose.
* **Tool settings:** one role per tool.
   * `roles/claude-code`: `~/.claude/settings.json` is a symlink to the file in the repo.
   * `roles/cursor`: settings.json and keybindings.json are symlinked from the repo, `~/.cursor/cli-config.json` is seeded once (Cursor CLI writes state into it). `mcp.json` is Skillshare's.
* **Secret scan:** `--tags gitleaks` installs gitleaks (pinned in `mise.toml`) and points `core.hooksPath` at `.githooks`, so staged changes are scanned on commit. For a false positive add `# gitleaks:allow` on the line or the fingerprint to `.gitleaksignore`.
* **Manual, not synced:**
   * `~/.junie/allowlist.json`: project paths, recreate per project.

# Other notes / TODO

- macOS settings
-- Change Mission control bindings for Ctrl+&larr; & Ctrl+&rarr;: Keyboard -> Shortcuts -> Mission Control
-- Remove Cmd+Shift+A "Open man page" keyboard shortcut from Services section
-- Set Screenshots location `defaults write com.apple.screencapture location ~/Screenshots`
- https://adoptopenjdk.net/

# Hints

## Set of tags for different use cases

### Essentials

- --tags bin,git,zsh,bash,bat,fzf,scripts,launchd --skip-tags vscodium,chromedriver,geckodriver,hashicorp,lein

## Completion

<!-- https://unix.stackexchange.com/a/606305 -->
> press ^X? (Ctrl+X ?) instead of Tab to run _complete_debug.
