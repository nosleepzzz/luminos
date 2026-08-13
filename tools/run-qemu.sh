#!/usr/bin/env bash
# LuminOS QEMU Virtual Machine Test Launcher
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISO_PATH="${PROJECT_DIR}/out/lumin-os-v1.0.0-rc1-x86_64.iso"
DISK_PATH="/tmp/lumin-vm-disk.qcow2"

if [ ! -f "${ISO_PATH}" ]; then
  echo "❌ Error: ISO image not found at ${ISO_PATH}"
  exit 1
fi

if [ ! -f "${DISK_PATH}" ]; then
  echo "⚙️ Creating virtual disk image (20GB qcow2)..."
  qemu-img create -f qcow2 "${DISK_PATH}" 20G
fi

echo "=========================================================="
echo " 🚀 Booting LuminOS 1.5 GB ISO in QEMU VM                "
echo "=========================================================="
echo "  • ISO File: ${ISO_PATH}"
echo "  • RAM:      4096 MB"
echo "  • CPU:      Host Passthrough (KVM Enabled)"
echo "  • Display:  VirtIO GPU / GTK Window"
echo "=========================================================="

qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -cpu host \
  -smp 4 \
  -vga virtio \
  -display gtk,gl=on \
  -cdrom "${ISO_PATH}" \
  -hda "${DISK_PATH}" \
  -boot d
