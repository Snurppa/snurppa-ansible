# ansible-playbook for personal macOS setup

```
ansible-playbook -i localhost main.yml --extra-vars "homebrew_api_token=<YOUR TOKEN HERE>" --ask-become-pass

# or without homebrew_api_token setting

ansible-playbook -i localhost main.yml --skip-tags brew_token --ask-become-pass

```

# Requirements

* Homebrew
* `brew install python`
* `brew install ansible`

# Other notes / TODO

* Change Mission control bindings for Ctrl+&larr; & Ctrl+&rarr;: Keyboard -> Shortcuts -> Mission Control
* IDEA preferences
* Chrome bookmarks
* Studio3T
* Sublime Text - packages at ~/Library/Application Support/Sublime Text 3/, folders 'Installed Packages' and 'Packages'.
