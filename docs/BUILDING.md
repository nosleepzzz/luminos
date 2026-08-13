# Building LuminOS Glass

Phase 1 does **not** require a local ISO build from Windows. Use this guide when you have a CachyOS or Arch Linux host (VM or bare metal).

## Build host requirements

| Item | Recommendation |
| --- | --- |
| OS | CachyOS (preferred) or Arch Linux |
| RAM | 8 GB minimum, 16 GB comfortable |
| Disk | **60 GB+** virtual disk recommended; keep **25 GB+ free** for mkarchiso work + squash |
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

Verify the live initramfs includes Archiso hooks (required for Switch Root):

```bash
# After a build, on the build host:
lsiso="$(echo out/luminos-glass-*.iso)"
mkdir -p /tmp/lumin-iso && sudo mount -o loop "$lsiso" /tmp/lumin-iso
ls -la /tmp/lumin-iso/luminos/boot/x86_64/
# Expect: vmlinuz-linux-cachyos and initramfs-linux-cachyos.img
sudo umount /tmp/lumin-iso
```

If boot fails at **Switch Root**, the initramfs was built without `archiso` hooks.
Confirm these exist in the profile before rebuilding:

- `iso/airootfs/etc/mkinitcpio.conf.d/archiso.conf`
- `iso/airootfs/etc/mkinitcpio.d/linux-cachyos.preset`


After a verified ISO exists:

1. Create/rotate a SourceForge API key in account settings.
2. Store it only as an environment variable or GitHub Actions secret: `SOURCEFORGE_API_KEY`.
3. Never commit the key or paste it into chat/issues.

Upload automation is intentionally not wired yet.

## CI note

GitHub Actions in this repo compiles helpers and validates the package list. It does **not** publish ISOs until a dedicated Linux builder is available.
