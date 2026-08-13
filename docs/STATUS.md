# Project status (Phase 1)

**Updated:** 2026-08-13

| Area | State |
| --- | --- |
| Scope messaging | Honest pre-alpha / Glass-only |
| C helpers | Compile-clean stubs; Phase 2 commands fail closed |
| ISO profile | CachyOS repos + `linux-cachyos` + lean Hyprland |
| Live boot | No firstboot; autologin; `start-hyprland` VM-safe path |
| Live login | `lumin` / `lumin`; tty2 autologin rescue |
| Desktop UX | Alt binds, waybar menu, foot on start, welcome toast |
| Branding | GRUB/syslinux/SDDM themes, wallpaper, logo, wofi/dunst/foot |
| CI | Compile + shellcheck + package-list validation |
| Bootable ISO publish | Build on CachyOS VM; verify before testing |

## Live session quick reference

- **App menu:** click **LuminOS** on the top bar, or **Alt+D**
- **Terminal:** **Alt+Return** (opens on session start)
- **VirtualBox:** Win/Super usually does not reach the guest — use **Alt**
- **Rescue TTY:** Host key + **F2** → login `lumin` / `lumin`

## Historical `v1.0.0-rc1`

Treat as superseded. See [RELEASE_NOTES_v1.0.0-rc1.md](RELEASE_NOTES_v1.0.0-rc1.md).
