# 🌟 LuminOS (x86_64 Universal Edition)

> *"LuminOS: Luminous, fast, and weightless — ~280MB - 420MB idle RAM, BORE kernel speed, Bubblewrap security sandboxing, zero Windows bloat gaming, and out-of-the-box Windows application execution."*

---

## 🌟 Overview & Vision

**LuminOS** is a 100% unique Arch Linux-based universal operating system engineered for high speed, zero-trust security, battery longevity, and low resource overhead across all hardware (Desktops, Laptops, Low-Spec PCs, Handhelds, and Gaming Rigs).

- **GitHub Repository**: [https://github.com/nosleepzzz/luminos](https://github.com/nosleepzzz/luminos)
- **Live Website**: [https://nosleepzzz.github.io/luminos/](https://nosleepzzz.github.io/luminos/)
- **SourceForge Mirror**: [https://sourceforge.net/projects/luminos/](https://sourceforge.net/projects/luminos/)
- **Idle Memory Footprint**: **< 280 MB - 420 MB RAM**
- **Kernel Scheduler**: `BORE` (Burst-Oriented Response Enhancer) + `scx_lavd` (Latency-Aware Virtual Deadline eBPF Scheduler)
- **Memory Compression**: ZRAM ZSTD with a 2.5x - 3.0x compression ratio target

---

## 🍨 4 Official LuminOS Flavors

| Flavor | Target Hardware | Idle RAM | Key Highlights |
| :--- | :--- | :--- | :--- |
| 🍏 **Glass Edition** *(Flagship)* | Daily PCs, Laptops & Ultrabooks | **~420 MB** | macOS Sonoma Glass Wayland desktop, multi-touch touchpad gestures, `lumin-powerd` battery daemon. |
| ⚡ **Lite Edition** | Ancient PCs & Netbooks (1GB-2GB RAM) | **< 280 MB** | Ultra-minimalist shell, ZRAM ZSTD 3.0x compression, sub-4s boot time. Resurrects 15-year-old PCs. |
| 🎮 **GameDeck Edition** | Gaming PCs & Handhelds (Steam Deck, ROG Ally) | **~500 MB** | Pre-configured Proton-Lumin GE + DXVK 2.4, MangoHud performance overlay, zero-latency BORE scheduler mode (`lumin-game`). |
| 🏢 **Workstation Edition** | Desktops, Office Rigs & Developers | **~550 MB** | Out-of-the-box Windows Office Suite sandbox runner, KVM/QEMU virtualization, Docker container runtime. |

---

## ⚙️ 6 Native C System Tools Suite

LuminOS includes 6 native C system tools compiled with `-O3` optimization in `/usr/bin/`:

1. **`lumin-fetch`**: System info fetch utility displaying the **LuminOS Star** ASCII emblem.
2. **`lumin-mgr`**: Universal System Control Center & Proton-Lumin runner (`lumin --run-exe`).
3. **`lumin-powerd`**: Universal Power & Thermal Daemon (enables PCIe ASPM C8/C10 deep C-states on battery).
4. **`lumin-security`**: Bubblewrap (`bwrap`) container sandbox engine for unprivileged Windows `.exe` isolation.
5. **`lumin-game`**: Zero Windows Bloat Steam & Windows Gaming Engine (`lumin-game --enable`).
6. **`lumin-install`**: One-click Windows application & game installer (`lumin-install setup.exe 'App Name'`).

---

## 🎮 Zero Windows Bloat Gaming Stack

LuminOS is engineered as the ultimate Windows alternative for gaming:
- **No Background Telemetry**: Saves 3.5GB RAM compared to Windows 11.
- **Direct3D 9/11/12 -> Vulkan Pipeline**: Powered by `DXVK 2.4` and `VKD3D-Proton 2.13`.
- **MangoHud Integration**: Real-time FPS, frame latency, VRAM, and GPU temperature overlay.

```bash
# Enable High-Performance Gaming Mode
lumin-game --enable

# One-Click Install a Windows Game with Desktop Shortcut
lumin-install game_setup.exe "Cyberpunk 2077"
```

---

## 📁 Repository Structure

```
lumin-os/
├── README.md                           # 📄 Master Technical Readme
├── assets/
│   ├── lumin-logo.jpg                  # 🖼️ Official LuminOS Logo Emblem
│   └── lumin-wallpaper.jpg             # 🖼️ Official 4K Wallpaper
├── docs/                               # 📖 Documentation & Guides
│   ├── FLAVORS.md                      # 🍨 Official LuminOS 4 Flavors Guide
│   ├── HOSTING_&_DEPLOYMENT.md         # 🌐 ISO Distribution & Web Deployment
│   └── RELEASE_NOTES_v1.0.0-rc1.md     # 🏷️ Release Notes v1.0.0-rc1
├── website/                            # 🌐 Official Landing Page
│   ├── index.html
│   └── style.css
├── src/                                # ⚙️ Native C System Executables
│   ├── lumin-fetch.c                   # System fetch utility
│   ├── lumin-mgr.c                     # System control center
│   ├── lumin-powerd.c                  # Power & thermal daemon
│   ├── lumin-security.c               # Security sandbox engine
│   ├── lumin-game.c                    # Steam & gaming mode optimizer
│   └── lumin-install.c                 # One-click app installer helper
└── tools/                              # 🛠️ Build & Audit Tooling
    ├── build-iso.sh                    # Master ISO builder
    ├── make-repo.sh                    # Pacman package repository generator
    └── verify-iso-readiness.sh         # ISO compliance auditor
```

---

## 🛠️ Usage & Build Instructions

```bash
# 1. Compile all 6 C system binaries
./build-lumin.sh

# 2. Run system fetch & status check
./iso/airootfs/usr/bin/lumin-fetch
./iso/airootfs/usr/bin/lumin-game --status

# 3. Build the 1.5 GB Bootable ISO image (Requires archiso & sudo)
sudo ./tools/build-iso.sh
```

---

## 📥 Direct Downloads & Mirrors

- **GitHub Direct ISO**: [Download `lumin-os-v1.0.0-rc1-x86_64.iso` (1.5 GB)](https://github.com/nosleepzzz/luminos/releases/download/v1.0.0-rc1/lumin-os-v1.0.0-rc1-x86_64.iso)
- **SourceForge Mirror**: [LuminOS SourceForge Downloads](https://sourceforge.net/projects/luminos/files/)
- **Release Tag**: `v1.0.0-rc1`
- **SHA256 Checksum**: `87f7b78fe31f8c5ed1d3ae3d2384efae9e7a4f3724503c4507c84574367e270a`
