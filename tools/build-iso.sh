#!/usr/bin/env bash
# LuminOS Glass ISO builder (requires Arch/CachyOS + archiso)
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${PROJECT_DIR}/out"
# Prefer project disk over /tmp (often tmpfs / too small for mkarchiso)
WORK_DIR="${WORK_DIR:-${PROJECT_DIR}/.build/work}"

mkdir -p "${OUT_DIR}" "$(dirname "${WORK_DIR}")"

echo "=========================================================="
echo "  LuminOS Glass ISO Builder"
echo "=========================================================="
echo "  Profile: ${PROJECT_DIR}/iso"
echo "  Work:    ${WORK_DIR}"
echo "  Output:  ${OUT_DIR}"
echo "=========================================================="

echo "==> Free space on build filesystem:"
df -h "${PROJECT_DIR}" || true
# Rough gate: desktop ISOs commonly need 25GB+ free during squash
avail_kb="$(df -Pk "${PROJECT_DIR}" | awk 'NR==2 {print $4}')"
if [[ -n "${avail_kb}" && "${avail_kb}" -lt 25000000 ]]; then
  echo "WARNING: less than ~25GB free under ${PROJECT_DIR}."
  echo "         Expand the VM disk or free space before continuing."
fi

bash "${PROJECT_DIR}/build-lumin.sh"
bash "${PROJECT_DIR}/tools/prepare-airootfs.sh"

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
