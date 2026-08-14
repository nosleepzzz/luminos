#!/usr/bin/env bash
# Verify a built LuminOS Glass ISO is bootable/usable.
set -euo pipefail

ISO_PATH="${1:-}"
if [[ -z "${ISO_PATH}" || ! -f "${ISO_PATH}" ]]; then
  echo "Usage: sudo bash tools/verify-iso-contents.sh /path/to/luminos-glass-*.iso" >&2
  exit 2
fi
if ! command -v unsquashfs >/dev/null 2>&1; then
  echo "ERROR: unsquashfs required (pacman -S squashfs-tools)" >&2
  exit 1
fi
if [[ "$(id -u)" -ne 0 ]]; then
  echo "ERROR: run as root: sudo bash tools/verify-iso-contents.sh ${ISO_PATH}" >&2
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
warn=0
check() {
  local desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "OK  ${desc}"
  else
    echo "FAIL ${desc}"
    fail=1
  fi
}
warn_check() {
  local desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "OK  ${desc}"
  else
    echo "WARN ${desc}"
    warn=1
  fi
}
check_absent() {
  local desc="$1"
  local file="$2"
  local pattern="$3"
  if grep -qE "${pattern}" "${file}" 2>/dev/null; then
    echo "FAIL ${desc}"
    fail=1
  else
    echo "OK  ${desc}"
  fi
}

echo "==> Core boot checks"
check "grub has systemd.firstboot=off" grep -q 'systemd.firstboot=off' "${mnt}/boot/grub/grub.cfg"
check "grub has luminos-console entry" grep -q 'luminos-console' "${mnt}/boot/grub/grub.cfg"

sfs="${mnt}/luminos/x86_64/airootfs.sfs"
check "airootfs.sfs present" test -f "${sfs}"

unsquashfs -d "${root}" "${sfs}" \
  etc/luminos-live-ready \
  etc/sddm.conf.d/luminos.conf \
  etc/shadow \
  usr/local/bin/lumin-hyprland \
  usr/local/bin/lumin-menu \
  usr/local/bin/lumin-terminal \
  usr/share/wayland-sessions/luminos-glass.desktop \
  home/lumin/.config/hypr/hyprland.conf \
  home/lumin/.config/waybar/config \
  home/lumin/.config/fuzzel/fuzzel.ini \
  usr/bin/thunar \
  >/dev/null

hypr_conf="${root}/home/lumin/.config/hypr/hyprland.conf"

check "customize_airootfs ran" test -f "${root}/etc/luminos-live-ready"
check "SDDM session=luminos-glass" grep -q 'Session=luminos-glass' "${root}/etc/sddm.conf.d/luminos.conf"
check "lumin-hyprland wrapper present" test -x "${root}/usr/local/bin/lumin-hyprland"
check "wrapper calls start-hyprland" grep -q 'start-hyprland' "${root}/usr/local/bin/lumin-hyprland"
check "lumin-menu launcher present" test -x "${root}/usr/local/bin/lumin-menu"
check "thunar installed" test -x "${root}/usr/bin/thunar"
check "hypr Alt+Return terminal" grep -q 'bind = ALT, Return' "${hypr_conf}"
check "hypr Alt+D menu" grep -q 'lumin-menu' "${hypr_conf}"
check "waybar LuminOS button" grep -q 'custom/menu' "${root}/home/lumin/.config/waybar/config"
check "lumin password set" awk -F: '$1=="lumin" && length($2)>0 {found=1} END{exit !found}' "${root}/etc/shadow"
check_absent "hypr no pseudotile option" "${hypr_conf}" '^[[:space:]]*pseudotile[[:space:]]*='

echo "==> Branding checks (warn only)"
warn_check "grub theme" test -f "${mnt}/boot/grub/themes/luminos/theme.txt"
warn_check "grub theme background" test -f "${mnt}/boot/grub/themes/luminos/background.png"
warn_check "syslinux splash" test -f "${mnt}/boot/syslinux/splash.png"
warn_check "SDDM theme=luminos" grep -q 'Current=luminos' "${root}/etc/sddm.conf.d/luminos.conf"
warn_check "logo pixmaps" test -f "${root}/usr/share/pixmaps/luminos.svg"

if [[ "${fail}" -ne 0 ]]; then
  echo "ERROR: ISO failed core verification: ${ISO_PATH}" >&2
  exit 1
fi
if [[ "${warn}" -ne 0 ]]; then
  echo "==> ISO core verification PASSED with branding warnings: ${ISO_PATH}"
else
  echo "==> ISO verification PASSED: ${ISO_PATH}"
fi
