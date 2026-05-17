# TODO

## Phase 1: SilentSDDM with Kanagawa Theme

- [ ] Run `sudo linux/scripts/setup-arch.sh`, select option 6 (SDDM)
- [ ] Test: `cd /usr/share/sddm/themes/silent && sudo ./test.sh`
- [ ] Reboot and verify login screen works

## Phase 2: Repo Restructure ✅

Completed. `home-configs/` replaced with `common/`, `linux/`, `macos/` split.

## Future

- [ ] Add macOS tiling WM config (aerospace or yabai) to `macos/`
- [ ] Add macOS hotkey daemon config (skhd) to `macos/`
- [ ] Consider Alacritty font size override per OS (currently 20.0, may differ on Retina)
