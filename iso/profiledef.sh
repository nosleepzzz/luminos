#!/usr/bin/env bash
# shellcheck disable=SC2034
# LuminOS Glass archiso profile
# Structure inspired by CachyOS-Live-ISO (GPL-3.0) — see docs/THIRD_PARTY.md

iso_name="luminos-glass"
iso_label="LUMINOS_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="LuminOS Project <https://github.com/nosleepzzz/luminos>"
iso_application="LuminOS Glass Live ISO (pre-alpha)"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="luminos"
buildmodes=('iso')
# Match CachyOS-Live-ISO: GRUB for UEFI is more reliable than systemd-boot here
bootmodes=('bios.syslinux' 'uefi.grub')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15' '-b' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/etc/sudoers.d"]="0:0:750"
  ["/etc/sudoers.d/g_wheel"]="0:0:440"
  ["/usr/bin/lumin-fetch"]="0:0:755"
  ["/usr/bin/lumin-mgr"]="0:0:755"
  ["/usr/bin/lumin-powerd"]="0:0:755"
  ["/usr/bin/lumin-security"]="0:0:755"
  ["/usr/bin/lumin-game"]="0:0:755"
  ["/usr/bin/lumin-install"]="0:0:755"
)
