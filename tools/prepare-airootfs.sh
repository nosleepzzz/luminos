#!/usr/bin/env bash
# Prepare airootfs overlays that require Unix symlinks (run on Linux before mkarchiso).
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AIROOTFS="${PROJECT_DIR}/iso/airootfs"

echo "==> Preparing LuminOS Glass airootfs overlays"

# Wallpaper
mkdir -p "${AIROOTFS}/usr/share/backgrounds/luminos"
if [[ -f "${PROJECT_DIR}/assets/lumin-wallpaper.jpg" ]]; then
  cp -f "${PROJECT_DIR}/assets/lumin-wallpaper.jpg" \
    "${AIROOTFS}/usr/share/backgrounds/luminos/lumin-wallpaper.jpg"
fi

# Live user home from skel
mkdir -p "${AIROOTFS}/home/lumin"
if [[ -d "${AIROOTFS}/etc/skel" ]]; then
  cp -a "${AIROOTFS}/etc/skel/." "${AIROOTFS}/home/lumin/"
fi
chown -R 1000:1000 "${AIROOTFS}/home/lumin" 2>/dev/null || true

# systemd enables (relative links into /usr/lib once packages are installed on ISO)
SYS="${AIROOTFS}/etc/systemd/system"
mkdir -p "${SYS}/multi-user.target.wants" "${SYS}/graphical.target.wants"

ln -sfn /usr/lib/systemd/system/NetworkManager.service \
  "${SYS}/multi-user.target.wants/NetworkManager.service"
ln -sfn /usr/lib/systemd/system/power-profiles-daemon.service \
  "${SYS}/multi-user.target.wants/power-profiles-daemon.service"
ln -sfn /usr/lib/systemd/system/sddm.service \
  "${SYS}/display-manager.service"

# Ensure sudoers dir mode
chmod 750 "${AIROOTFS}/etc/sudoers.d" 2>/dev/null || true
chmod 440 "${AIROOTFS}/etc/sudoers.d/g_wheel" 2>/dev/null || true

echo "==> airootfs prepare complete"
