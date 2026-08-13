#!/usr/bin/env bash
# Prepare airootfs overlays that require Unix symlinks (run on Linux before mkarchiso).
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AIROOTFS="${PROJECT_DIR}/iso/airootfs"

echo "==> Preparing LuminOS Glass airootfs overlays"

wall_src="${PROJECT_DIR}/assets/lumin-wallpaper.jpg"
if [[ ! -f "${wall_src}" ]]; then
  wall_src="${AIROOTFS}/usr/share/backgrounds/luminos/lumin-wallpaper.jpg"
fi

mkdir -p "${AIROOTFS}/usr/share/backgrounds/luminos"
mkdir -p "${AIROOTFS}/usr/share/sddm/themes/luminos"
mkdir -p "${AIROOTFS}/usr/share/pixmaps"
mkdir -p "${AIROOTFS}/usr/share/icons/hicolor/scalable/apps"
mkdir -p "${PROJECT_DIR}/iso/grub/themes/luminos"
mkdir -p "${PROJECT_DIR}/iso/syslinux"

if [[ -f "${wall_src}" ]]; then
  cp -f "${wall_src}" "${AIROOTFS}/usr/share/backgrounds/luminos/lumin-wallpaper.jpg"
  cp -f "${wall_src}" "${AIROOTFS}/usr/share/sddm/themes/luminos/background.jpg"

  if [[ -f "${PROJECT_DIR}/iso/grub/themes/luminos/background.png" ]]; then
    :
  elif command -v magick >/dev/null 2>&1; then
    magick "${wall_src}" -resize 1920x1080^ -gravity center -extent 1920x1080 \
      "${PROJECT_DIR}/iso/grub/themes/luminos/background.png"
  elif command -v convert >/dev/null 2>&1; then
    convert "${wall_src}" -resize 1920x1080^ -gravity center -extent 1920x1080 \
      "${PROJECT_DIR}/iso/grub/themes/luminos/background.png"
  elif command -v ffmpeg >/dev/null 2>&1; then
    ffmpeg -y -loglevel error -i "${wall_src}" \
      -vf "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080" \
      "${PROJECT_DIR}/iso/grub/themes/luminos/background.png"
  else
    echo "WARNING: no background.png and no imagemagick/ffmpeg — GRUB theme may lack wallpaper."
  fi

  if [[ ! -f "${PROJECT_DIR}/iso/syslinux/splash.png" ]]; then
    if command -v magick >/dev/null 2>&1; then
      magick "${wall_src}" -resize 1024x768! "${PROJECT_DIR}/iso/syslinux/splash.png"
    elif command -v convert >/dev/null 2>&1; then
      convert "${wall_src}" -resize 1024x768! "${PROJECT_DIR}/iso/syslinux/splash.png"
    elif command -v ffmpeg >/dev/null 2>&1; then
      ffmpeg -y -loglevel error -i "${wall_src}" -vf scale=1024:768 \
        "${PROJECT_DIR}/iso/syslinux/splash.png"
    else
      echo "WARNING: no splash.png and no imagemagick/ffmpeg — BIOS menu background may be missing."
    fi
  fi
else
  echo "WARNING: wallpaper source not found under assets/ or airootfs."
fi

logo_src="${PROJECT_DIR}/assets/lumin-logo.svg"
if [[ -f "${logo_src}" ]]; then
  cp -f "${logo_src}" "${AIROOTFS}/usr/share/pixmaps/luminos.svg"
  cp -f "${logo_src}" "${AIROOTFS}/usr/share/icons/hicolor/scalable/apps/luminos.svg"
fi

# Live user home from skel (single source of truth for desktop dotfiles)
mkdir -p "${AIROOTFS}/home/lumin"
if [[ -d "${AIROOTFS}/etc/skel" ]]; then
  cp -a "${AIROOTFS}/etc/skel/." "${AIROOTFS}/home/lumin/"
fi
chown -R 1000:1000 "${AIROOTFS}/home/lumin" 2>/dev/null || true

# systemd enables (final password/firstboot mask also applied in customize_airootfs.sh)
SYS="${AIROOTFS}/etc/systemd/system"
mkdir -p "${SYS}/multi-user.target.wants" "${SYS}/graphical.target.wants"

ln -sfn /usr/lib/systemd/system/NetworkManager.service \
  "${SYS}/multi-user.target.wants/NetworkManager.service"
ln -sfn /usr/lib/systemd/system/power-profiles-daemon.service \
  "${SYS}/multi-user.target.wants/power-profiles-daemon.service"
ln -sfn /usr/lib/systemd/system/sshd.service \
  "${SYS}/multi-user.target.wants/sshd.service"
ln -sfn /usr/lib/systemd/system/sddm.service \
  "${SYS}/display-manager.service"
ln -sfn /usr/lib/systemd/system/graphical.target \
  "${SYS}/default.target"
ln -sfn /dev/null "${SYS}/systemd-firstboot.service"

chmod 750 "${AIROOTFS}/etc/sudoers.d" 2>/dev/null || true
chmod 440 "${AIROOTFS}/etc/sudoers.d/g_wheel" 2>/dev/null || true
chmod 755 "${AIROOTFS}/root/customize_airootfs.sh" 2>/dev/null || true
for _bin in lumin-hyprland lumin-session-init lumin-menu lumin-terminal lumin-files; do
  chmod 755 "${AIROOTFS}/usr/local/bin/${_bin}" 2>/dev/null || true
done

if [[ -e /usr/share/zoneinfo/UTC ]]; then
  ln -sfn /usr/share/zoneinfo/UTC "${AIROOTFS}/etc/localtime"
fi

: > "${AIROOTFS}/etc/machine-id"

echo "==> airootfs prepare complete"
