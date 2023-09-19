# ansible-playbook for personal macOS setup

Before you start it's good idea to get a GitHub API token for Homebrew. You can create a token in your [GitHub profile](https://github.com/settings/tokens).

Put your token into `homebrew_token` file into root of this project. Ansible automatically reads `homebrew_token` file and sets this as HOMEBREW_GITHUB_API_TOKEN into `.zshrc`.

Provision your macOS by running:

```bash
ansible-playbook main.yml --ask-become-pass
```


# Requirements

* `xcode-select --install`
* [Homebrew](https://brew.sh/)
* Python via pyenv
   * `brew install pyenv` _(assumes Homebrew handles setting pyenv to PATH)_
   * `pyenv install 3.11`
   * `pyenv global 3.11.X`
   * `eval "$(pyenv init -)"`
   * `pip3 install argcomplete ansible`

# Python trivia (from brew Python vs pyenv)

- Reinstalling brew packages that require Python will pick the latest Python version
- Info about to using [pyenv](https://towardsdatascience.com/homebrew-and-pyenv-python-playing-pleasantly-in-partnership-3a342d86319b)
- There might be challenges with bottled formulae. Try installing from source with `brew install -s`.
   - `awscli` seems to include the virtualenv libexec dir with symlinks to /usr/local/opt/python@3.11/Frameworks...

Example from awscli problem after `brew uninstall python3` and switching to pyenv:

```sh
❯ aws
zsh: /usr/local/bin/aws: bad interpreter: /usr/local/Cellar/awscli/2.11.16/libexec/bin/python3.11: no such file or directory
❯ cd /usr/local/Cellar/awscli/2.11.16/libexec/bin
❯ ll
total 128
-rw-r--r--  1 joni.hamalainen  admin   8.8K 28 Huh 23:15 Activate.ps1
-rw-r--r--  1 joni.hamalainen  admin   2.0K  3 Tou 10:41 activate
-rw-r--r--  1 joni.hamalainen  admin   939B  3 Tou 10:41 activate.csh
-rw-r--r--  1 joni.hamalainen  admin   2.2K  3 Tou 10:41 activate.fish
-rwxr-xr-x  1 joni.hamalainen  admin   854B  3 Tou 10:41 aws
-rw-r--r--  1 joni.hamalainen  admin   898B 28 Huh 23:15 aws.cmd
-rw-r--r--  1 joni.hamalainen  admin   204B  3 Tou 10:41 aws_bash_completer
-rwxr-xr-x  1 joni.hamalainen  admin   1.2K  3 Tou 10:41 aws_completer
-rw-r--r--  1 joni.hamalainen  admin   1.8K 28 Huh 23:15 aws_zsh_completer.sh
-rwxr-xr-x  1 joni.hamalainen  admin   251B  3 Tou 10:41 distro
-rwxr-xr-x  1 joni.hamalainen  admin   1.7K  3 Tou 10:41 jp.py
-rwxr-xr-x  1 joni.hamalainen  admin   260B  3 Tou 10:41 pip
-rwxr-xr-x  1 joni.hamalainen  admin   260B  3 Tou 10:41 pip3
-rwxr-xr-x  1 joni.hamalainen  admin   260B  3 Tou 10:41 pip3.11
lrwxr-xr-x  1 joni.hamalainen  admin    87B 28 Huh 23:15 python -> ../../../../../opt/python@3.11/Frameworks/Python.framework/Versions/3.11/bin/python3.11
lrwxr-xr-x  1 joni.hamalainen  admin    87B 28 Huh 23:15 python3 -> ../../../../../opt/python@3.11/Frameworks/Python.framework/Versions/3.11/bin/python3.11
lrwxr-xr-x  1 joni.hamalainen  admin    87B 28 Huh 23:15 python3.11 -> ../../../../../opt/python@3.11/Frameworks/Python.framework/Versions/3.11/bin/python3.11
```

While local `python3 -m venv --system-site-packages libexec` call created following correct symlinks:
```sh
❯ ll
total 80
-rw-r--r--  1 joni.hamalainen  staff   8.8K  3 Tou 12:37 Activate.ps1
-rw-r--r--  1 joni.hamalainen  staff   2.0K  3 Tou 12:37 activate
-rw-r--r--  1 joni.hamalainen  staff   942B  3 Tou 12:37 activate.csh
-rw-r--r--  1 joni.hamalainen  staff   2.2K  3 Tou 12:37 activate.fish
-rwxr-xr-x  1 joni.hamalainen  staff   260B  3 Tou 12:37 pip
-rwxr-xr-x  1 joni.hamalainen  staff   260B  3 Tou 12:37 pip3
-rwxr-xr-x  1 joni.hamalainen  staff   260B  3 Tou 12:37 pip3.11
lrwxr-xr-x  1 joni.hamalainen  staff     7B  3 Tou 12:37 python -> python3
lrwxr-xr-x  1 joni.hamalainen  staff    57B  3 Tou 12:37 python3 -> /Users/joni.hamalainen/.pyenv/versions/3.11.3/bin/python3
lrwxr-xr-x  1 joni.hamalainen  staff     7B  3 Tou 12:37 python3.11 -> python3
-rw-r--r--  1 joni.hamalainen  staff    72B  3 Tou 12:53 readme.txt
```


# Other notes / TODO

- macOS settings
-- Change Mission control bindings for Ctrl+&larr; & Ctrl+&rarr;: Keyboard -> Shortcuts -> Mission Control
-- Remove Cmd+Shift+A "Open man page" keyboard shortcut from Services section
-- Set Screenshots location `defaults write com.apple.screencapture location ~/Screenshots`
- https://adoptopenjdk.net/
- Podman machine macOS: https://github.com/ansible/vscode-ansible/wiki/macos
- IDEA preferences
- Chrome bookmarks
- Sublime Text - packages at ~/Library/Application Support/Sublime Text 3/, folders 'Installed Packages' and 'Packages'.
- iTerm + Solarized: Color -> Color Presets -> Solarized (https://gist.github.com/kevin-smets/8568070)

# Hints

## Set of tags for different use cases

### Essentials

- --tags bin,git,zsh,bash,asdf,bat,fzf,scripts,launchd --skip-tags asdf-plugins,vscodium,chromedriver,geckodriver,hashicorp,lein

## Completion

<!-- https://unix.stackexchange.com/a/606305 -->
> press ^X? (Ctrl+X ?) instead of Tab to run _complete_debug.
