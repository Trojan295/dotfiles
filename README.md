# Dotfiles

Cross-platform dotfiles for macOS (work) and Linux (personal). Owner: Damian Czaja.

## What's inside

- **Shell**: zsh (Zinit, Pure prompt), [ghostty] terminal, tmux with a minimal status bar
- **Dev/cloud**: Go, kubectl, kubectx, helm, kind, castctl, k9s, lazygit, git-delta
- **Productivity**: direnv, atuin history, zoxide `cd`, fzf/fzf-tab, eza, fnm (node, lazy)
- **Optional (personal machines)**: flutter, Android SDK, Dart, Elixir — gated by profile

## Layout

| Path | Purpose |
|---|---|
| `common/` | Cross-platform configs (ghostty, tmux, zsh, git) |
| `macos/`, `linux/` | OS-specific configs + setup scripts |
| `profiles/` | Per-device profile files (`work/`, `personal/`) |
| `files.common` / `files.macos` / `files.linux` / `files.profile-<name>` | Manifests listing which files are copied |
| `applyconf.sh` | Deploy repo → `$HOME` (layers: common → OS → profile) |
| `saveconf.sh` | Collect `$HOME` → repo (run before committing) |

## Quickstart (new device)

```sh
git clone git@github.com:Trojan295/dotfiles.git ~/Projekty/dotfiles
cd ~/Projekty/dotfiles

# install tools (or equivalent via your package manager):
#   zsh, ghostty, tmux, direnv, fnm, atuin, eza, zoxide, fzf,
#   git-delta, go, kubectl, kubectx, helm, kind, castctl, k9s, lazygit
./macos/scripts/setup-macos.sh   # macOS
./linux/scripts/setup-pop.sh     # Linux

./applyconf.sh
```

The first `applyconf.sh` run asks for the device **profile** and writes the marker
to `~/.config/dotfiles/profile`. Start tmux and zsh and you're set.

## Profiles (per-device tweaks)

- `work` — work machine (macOS): Go + cloud/K8s only
- `personal` — personal laptop (Linux): adds flutter / Android / Dart / Elixir tooling

The marker is machine-local and never committed. In `common/.zshrc`, language tooling
is gated on `$DOTFILES_PROFILE == "personal"`, so a Go-only machine just works.

```sh
DOTFILES_ASSUME_YES=1 ./applyconf.sh   # non-interactive apply (scripted replication)
DOTFILES_PROFILE=personal zsh          # one-off profile override for a shell
echo work > ~/.config/dotfiles/profile # switch a machine's profile
```

Profile-specific *files* (beyond what `.zshrc` gates) go in `profiles/<name>/` and are
listed in `files.profile-<name>`.

## Daily workflow

```sh
./saveconf.sh          # after editing configs on a machine: pull $HOME state into repo
git add -A && git commit -m "..."
git pull && ./applyconf.sh   # on another device: deploy
```

Add new config paths to the matching `files.*` manifest; `#` lines are ignored.
The scripts are copy-based (no symlinks) and detect the OS automatically.

## Machine-local stuff (never committed)

- `~/.zshrc.local` — machine-local zsh overrides (sourced last by `~/.zshrc`)
- `~/.config/dotfiles/profile` — the active profile
- Secrets: `~/.envs`, `~/.gitlab_token`, `~/.castai-*`, cloud credentials → keep out of git

## Notes

- **Env vars**: use `direnv` (commit `.envrc` per repo), not the OMZ dotenv plugin
- **Node**: fnm (lazy-loaded), asdf is no longer used
- **Prompt/status**: Pure shows git info; tmux status bar shows session/window + current
  Kubernetes context (`kubectl config current-context`)