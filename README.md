# 🌟 LuminOS (x86_64 Universal Edition)

> *"LuminOS: Luminous, fast, and weightless — ~280MB - 420MB idle RAM, BORE kernel speed, Bubblewrap security sandboxing, and ultra battery longevity."*

---

## 🌟 Overview & Branding

**LuminOS** is a 100% unique Arch Linux-based universal operating system fork engineered for high speed, zero-trust security, battery longevity, and low resource overhead across all hardware (Desktops, Laptops, Low-Spec PCs, and Handhelds).

- **Repository**: [https://github.com/sentinel-services/luminos](https://github.com/sentinel-services/luminos)
- **Idle Memory Footprint**: **~280 MB - 420 MB RAM**
- **Kernel Scheduler**: `BORE` (Burst-Oriented Response Enhancer) + `scx_lavd` (Latency-Aware Virtual Deadline eBPF Scheduler)
- **Memory Compression**: ZRAM ZSTD with a 2.5x - 3.0x compression ratio target

---

## 📁 Repository Structure

```
lumin-os/
├── LAUNCH_ANNOUNCEMENT.md              # 📢 Official Press Release & Benchmarks
├── README.md                           # 📄 Master Technical Readme
├── assets/
│   ├── lumin-logo.jpg                  # 🖼️ Official LuminOS Logo Emblem
│   └── lumin-wallpaper.jpg             # 🖼️ Official 4K Wallpaper
├── docs/                               # 📖 Documentation & Guides
│   ├── FLAVORS.md                      # 🍨 Official LuminOS 4 Flavors Guide
│   └── HOSTING_&_DEPLOYMENT.md         # 🌐 ISO Distribution & Web Deployment
├── website/                            # 🌐 Official Landing Page
│   ├── index.html
│   └── style.css
├── src/                                # ⚙️ Native C System Executables
│   ├── lumin-fetch.c                   # Lumin system info fetch
│   ├── lumin-powerd.c                  # Universal battery & thermal daemon
│   ├── lumin-security.c                # Bubblewrap sandbox security engine
│   └── lumin-mgr.c                     # System control center & Proton-Lumin runner
└── distrowatch/                        # 🌐 DistroWatch Submission Package (Audited 6/6)
    ├── metadata/distrowatch-submission.txt
    └── scripts/validate-distrowatch.sh
```

---

## 🛠️ Usage & Build Instructions

```bash
# 1. Compile C binaries
./build-lumin.sh

# 2. Run system fetch & status check
./iso/airootfs/usr/bin/lumin-fetch
./iso/airootfs/usr/bin/lumin-mgr --status

# 3. Test Bubblewrap security sandbox & Proton-Lumin EXE runner
./iso/airootfs/usr/bin/lumin-security --sandbox setup.exe
```
