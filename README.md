# ansible-playbook for personal macOS setup

Before you start it's good idea to get a GitHub API token for Homebrew. You can create a token in your [GitHub profile](https://github.com/settings/tokens).

Put your token into `homebrew_token` file into root of this project. Ansible automatically reads `homebrew_token` file and sets this as HOMEBREW_GITHUB_API_TOKEN into `.zshrc`.

Provision your macOS by running:

```bash
ansible-playbook main.yml --ask-become-pass
```


# Requirements

* [Homebrew](https://brew.sh/)
* `brew install python`
* `pip3 install ansible`

# Other notes / TODO

- macOS settings
-- Change Mission control bindings for Ctrl+&larr; & Ctrl+&rarr;: Keyboard -> Shortcuts -> Mission Control
-- Remove confusing bindings from Services
- https://adoptopenjdk.net/
- IDEA preferences
- Chrome bookmarks
- Studio3T
- Sublime Text - packages at ~/Library/Application Support/Sublime Text 3/, folders 'Installed Packages' and 'Packages'.
- iTerm + Solarized: Color -> Color Presets -> Solarized (https://gist.github.com/kevin-smets/8568070)
