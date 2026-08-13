#!/usr/bin/env bash
# LuminOS Glass ISO builder (requires Arch/CachyOS + archiso)
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${PROJECT_DIR}/out"
WORK_DIR="${WORK_DIR:-/tmp/lumin-archiso-tmp}"

mkdir -p "${OUT_DIR}"

echo "=========================================================="
echo "  LuminOS Glass ISO Builder"
echo "=========================================================="
echo "  Profile: ${PROJECT_DIR}/iso"
echo "  Output:  ${OUT_DIR}"
echo "=========================================================="

"${PROJECT_DIR}/build-lumin.sh"
"${PROJECT_DIR}/tools/prepare-airootfs.sh"

if ! command -v mkarchiso >/dev/null 2>&1; then
  echo "ERROR: mkarchiso not found."
  echo "On CachyOS/Arch install: sudo pacman -S --needed archiso squashfs-tools grub"
  echo "See docs/BUILDING.md"
  exit 1
fi

if [[ "$(id -u)" -ne 0 ]]; then
  echo "ERROR: ISO build must run as root (sudo)."
  exit 1
fi

# Import CachyOS keys when available on the build host
if command -v pacman-key >/dev/null 2>&1; then
  pacman-key --populate archlinux 2>/dev/null || true
  pacman-key --populate cachyos 2>/dev/null || true
fi

rm -rf "${WORK_DIR}"
mkarchiso -v -w "${WORK_DIR}" -o "${OUT_DIR}" "${PROJECT_DIR}/iso"

echo "=========================================================="
echo "  ISO build finished. Check ${OUT_DIR}"
echo "=========================================================="
