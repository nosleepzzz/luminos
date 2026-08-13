# LuminOS

Lean **CachyOS / Arch**-based Linux distribution focused on a single **Glass** flavor (Hyprland), without desktop or gaming bloat.

> **Status: pre-alpha (Phase 1).** The ISO profile and tooling are under active development. Windows application support is **Phase 2** and is not shipped yet.

## Vision

| Phase | Goal |
| --- | --- |
| **Phase 1 (now)** | Lean CachyOS-based Glass (Hyprland) live/install profile, honest docs, CI that compiles tools and validates the package list |
| **Phase 2 (next)** | Thin Wine-GE / Proton runner + optional Bubblewrap sandbox for `.exe` apps — opt-in, not base bloat |

LuminOS is inspired by [CachyOS](https://cachyos.org/) performance defaults (`linux-cachyos`, tuned repos) while keeping the Glass image intentionally small.

## Repository

| Path | Purpose |
| --- | --- |
| [`iso/`](iso/) | Archiso-style Glass profile (CachyOS repos + lean Hyprland stack) |
| [`src/`](src/) | Native C helpers (`lumin-*`) — compile clean; Windows runners return “not implemented” until Phase 2 |
| [`tools/`](tools/) | ISO build / repo / validation scripts |
| [`docs/`](docs/) | Flavor notes, hosting, and how to build an ISO later |
| [`website/`](website/) | Project landing page (GitHub Pages) |

## Build the C tools

Requires `gcc` (Linux, WSL, or compatible environment):

```bash
./build-lumin.sh
# or
make
```

Binaries land in `iso/airootfs/usr/bin/`.

```bash
./iso/airootfs/usr/bin/lumin-fetch
./iso/airootfs/usr/bin/lumin-mgr --status
```

Phase 2 commands (`--run-exe`, `--sandbox`, `lumin-install`) exit non-zero with a clear message until implemented.

## Build a bootable ISO (Linux host required)

ISO creation needs Arch or CachyOS with `archiso`. This is **not** done from Windows in Phase 1.

See [docs/BUILDING.md](docs/BUILDING.md) for VM sizing, packages, and `mkarchiso` steps.

```bash
# On CachyOS/Arch only:
sudo ./tools/build-iso.sh
```

## Links

- GitHub: [https://github.com/nosleepzzz/luminos](https://github.com/nosleepzzz/luminos)
- Website: [https://nosleepzzz.github.io/luminos/](https://nosleepzzz.github.io/luminos/)
- SourceForge (ISO mirror later): [https://sourceforge.net/projects/luminos/](https://sourceforge.net/projects/luminos/)

## Release honesty

The older `v1.0.0-rc1` GitHub release marketed features that the source tree did not implement (custom `linux-lumin`, four shipping flavors, working Windows sandbox). Treat that release as **superseded / pre-alpha artifact**. Current development targets a lean Glass profile only.

## License / attribution

LuminOS packaging and scripts in this repository are project-owned unless noted. The ISO profile structure follows patterns from [CachyOS-Live-ISO](https://github.com/CachyOS/CachyOS-Live-ISO) (GPL-3.0). See [docs/THIRD_PARTY.md](docs/THIRD_PARTY.md).

## Secrets

Never commit SourceForge API keys, tokens, or credentials. Use environment variables or GitHub Actions secrets (for example `SOURCEFORGE_API_KEY`) when automation is added later.
