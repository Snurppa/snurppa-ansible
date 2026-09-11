# Podman setup

Podman v6 released on 2026-07-02: [Introducing Podman v6](https://blog.podman.io/2026/07/introducing-podman-v6-0-0/)



Revamped installation:

1. Install [Podman Desktop](https://podman-desktop.io/) and use it to install `podman` CLI.
   - DO NOT initiate the "Podman Machine", because the GUI lacks support for controlling host volume mounts towards the Podman Fedora VM.
2. Open fresh shell, ensure that `podman --version` works.
3. Initiate `podman machine`, which avoids mounting FULL macOS `$HOME` into the VM. Only controlled coding volumes are mounted from macOS host.
    - See help: https://podman-desktop.io/docs/podman/creating-a-podman-machine
    - The chosen mounts (`-v`s) are adapted from the defaults shown in `podman machine init --help`
    - The command: 
	```
	podman machine init --now --cpus 4 --memory 7630 --disk-size 93 --rootful --import-native-ca -v /Users/$USER/code:/Users/$USER/code -v /private:/private -v /var/folders:/var/folders -v /Users/$USER/.config/containers:/etc/containers
	```


## Devcontainers

Set `"dev.containers.dockerPath": "podman"` as per https://code.visualstudio.com/remote/advancedcontainers/docker-options#_podman

