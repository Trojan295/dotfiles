# Dotfiles

Dotfiles for Damian's machines. Common configs apply to every setup; per-device tweaks
live in profiles and are installed only when a profile is selected.

| Machine | Profile | OS |
|---|---|---|
| Work | `work` | macOS |
| Personal | `personal` | Linux |

## What's inside

- **Shell**: zsh (Zinit, Pure prompt), ghostty terminal, tmux with minimal status bar
- **Dev/cloud**: Go, kubectl, kubectx, helm, kind, castctl, k9s, lazygit, git-delta
- **Productivity**: direnv, atuin history, zoxide `cd`, fzf/fzf-tab, eza, fnm (node, lazy)
- **Personal-only**: flutter, Android SDK, Dart, Elixir — gated by the `personal` profile

## Layout

| Path | Purpose |
|---|---|
| `common/` | Configs for every setup (ghostty, tmux, zsh, git) |
| `profiles/work/` | Work profile (macOS): setup script, work-only gitconfig |
| `profiles/personal/` | Personal profile (Linux): setup script |
| `servers/` | Remote server configs (not deployed by applyconf) |
| `scripts/` | Shared setup scripts |
| `files.common`, `files.profile-<name>` | Manifests listing which files are copied |
| `applyconf.sh` | Deploy repo → `$HOME` (common → active profile) |
| `saveconf.sh` | Collect `$HOME` → repo |

## Quickstart (new device)

```sh
git clone git@github.com:Trojan295/dotfiles.git ~/Projekty/dotfiles
cd ~/Projekty/dotfiles

# install tools (or equivalent via your package manager):
#   zsh, ghostty, tmux, direnv, fnm, atuin, eza, zoxide, fzf,
#   git-delta, go, kubectl, kubectx, helm, kind, k9s, lazygit
./profiles/work/setup-work.sh          # work machine (macOS)
./profiles/personal/setup-personal.sh  # personal laptop (Linux)

./applyconf.sh
```

The first `applyconf.sh` run asks for the device **profile** (`work` or `personal`)
and writes the marker to `~/.config/dotfiles/profile`. Start tmux and zsh and you're set.

## Profiles

- `work` (macOS): Go + cloud/K8s only
- `personal` (Linux): adds flutter / Android / Dart / Elixir tooling

Your machine's profile lives in `~/.config/dotfiles/profile` (machine-local, never
committed). In `common/.zshrc`, language tooling is gated on
`$DOTFILES_PROFILE == "personal"`, so a Go-only machine just works.

```sh
DOTFILES_ASSUME_YES=1 ./applyconf.sh   # non-interactive apply (scripted replication)
DOTFILES_PROFILE=personal zsh          # one-off profile override for a shell
echo work > ~/.config/dotfiles/profile # switch a machine's profile
```

Profile-specific files go in `profiles/<name>/` and are listed in `files.profile-<name>`.

## Daily workflow

```sh
./saveconf.sh          # after editing configs on a machine: pull $HOME state into repo
git add -A && git commit -m "..."
git pull && ./applyconf.sh   # on another device: deploy
```

Add new config paths to the matching `files.*` manifest; `#` lines are ignored.
The scripts are copy-based (no symlinks).

## Machine-local stuff (never committed)

- `~/.zshrc.local` — machine-local zsh overrides (sourced last by `~/.zshrc`)
- `~/.config/dotfiles/profile` — the active profile
- Secrets: `~/.envs`, `~/.gitlab_token`, `~/.castai-*`, cloud credentials → keep out of git

## Notes

- **Env vars**: use `direnv` (commit `.envrc` per repo), not the OMZ dotenv plugin
- **Node**: fnm (lazy-loaded), asdf is no longer used
- **Prompt/status**: Pure shows git info; tmux status bar shows session/window + current
  Kubernetes context (`kubectl config current-context`)