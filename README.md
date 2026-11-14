# Home Manager shell environment

Declarative Zsh configuration for x86_64 Linux, managed with Nix and Home Manager.

Includes Starship with Nerd Font symbols, JetBrainsMono Nerd Font, Atuin, Zoxide, bat, eza, tmux, and Zsh completion, autosuggestions, syntax highlighting, and history substring search.

## Prerequisites

- On non-NixOS systems, prefer installing and updating Zsh through your distribution's package manager (for example, `sudo apt install zsh` on Debian/Ubuntu). Use that system-managed executable as your login shell, while Home Manager manages its configuration. This keeps login independent of the Nix profile and uses the distribution's `/etc/shells` integration.
- Install [Nix](https://nixos.org/download/) and follow the installer's instructions to make `nix` available in your shell.
- Enable flakes by adding this line to `~/.config/nix/nix.conf` (create the directory and file if needed):

  ```ini
  experimental-features = nix-command flakes
  ```

## Configure your user

The configuration currently targets the Linux account `user` with home directory `/home/user`.

For another account, edit `home.nix`:

```nix
home = {
  username = "yourname";
  homeDirectory = "/home/yourname";
  # Keep the other existing home settings.
};
```

The flake configuration name `user` is independent of your Linux username. Leave it unchanged to use the commands below.

## Install

Run from this directory:

```sh
nix run github:nix-community/home-manager/release-26.05 -- switch --flake path:.#user -b backup
```

This builds and activates the environment. `-b backup` backs up conflicting files, such as an existing `.zshrc`, instead of overwriting them. If a `.backup` file already exists, move it aside before retrying.

Once installed, apply subsequent changes with:

```sh
home-manager switch --flake path:.#user
```

To build without activating:

```sh
home-manager build --flake path:.#user
```

`path:.` includes the current directory's files even if they have not been added to Git.

## Finish setup

1. Select **JetBrainsMono Nerd Font** in your terminal's font settings. Restart the terminal if the font is not listed yet.
2. Start Zsh:

   ```sh
   zsh
   ```

   This configuration also installs Zsh through Nix, but does not change your account's login shell. On non-NixOS systems, prefer the distribution-managed Zsh for login: check its path in `/etc/shells`, then run `chsh -s /usr/bin/zsh` if that is the listed path. Log out and back in for the change to take effect.

3. Optionally import your existing Zsh history into Atuin once:

   ```sh
   atuin import zsh
   ```

Atuin works locally without an account. History synchronization requires separate setup.

## Everyday use

| Command or key | Action |
| --- | --- |
| `Ctrl-R` | Search history with Atuin |
| Type part of a command, then Up/Down | Search matching Zsh history |
| `z directory` | Jump to a frequently used directory |
| `ls`, `ll`, `la`, `lla`, `lt` | eza listings with automatic icons; Git status in long listings |
| `bat file` | View a file with syntax highlighting |
| `tmux` / `tmux attach` | Start a session / reattach to a detached session |
| `Ctrl-b`, then `d` | Detach without stopping programs |
| `Shift-Left` / `Shift-Right` | Previous / next tmux window (no prefix) |
| `Alt-Arrow` | Switch tmux panes (no prefix) |
| `Ctrl-b`, then `c` | Create a window in the current directory |
| `Ctrl-b`, then `[` | Enter vi-style copy mode; `q` exits |

After applying shell configuration changes, open a new terminal or run `exec zsh`.

Tmux uses Zsh, mouse support, 50,000 lines of scrollback, and window/pane numbering from 1. Windows renumber automatically when closed. A new tmux server loads configuration changes; for an existing server, run `tmux source-file ~/.config/tmux/tmux.conf`. These changes do not alter already-running shells.

News notifications are disabled during builds and switches. To read announcements manually, run `home-manager news --flake path:.#user` from this directory.

## Cleanup

Old Home Manager generations keep their packages available for rollback and protect them from garbage collection. To remove generations older than seven days, then collect unused store paths:

```sh
home-manager expire-generations '-7 days'
nix store gc
```

The current generation remains protected. Expired generations are no longer available for rollback. Packages still referenced by other generations or profiles are not deleted.

## Configuration files

- `flake.nix`: Nix inputs and the `user` Home Manager configuration.
- `flake.lock`: pinned dependency revisions.
- `home.nix`: packages, fonts, aliases, and program settings.

Keep `home.stateVersion` unchanged when updating dependencies; it is a compatibility baseline, not the current package version.
