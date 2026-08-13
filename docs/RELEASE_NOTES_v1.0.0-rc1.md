# LuminOS v1.0.0-rc1 — historical / superseded

**Do not treat this release as a finished product.**

The `v1.0.0-rc1` GitHub assets and earlier announcement text overstated what the repository implemented at the time (custom kernel branding, four flavors, working Windows sandbox, unverified benchmarks).

### What was real

- Project branding, website, and repository scaffolding
- Archiso-shaped `iso/` tree and small C helper sources
- A published ISO artifact on GitHub Releases (audit before use)

### What was not real (or not in source)

- Custom `linux-lumin` kernel tree
- Working Wine/Proton/Bubblewrap `.exe` execution from `lumin-*` tools
- Four maintained flavor ISOs with measured idle-RAM / battery numbers

### Current direction

Development continues as **pre-alpha Phase 1**: lean **Glass** (Hyprland) on a CachyOS-based profile. See [README.md](../README.md) and [BUILDING.md](BUILDING.md).
