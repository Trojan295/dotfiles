# Dotfiles — Pop!_OS / macOS

Cross-platform dotfiles for Pop!_OS (Linux) and macOS. Owner: Damian Czaja.

## Rules

- Configs split into `common/`, `linux/`, `macos/`, plus a per-device `profiles/` layer; deployed via `applyconf.sh` / `saveconf.sh` (copy-based, no symlinks)
- `applyconf.sh` and `saveconf.sh` detect OS and layer `common/` first, then OS-specific, then the active profile on top
- Manifests: `files.common`, `files.linux`, `files.macos`, `files.profile-<name>` — update when adding new config paths; lines starting with `#` are ignored
- Linux packages: `linux/scripts/setup-pop.sh` (apt + brew fallback); macOS: `macos/scripts/setup-macos.sh` (brew)
- Never commit secrets or credentials — `.zshrc.local`, `~/.envs`, `~/.gitlab_token`, `~/.castai-*` and other key files are machine-local, stay out of the repo
- Never add comments to config files unless explicitly requested
- Keep changes minimal and targeted — follow existing patterns in each file

## Profiles (per-device tweaks)

- The active profile is stored in `~/.config/dotfiles/profile` (one word, e.g. `core` or `full`) — machine-local, never committed
- `applyconf.sh` creates the marker on first run (prompts, default `core`); override with `DOTFILES_PROFILE=name` or `DOTFILES_ASSUME_YES=1` for scripted runs
- `core` = Go + cloud/k8s tooling only; `full` = adds flutter / Android / Dart / Elixir tooling (gated in `common/.zshrc` via `$DOTFILES_PROFILE`)
- Profile-specific *files* go in `profiles/<name>/` and are listed in `files.profile-<name>` (currently empty manifests — add files as needed)
- `~/.zshrc.local` is sourced at the end of `~/.zshrc` — use it for machine-local zsh overrides and secrets that must not be synced
- Env var loading: `direnv` (hook in `.zshrc`) — NOT the OMZ dotenv plugin; `.envrc` files should be committed per-repo
- Other devices need `direnv` + `fnm` installed (both guarded by `command -v`, so a missing tool degrades gracefully); asdf is no longer part of the setup

## Directory Structure

```
common/          # Cross-platform: alacritty, ghostty, zsh, git
linux/           # Pop!_OS: setup script only (COSMIC configured via GUI)
macos/           # macOS: alacritty override (option_as_alt), future aerospace/skhd
profiles/        # Per-device profile files: <name>/ overlaid after OS layer via files.profile-<name>
servers/         # Remote server configs (p10k, zsh)
scripts/         # Shared scripts (setup-server-zsh.sh)
```

## Environment

- Shell: zsh (Zinit, Pure prompt)
- Terminal: Ghostty (Alacritty fallback)
- Font: JetBrainsMono Nerd Font
- Linux desktop: COSMIC (Wayland)
- Keyboard: Polish (pl)

## Kanagawa Color Palette

All UI configs use these colors.

| Name | Hex | TOML (alacritty) |
|---|---|---|
| Background | `#1F1F28` | `0x1F1F28` |
| Surface | `#2A2A37` | `0x2A2A37` |
| Text | `#DCD7BA` | `0xDCD7BA` |
| Accent | `#E6C384` | `0xE6C384` |
| Red | `#D27E99` | `0xD27E99` |
| Teal | `#7AA89F` | `0x2D4F67` |
| Blue | `#2D4F67` | `0x2D4F67` |
| Muted | `#54546D` | `0x54546D` |

## Keybindings

- **COSMIC**: Super-based — configured via COSMIC Settings
- **Ghostty**: Ctrl+Shift+T new tab, Ctrl+Tab cycle tabs, Ctrl+Shift+O/E splits, Alt+←/→ word move
