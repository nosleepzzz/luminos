#!/usr/bin/env bash
# Verify a built LuminOS Glass ISO is actually bootable/usable (not just present).
set -euo pipefail

ISO_PATH="${1:-}"
if [[ -z "${ISO_PATH}" || ! -f "${ISO_PATH}" ]]; then
  echo "Usage: $0 /path/to/luminos-glass-*.iso" >&2
  exit 2
fi
if ! command -v unsquashfs >/dev/null 2>&1; then
  echo "ERROR: unsquashfs required (pacman -S squashfs-tools)" >&2
  exit 1
fi

mnt="$(mktemp -d)"
root="$(mktemp -d)"
cleanup() {
  umount "${mnt}" 2>/dev/null || true
  rm -rf "${mnt}" "${root}"
}
trap cleanup EXIT

mount -o loop,ro "${ISO_PATH}" "${mnt}"

fail=0
check() {
  local desc="$1"
  shift
  # Run via bash -c so callers can use shell features (e.g. ! grep)
  if bash -c "$*" >/dev/null 2>&1; then
    echo "OK  ${desc}"
  else
    echo "FAIL ${desc}"
    fail=1
  fi
}

check "grub has systemd.firstboot=off" "grep -q 'systemd.firstboot=off' '${mnt}/boot/grub/grub.cfg'"
check "grub has luminos-console entry" "grep -q 'luminos-console' '${mnt}/boot/grub/grub.cfg'"
check "grub theme present" "test -f '${mnt}/boot/grub/themes/luminos/theme.txt'"
check "grub theme background present" "test -f '${mnt}/boot/grub/themes/luminos/background.png'"
check "syslinux splash present" "test -f '${mnt}/boot/syslinux/splash.png'"

sfs="${mnt}/luminos/x86_64/airootfs.sfs"
[[ -f "${sfs}" ]] || { echo "FAIL missing airootfs.sfs"; exit 1; }

unsquashfs -d "${root}" "${sfs}" \
  etc/luminos-live-ready \
  etc/sddm.conf.d/luminos.conf \
  etc/shadow \
  usr/local/bin/lumin-hyprland \
  usr/share/wayland-sessions/luminos-glass.desktop \
  usr/share/sddm/themes/luminos/Main.qml \
  usr/share/sddm/themes/luminos/background.jpg \
  usr/share/pixmaps/luminos.svg \
  home/lumin/.config/hypr/hyprland.conf \
  home/lumin/.config/waybar/config \
  home/lumin/.config/wofi/config \
  home/lumin/.config/fuzzel/fuzzel.ini \
  usr/local/bin/lumin-menu \
  >/dev/null

check "customize_airootfs ran" "test -f '${root}/etc/luminos-live-ready'"
check "SDDM session=luminos-glass" "grep -q 'Session=luminos-glass' '${root}/etc/sddm.conf.d/luminos.conf'"
check "SDDM theme=luminos" "grep -q 'Current=luminos' '${root}/etc/sddm.conf.d/luminos.conf'"
check "SDDM theme files present" "test -f '${root}/usr/share/sddm/themes/luminos/Main.qml'"
check "SDDM background present" "test -f '${root}/usr/share/sddm/themes/luminos/background.jpg'"
check "logo pixmaps present" "test -f '${root}/usr/share/pixmaps/luminos.svg'"
check "lumin-hyprland wrapper present" "test -x '${root}/usr/local/bin/lumin-hyprland'"
check "wrapper calls start-hyprland" "grep -q 'start-hyprland' '${root}/usr/local/bin/lumin-hyprland'"
check "luminos-glass.desktop present" "test -f '${root}/usr/share/wayland-sessions/luminos-glass.desktop'"
check "hypr config has Alt+Return" "grep -q 'bind = ALT, Return' '${root}/home/lumin/.config/hypr/hyprland.conf'"
check "hypr config opens foot on start" "grep -q 'exec-once = foot' '${root}/home/lumin/.config/hypr/hyprland.conf'"
check "hypr welcome notification" "grep -q 'Welcome to LuminOS Glass' '${root}/home/lumin/.config/hypr/hyprland.conf'"
check "hypr config has no pseudotile" "! grep -qE '^[[:space:]]*pseudotile[[:space:]]*=' '${root}/home/lumin/.config/hypr/hyprland.conf'"
check "waybar has LuminOS menu button" "grep -q 'custom/menu' '${root}/home/lumin/.config/waybar/config'"
check "lumin-menu launcher present" "test -x '${root}/usr/local/bin/lumin-menu'"
check "fuzzel config present" "test -f '${root}/home/lumin/.config/fuzzel/fuzzel.ini'"
check "thunar installed" "test -x '${root}/usr/bin/thunar'"
check "hypr opens menu via script" "grep -q 'lumin-menu' '${root}/home/lumin/.config/hypr/hyprland.conf'"
check "lumin password is set" "awk -F: '\$1==\"lumin\" && length(\$2)>0 {found=1} END{exit !found}' '${root}/etc/shadow'"
check "root password is set" "awk -F: '\$1==\"root\" && length(\$2)>0 {found=1} END{exit !found}' '${root}/etc/shadow'"

if [[ "${fail}" -ne 0 ]]; then
  echo "ERROR: ISO failed content verification: ${ISO_PATH}" >&2
  exit 1
fi
echo "==> ISO content verification PASSED: ${ISO_PATH}"
