# Dotfiles

Dotfiles for Damian's machines. Common configs apply to every setup; per-device tweaks
live in profiles and are installed only when a profile is selected.

| Machine | Profile | OS |
|---|---|---|
| Work | `work` | macOS |
| Personal | `personal` | CachyOS (Arch Linux) |

## What's inside

- **Shell**: zsh (Zinit, Pure prompt) and fish (fisher, Starship prompt), ghostty terminal, tmux with minimal status bar
- **Dev/cloud**: Go, kubectl, kubectx, helm, kind, castctl, k9s, lazygit, git-delta
- **Productivity**: direnv, atuin history, zoxide `cd`, fzf/fzf-tab, eza, fnm (node, lazy)
- **Personal-only**: flutter, Android SDK, Dart, Elixir — gated by the `personal` profile
- **Editor**: Neovim with [LazyVim](https://github.com/Trojan295/LazyVim) (kanagawa theme) — separate repo, cloned/pulled into `~/.config/nvim` by `applyconf.sh`

## Layout

| Path | Purpose |
|---|---|
| `common/` | Configs for every setup (ghostty, tmux, zsh, fish, starship, git) |
| `profiles/work/` | Work profile (macOS): setup script, work-only gitconfig |
| `profiles/personal/` | Personal profile (CachyOS): pacman setup script |
| `servers/` | Remote server configs (not deployed by applyconf) |
| `scripts/` | Shared setup scripts |
| `files.common`, `files.profile-<name>` | Manifests listing which files are copied |
| `applyconf.sh` | Deploy repo → `$HOME` (common → active profile), then clone/pull the Neovim config |
| `saveconf.sh` | Collect `$HOME` → repo |

## Quickstart (new device)

```sh
git clone git@github.com:Trojan295/dotfiles.git ~/Projekty/dotfiles
cd ~/Projekty/dotfiles

# install tools (or equivalent via your package manager):
#   zsh, fish, starship, ghostty, tmux, direnv, fnm, atuin, eza, zoxide, fzf,
#   git-delta, go, kubectl, kubectx, helm, kind, k9s, lazygit
./profiles/work/setup-work.sh          # work machine (macOS)
./profiles/personal/setup-personal.sh  # personal laptop (CachyOS, pacman)

./applyconf.sh
```

The first `applyconf.sh` run asks for the device **profile** (`work` or `personal`)
and writes the marker to `~/.config/dotfiles/profile`. Start tmux and zsh and you're set.

### Neovim

`applyconf.sh` clones the Neovim config repo into `~/.config/nvim` on first run and
runs `git pull --ff-only` on later runs (not copied, not tracked in `files.*`; an
existing non-git `~/.config/nvim` is skipped with a warning). It does not install
plugins or tools; after the first apply:

```sh
# CachyOS: neovim is in setup-personal.sh; also needed by Mason/treesitter:
sudo pacman -S --needed nodejs npm tree-sitter-cli

nvim --headless "+Lazy! restore" +qa   # install plugins pinned in lazy-lock.json
```

Then open `nvim` once and let Mason finish installing tools (gopls, vtsls, tailwind,
svelte, helm-ls, marksman, lua-ls, eslint, json, yaml, delve, gofumpt, goimports,
golangci-lint, shfmt, stylua, ...) and treesitter parsers. A headless run exits before
those finish, so installing them interactively is the reliable path. The Elixir extra
needs Elixir installed separately; `llama.vim` expects a llama.cpp server at
`$LLAMA_HOST` (default `http://127.0.0.1:8012`).

### Fish

A basic fish setup lives next to the zsh one; zsh stays the login shell. To use fish, set
`command = fish` in the ghostty config (and `default-command` in tmux for tmux panes).

- `common/.config/fish/config.fish`: `EDITOR`, PATH, eza aliases, fzf / zoxide / direnv /
  fnm / Starship init. It has no profile gating, atuin or completion setup.
- `common/.config/fish/fish_plugins`: fisher plugins (`plugin-git` for git abbreviations).
  `config.fish` runs `fisher update` on the first interactive start if the plugin is missing.
- `common/.config/fish/conf.d/kubectl.fish`: port of the OMZ kubectl aliases (`k`, `kgp`, ...).
- `common/.config/starship.toml`: Kanagawa prompt with git, Kubernetes context, last exit
  status and command duration (over 5s).

Fisher-installed files (`functions/`, other `conf.d/` files) stay machine-local and are
not in the manifests.

## Profiles

- `work` (macOS): Go + cloud/K8s only
- `personal` (CachyOS): adds flutter / Android / Dart / Elixir tooling

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
- **Prompt/status**: zsh uses Pure, fish uses Starship (git, Kubernetes context, exit status,
  command duration); the tmux status bar shows session/window + current
  Kubernetes context (`kubectl config current-context`)