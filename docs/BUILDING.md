# Building LuminOS Glass

Phase 1 does **not** require a local ISO build from Windows. Use this guide when you have a CachyOS or Arch Linux host (VM or bare metal).

## Build host requirements

| Item | Recommendation |
| --- | --- |
| OS | CachyOS (preferred) or Arch Linux |
| RAM | 8 GB minimum, 16 GB comfortable |
| Disk | 40 GB+ free |
| Nested virt | Enable if you will test the ISO inside another VM |
| Network | Needed to pull CachyOS + Arch packages |

### Suggested VM setup (from Windows later)

1. Install VirtualBox, VMware, or Hyper-V.
2. Create a VM, attach the official CachyOS ISO, install a minimal desktop or TTY system.
3. Give the VM at least 8 GB RAM and 40 GB disk.
4. Clone this repository inside the VM.

## Packages on the build host

```bash
sudo pacman -Syu --needed archiso mkinitcpio-archiso squashfs-tools grub git base-devel
```

Ensure CachyOS keyring/mirrors are installed if you are on Arch migrating to CachyOS repos (on a CachyOS install they are already present):

```bash
sudo pacman -S --needed cachyos-keyring cachyos-mirrorlist
sudo pacman-key --populate cachyos
```

## Compile helpers only (any Linux / WSL with gcc)

```bash
./build-lumin.sh
# or
make
./tools/verify-iso-readiness.sh
```

## Build the Glass ISO

```bash
git clone https://github.com/nosleepzzz/luminos.git
cd luminos
sudo ./tools/build-iso.sh
```

Artifacts appear under `out/`.

What the script does:

1. Compiles `src/lumin-*.c` into `iso/airootfs/usr/bin/`
2. Runs `tools/prepare-airootfs.sh` (wallpaper, live user home, systemd enable symlinks)
3. Invokes `mkarchiso` on `iso/`

## SourceForge uploads (optional, later)

After a verified ISO exists:

1. Create/rotate a SourceForge API key in account settings.
2. Store it only as an environment variable or GitHub Actions secret: `SOURCEFORGE_API_KEY`.
3. Never commit the key or paste it into chat/issues.

Upload automation is intentionally not wired yet.

## CI note

GitHub Actions in this repo compiles helpers and validates the package list. It does **not** publish ISOs until a dedicated Linux builder is available.
