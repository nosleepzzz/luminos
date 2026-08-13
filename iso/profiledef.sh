#!/usr/bin/env bash
# LuminOS Archiso Profile Definition
iso_name="lumin-os"
iso_label="LUMIN_$(date +%Y%m)"
iso_publisher="LuminOS Project <https://github.com/nosleepzzz/luminos>"
iso_application="LuminOS Live ISO & Installer"
iso_version="v1.0.0-rc1"
install_dir="luminos"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x86_64.systemd-boot.esp' 'uefi-x86_64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/usr/bin/lumin-fetch"]="0:0:755"
  ["/usr/bin/lumin-mgr"]="0:0:755"
  ["/usr/bin/lumin-powerd"]="0:0:755"
  ["/usr/bin/lumin-security"]="0:0:755"
)
