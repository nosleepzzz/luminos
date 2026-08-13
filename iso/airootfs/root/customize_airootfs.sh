#!/usr/bin/env bash
# Runs inside arch-chroot AFTER packages are installed (mkarchiso).
# This is the only reliable place to set live passwords / mask firstboot.
set -euo pipefail

echo "==> LuminOS customize_airootfs"

# Live credentials (empty password is rejected by SDDM PAM)
echo 'root:lumin' | chpasswd
echo 'lumin:lumin' | chpasswd

# Pre-seed everything systemd-firstboot would ask (mkarchiso forces machine-id=uninitialized)
ln -sfn /usr/share/zoneinfo/UTC /etc/localtime
printf 'KEYMAP=us\n' >/etc/vconsole.conf
printf 'LANG=en_US.UTF-8\n' >/etc/locale.conf
printf 'luminos\n' >/etc/hostname

# Kill interactive firstboot even when machine-id is "uninitialized"
ln -sfn /dev/null /etc/systemd/system/systemd-firstboot.service

# Graphical live session
ln -sfn /usr/lib/systemd/system/sddm.service /etc/systemd/system/display-manager.service
ln -sfn /usr/lib/systemd/system/graphical.target /etc/systemd/system/default.target
systemctl enable NetworkManager.service 2>/dev/null || true
systemctl enable sshd.service 2>/dev/null || true

# Software rendering for VirtualBox / VMs without working GL
if [[ -f /etc/environment ]]; then
  grep -q 'WLR_RENDERER_ALLOW_SOFTWARE' /etc/environment || \
    printf '\nWLR_RENDERER_ALLOW_SOFTWARE=1\nWLR_NO_HARDWARE_CURSORS=1\n' >>/etc/environment
fi

echo "==> customize_airootfs done"
