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
mkdir -p /etc
cat >/etc/environment <<'EOF'
WLR_RENDERER_ALLOW_SOFTWARE=1
WLR_NO_HARDWARE_CURSORS=1
WLR_RENDERER=pixman
LIBGL_ALWAYS_SOFTWARE=1
GALLIUM_DRIVER=llvmpipe
AQ_NO_MODIFIERS=1
EOF

chmod 755 /usr/local/bin/lumin-hyprland 2>/dev/null || true
# Keep skel home in sync for live user
if [[ -d /etc/skel && -d /home/lumin ]]; then
  cp -a /etc/skel/. /home/lumin/
  chown -R lumin:lumin /home/lumin
fi

# Rescue: autologin on tty2 so VMs can always recover without SDDM
mkdir -p /etc/systemd/system/getty@tty2.service.d
cat >/etc/systemd/system/getty@tty2.service.d/autologin.conf <<'EOF'
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin lumin --noclear %I $TERM
EOF

echo "==> customize_airootfs done"
