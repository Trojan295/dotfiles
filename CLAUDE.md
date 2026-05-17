# Dotfiles — CachyOS / macOS

Cross-platform dotfiles for Arch Linux (CachyOS) and macOS. Owner: Damian Czaja.

## Rules

- Configs split into `common/`, `linux/`, `macos/`; deployed via `applyconf.sh` / `saveconf.sh` (copy-based, no symlinks)
- `applyconf.sh` and `saveconf.sh` detect OS and layer `common/` first, then OS-specific on top
- Manifests: `files.common`, `files.linux`, `files.macos` — update when adding new config paths
- Linux packages: `linux/scripts/setup-arch.sh` (yay); macOS: `macos/scripts/setup-macos.sh` (brew)
- SDDM theme setup: option 6 in `linux/scripts/setup-arch.sh` (requires sudo)
- Never commit secrets or credentials
- Never add comments to config files unless explicitly requested
- Keep changes minimal and targeted — follow existing patterns in each file

## Directory Structure

```
common/          # Cross-platform: alacritty, tmux, tmux-powerline, zsh, git
linux/           # CachyOS: hypr, waybar, wofi, SDDM kanagawa preset
macos/           # macOS: alacritty override (option_as_alt), future aerospace/skhd
servers/         # Remote server configs (p10k, zsh)
scripts/         # Shared scripts (setup-server-zsh.sh)
```

## Environment

- Shell: zsh (Zinit, Pure prompt)
- Terminal: Alacritty
- Font: JetBrains Mono Nerd Font; MesloLGS NF in Alacritty
- Linux compositor: Hyprland (Wayland)
- Keyboard: Polish (pl)

## Kanagawa Color Palette

All UI configs use these colors.

| Name | Hex | Hyprland/TOML | CSS |
|---|---|---|---|
| Background | `#1F1F28` | `rgba(1F1F28ff)` | `#1F1F28` |
| Surface | `#2A2A37` | `rgba(2A2A37ff)` | `#2A2A37` |
| Text | `#DCD7BA` | `rgba(DCD7Baff)` | `#DCD7BA` |
| Accent | `#E6C384` | `rgba(E6C384ff)` | `#E6C384` |
| Red | `#D27E99` | `rgba(D27E99ff)` | `#D27E99` |
| Teal | `#7AA89F` | `rgba(7AA89Fff)` | `#7AA89F` |
| Blue | `#2D4F67` | `rgba(2D4F67ff)` | `#2D4F67` |
| Muted | `#54546D` | `rgba(54546Dff)` | `#54546D` |

### Color formats by config type

- **CSS** (waybar, wofi): `#1F1F28` or `rgb(31, 31, 40)`
- **Hyprland** (hyprland.conf, hyprlock.conf, hypridle.conf): `rgba(1F1F28ff)`
- **Tmux**: `#1F1F28`
- **TOML** (alacritty): `0x1F1F28`

## Keybindings

- **Hyprland**: ALT-based — ALT+T terminal, ALT+Space wofi, ALT+Q close
- **Tmux**: Ctrl+A prefix — `|` vertical split, `-` horizontal split
