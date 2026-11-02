# Dotfiles — work (macOS) / personal (Linux)

Dotfiles for Damian's machines: common configs for every setup, plus per-device profiles.
Owner: Damian Czaja.

## Rules

- Configs split into `common/` (all machines) and a per-device `profiles/` layer; deployed via `applyconf.sh` / `saveconf.sh` (copy-based, no symlinks)
- `applyconf.sh` and `saveconf.sh` deploy `common/` first, then the active profile on top (no OS detection)
- Manifests: `files.common`, `files.profile-<name>` — update when adding new config paths; lines starting with `#` are ignored
- Setup scripts: `profiles/work/setup-work.sh` (brew); `profiles/personal/setup-personal.sh` (apt + brew)
- Never commit secrets or credentials — `.zshrc.local`, `~/.envs`, `~/.gitlab_token`, `~/.castai-*` and other key files are machine-local, stay out of the repo
- Never add comments to config files unless explicitly requested
- Keep changes minimal and targeted — follow existing patterns in each file

## Profiles (per-device tweaks)

- The active profile is stored in `~/.config/dotfiles/profile` (one word: `work` or `personal`) — machine-local, never committed
- `applyconf.sh` creates the marker on first run (prompts, default `work`); override with `DOTFILES_PROFILE=name` or `DOTFILES_ASSUME_YES=1` for scripted runs
- `work` (macOS): Go + cloud/k8s tooling only; `personal` (Linux): adds flutter / Android / Dart / Elixir tooling (gated in `common/.zshrc` via `$DOTFILES_PROFILE`)
- Profile-specific *files* go in `profiles/<name>/` and are listed in `files.profile-<name>` (currently: `work` ships `profiles/work/.gitconfig-cast`)
- `~/.zshrc.local` is sourced at the end of `~/.zshrc` — use it for machine-local zsh overrides and secrets that must not be synced
- Env var loading: `direnv` (hook in `.zshrc`) — NOT the OMZ dotenv plugin; `.envrc` files should be committed per-repo
- Other devices need `direnv` + `fnm` installed (both guarded by `command -v`, so a missing tool degrades gracefully); asdf is no longer part of the setup

## Directory Structure

```
common/          # All machines: ghostty, tmux, zsh, git
profiles/        # Per-device: work/ (macOS), personal/ (Linux) — setup scripts + profile files
servers/         # Remote server configs (p10k, zsh) — not deployed by applyconf
scripts/         # Shared scripts (setup-server-zsh.sh)
```

## Environment

- Shell: zsh (Zinit, Pure prompt)
- Terminal: Ghostty
- Font: JetBrainsMono Nerd Font
- Linux desktop: COSMIC (Wayland)
- Keyboard: Polish (pl)

## Kanagawa Color Palette

All UI configs use these colors.

| Name | Hex |
|---|---|
| Background | `#1F1F28` |
| Surface | `#2A2A37` |
| Text | `#DCD7BA` |
| Accent | `#E6C384` |
| Red | `#D27E99` |
| Teal | `#7AA89F` |
| Blue | `#2D4F67` |
| Muted | `#54546D` |

## Keybindings

- **COSMIC**: Super-based — configured via COSMIC Settings
- **Ghostty**: Ctrl+Shift+T new tab, Ctrl+Tab cycle tabs, Ctrl+Shift+O/E splits, Alt+←/→ word move