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
  if "$@" >/dev/null 2>&1; then
    echo "OK  ${desc}"
  else
    echo "FAIL ${desc}"
    fail=1
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

check "grub has systemd.firstboot=off" grep -q 'systemd.firstboot=off' "${mnt}/boot/grub/grub.cfg"
check "grub has luminos-console entry" grep -q 'luminos-console' "${mnt}/boot/grub/grub.cfg"
check "grub theme present" test -f "${mnt}/boot/grub/themes/luminos/theme.txt"
check "grub theme background present" test -f "${mnt}/boot/grub/themes/luminos/background.png"
check "syslinux splash present" test -f "${mnt}/boot/syslinux/splash.png"

sfs="${mnt}/luminos/x86_64/airootfs.sfs"
[[ -f "${sfs}" ]] || { echo "FAIL missing airootfs.sfs"; exit 1; }

unsquashfs -d "${root}" "${sfs}" \
  etc/luminos-live-ready \
  etc/sddm.conf.d/luminos.conf \
  etc/shadow \
  usr/local/bin/lumin-hyprland \
  usr/local/bin/lumin-menu \
  usr/local/bin/lumin-terminal \
  usr/share/wayland-sessions/luminos-glass.desktop \
  usr/share/sddm/themes/luminos/Main.qml \
  usr/share/sddm/themes/luminos/background.jpg \
  usr/share/pixmaps/luminos.svg \
  home/lumin/.config/hypr/hyprland.conf \
  home/lumin/.config/waybar/config \
  home/lumin/.config/fuzzel/fuzzel.ini \
  usr/bin/thunar \
  >/dev/null

hypr_conf="${root}/home/lumin/.config/hypr/hyprland.conf"

check "customize_airootfs ran" test -f "${root}/etc/luminos-live-ready"
check "SDDM session=luminos-glass" grep -q 'Session=luminos-glass' "${root}/etc/sddm.conf.d/luminos.conf"
check "SDDM theme=luminos" grep -q 'Current=luminos' "${root}/etc/sddm.conf.d/luminos.conf"
check "SDDM theme files present" test -f "${root}/usr/share/sddm/themes/luminos/Main.qml"
check "SDDM background present" test -f "${root}/usr/share/sddm/themes/luminos/background.jpg"
check "logo pixmaps present" test -f "${root}/usr/share/pixmaps/luminos.svg"
check "lumin-hyprland wrapper present" test -x "${root}/usr/local/bin/lumin-hyprland"
check "wrapper calls start-hyprland" grep -q 'start-hyprland' "${root}/usr/local/bin/lumin-hyprland"
check "luminos-glass.desktop present" test -f "${root}/usr/share/wayland-sessions/luminos-glass.desktop"
check "hypr config has Alt+Return" grep -q 'bind = ALT, Return' "${hypr_conf}"
check "hypr config opens terminal on start" grep -qE 'exec-once = (/usr/local/bin/lumin-terminal|foot)' "${hypr_conf}"
check "hypr welcome notification" grep -q 'notify-send' "${hypr_conf}"
check_absent "hypr config has no pseudotile" "${hypr_conf}" '^[[:space:]]*pseudotile[[:space:]]*='
check "waybar has LuminOS menu button" grep -q 'custom/menu' "${root}/home/lumin/.config/waybar/config"
check "lumin-menu launcher present" test -x "${root}/usr/local/bin/lumin-menu"
check "fuzzel config present" test -f "${root}/home/lumin/.config/fuzzel/fuzzel.ini"
check "thunar installed" test -x "${root}/usr/bin/thunar"
check "hypr opens menu via script" grep -q 'lumin-menu' "${hypr_conf}"
check "lumin password is set" awk -F: '$1=="lumin" && length($2)>0 {found=1} END{exit !found}' "${root}/etc/shadow"
check "root password is set" awk -F: '$1=="root" && length($2)>0 {found=1} END{exit !found}' "${root}/etc/shadow"

if [[ "${fail}" -ne 0 ]]; then
  echo "ERROR: ISO failed content verification: ${ISO_PATH}" >&2
  exit 1
fi
echo "==> ISO content verification PASSED: ${ISO_PATH}"
