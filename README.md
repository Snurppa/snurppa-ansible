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
* Python
   * Should inspect more: https://opensource.com/article/19/5/python-3-default-mac
   * `brew install python`
   * `pip3 install ansible`


# Other notes / TODO

- macOS settings
-- Change Mission control bindings for Ctrl+&larr; & Ctrl+&rarr;: Keyboard -> Shortcuts -> Mission Control
-- Remove Cmd+Shift+A "Open man page" keyboard shortcut from Services section
- https://adoptopenjdk.net/
- IDEA preferences
- Chrome bookmarks
- Studio3T
- Sublime Text - packages at ~/Library/Application Support/Sublime Text 3/, folders 'Installed Packages' and 'Packages'.
- iTerm + Solarized: Color -> Color Presets -> Solarized (https://gist.github.com/kevin-smets/8568070)

# Hints

## Completion

<!-- https://unix.stackexchange.com/a/606305 -->
> press ^X? (Ctrl+X ?) instead of Tab to run _complete_debug.
