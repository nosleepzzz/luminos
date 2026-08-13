#!/usr/bin/env bash
# Runs inside arch-chroot AFTER packages are installed (mkarchiso).
set -euo pipefail

echo "==> LuminOS customize_airootfs"

echo 'root:lumin' | chpasswd
echo 'lumin:lumin' | chpasswd

ln -sfn /usr/share/zoneinfo/UTC /etc/localtime
printf 'KEYMAP=us\n' >/etc/vconsole.conf
printf 'LANG=en_US.UTF-8\n' >/etc/locale.conf
printf 'luminos\n' >/etc/hostname

ln -sfn /dev/null /etc/systemd/system/systemd-firstboot.service
ln -sfn /usr/lib/systemd/system/sddm.service /etc/systemd/system/display-manager.service
ln -sfn /usr/lib/systemd/system/graphical.target /etc/systemd/system/default.target

systemctl enable NetworkManager.service 2>/dev/null || true
systemctl enable sshd.service 2>/dev/null || true
systemctl enable vboxservice.service 2>/dev/null || true
systemctl enable seatd.service 2>/dev/null || true

cat >/etc/environment <<'EOF'
WLR_RENDERER_ALLOW_SOFTWARE=1
WLR_NO_HARDWARE_CURSORS=1
WLR_RENDERER=pixman
LIBGL_ALWAYS_SOFTWARE=1
GALLIUM_DRIVER=llvmpipe
AQ_NO_MODIFIERS=1
EOF

install -d -m 0755 /usr/local/bin
chmod 755 /usr/local/bin/lumin-hyprland
test -x /usr/local/bin/lumin-hyprland
test -f /usr/share/wayland-sessions/luminos-glass.desktop
command -v start-hyprland >/dev/null
grep -q 'Session=luminos-glass' /etc/sddm.conf.d/luminos.conf
grep -q 'Current=luminos' /etc/sddm.conf.d/luminos.conf
grep -q 'bind = ALT, Return' /etc/skel/.config/hypr/hyprland.conf
grep -q 'custom/menu' /etc/skel/.config/waybar/config
test -f /usr/share/sddm/themes/luminos/Main.qml
test -f /usr/share/sddm/themes/luminos/background.jpg
test -f /usr/share/pixmaps/luminos.svg
! grep -qE '^[[:space:]]*pseudotile[[:space:]]*=' /etc/skel/.config/hypr/hyprland.conf

# Live user home = skel (waybar menu + hypr config)
usermod -aG seat,video,input,render lumin 2>/dev/null || true

install -d -m 0750 -o lumin -g lumin /home/lumin
cp -a /etc/skel/. /home/lumin/
chown -R lumin:lumin /home/lumin

# Rescue TTY autologin (Host/Ctrl+Alt+F2)
mkdir -p /etc/systemd/system/getty@tty2.service.d
cat >/etc/systemd/system/getty@tty2.service.d/autologin.conf <<'EOF'
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin lumin --noclear %I $TERM
EOF

# Prove customize ran (build verifier looks for this)
printf 'luminos-customize-ok\n' >/etc/luminos-live-ready

echo "==> customize_airootfs done"
