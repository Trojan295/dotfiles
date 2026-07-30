# Dotfiles — Pop!_OS / macOS

Cross-platform dotfiles for Pop!_OS (Linux) and macOS. Owner: Damian Czaja.

## Rules

- Configs split into `common/`, `linux/`, `macos/`; deployed via `applyconf.sh` / `saveconf.sh` (copy-based, no symlinks)
- `applyconf.sh` and `saveconf.sh` detect OS and layer `common/` first, then OS-specific on top
- Manifests: `files.common`, `files.linux`, `files.macos` — update when adding new config paths; lines starting with `#` are ignored
- Linux packages: `linux/scripts/setup-pop.sh` (apt + brew fallback); macOS: `macos/scripts/setup-macos.sh` (brew)
- Never commit secrets or credentials
- Never add comments to config files unless explicitly requested
- Keep changes minimal and targeted — follow existing patterns in each file

## Directory Structure

```
common/          # Cross-platform: alacritty, ghostty, starship, zsh, git
linux/           # Pop!_OS: setup script only (COSMIC configured via GUI)
macos/           # macOS: alacritty override (option_as_alt), future aerospace/skhd
servers/         # Remote server configs (p10k, zsh)
scripts/         # Shared scripts (setup-server-zsh.sh)
```

## Environment

- Shell: zsh (Zinit, Starship prompt)
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
