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

# Timezone for overlay (customize_airootfs.sh also sets this inside the chroot)
if [[ -e /usr/share/zoneinfo/UTC ]]; then
  ln -sfn /usr/share/zoneinfo/UTC "${AIROOTFS}/etc/localtime"
fi

# Empty machine-id: mkarchiso will overwrite with "uninitialized" — cmdline + mask handle that
: > "${AIROOTFS}/etc/machine-id"

echo "==> airootfs prepare complete"
