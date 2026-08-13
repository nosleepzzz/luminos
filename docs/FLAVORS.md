# LuminOS Flavors

## Active: Glass (Phase 1)

| | |
| --- | --- |
| **Status** | In development (pre-alpha) |
| **Target** | Daily PCs and laptops |
| **Desktop** | Hyprland + lean Wayland stack (waybar, wofi, foot, SDDM) |
| **Kernel** | `linux-cachyos` via CachyOS repos |
| **Policy** | Every package must earn its place — no Plasma, no Steam/Proton stack, no Office suite |

Glass is the only flavor being built right now.

## Planned (not started)

These are ideas only. They are **not** shipping and must not appear as downloadable editions until implemented.

| Flavor | Intent |
| --- | --- |
| **Lite** | Ultra-minimal shell for very old / low-RAM hardware |
| **GameDeck** | Opt-in gaming stack (Proton/Wine-GE, overlays) on top of Glass |
| **Workstation** | Dev/office extras (virt, containers) — still lean relative to full Plasma ISOs |

## Phase 2 (Windows apps)

Shared across flavors when ready: Wine-GE or Proton runner, optional Bubblewrap sandbox, MIME handler for `.exe`. Not part of the Phase 1 Glass base image.
