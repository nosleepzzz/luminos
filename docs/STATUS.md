# Project status (Phase 1)

**Updated:** 2026-08-13

| Area | State |
| --- | --- |
| Scope messaging | Honest pre-alpha / Glass-only |
| Base system | CachyOS repos + `linux-cachyos` (not a custom Lumin kernel yet) |
| Windows `.exe` | **Phase 2** — stubs only (`lumin-game`, `lumin-install`) |
| C helpers | Compile-clean; Phase 2 commands fail closed |
| Live boot | No firstboot; autologin; VM-safe Hyprland session |
| Live login | `lumin` / `lumin`; tty2 autologin rescue |
| Desktop UX | fuzzel/wofi launchers, thunar files, session init scripts |
| Branding | GRUB/syslinux/SDDM themes, wallpaper, logo |
| CI | Compile + shellcheck + package-list validation |

## What Phase 1 is (and is not)

**Is:** a lean Glass live ISO profile on top of CachyOS/Arch — trimmed packages, Hyprland desktop, branding, and boot/login fixes.

**Is not yet:** a fully custom optimized kernel/filesystem product, a Windows compatibility layer, or a finished installer release.

## Live session quick reference

- **Apps:** click **LuminOS** on the bar, or **Alt+D**
- **Terminal:** **Alt+Return**
- **Files:** click **Files** on the bar, or **Alt+E**
- **VirtualBox:** Win/Super usually does not reach the guest — use **Alt**

## Historical `v1.0.0-rc1`

Treat as superseded. See [RELEASE_NOTES_v1.0.0-rc1.md](RELEASE_NOTES_v1.0.0-rc1.md).
