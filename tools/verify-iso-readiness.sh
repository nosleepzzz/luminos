#!/usr/bin/env bash
# Structural readiness checks for the Glass ISO profile (no mkarchiso required)
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${PROJECT_DIR}"

echo "=========================================================="
echo "  LuminOS Glass ISO readiness audit"
echo "=========================================================="

ERRORS=0

check_file() {
  if [[ -f "$1" ]]; then
    echo "  [PASS] $2"
  else
    echo "  [FAIL] Missing: $1 ($2)"
    ERRORS=$((ERRORS + 1))
  fi
}

check_dir() {
  if [[ -d "$1" ]]; then
    echo "  [PASS] $2"
  else
    echo "  [FAIL] Missing dir: $1 ($2)"
    ERRORS=$((ERRORS + 1))
  fi
}

echo "1. Profile core..."
check_file "iso/packages.x86_64" "Package manifest"
check_file "iso/pacman.conf" "Build pacman.conf"
check_file "iso/profiledef.sh" "profiledef.sh"
check_file "iso/airootfs/etc/os-release" "os-release"
check_file "iso/airootfs/etc/hostname" "hostname"

echo ""
echo "2. Glass desktop overlays..."
check_file "iso/airootfs/etc/skel/.config/hypr/hyprland.conf" "Hyprland config"
check_file "iso/airootfs/etc/sddm.conf.d/luminos.conf" "SDDM autologin"
check_file "iso/airootfs/etc/systemd/zram-generator.conf" "ZRAM generator"

echo ""
echo "3. Sources..."
check_file "src/lumin-fetch.c" "lumin-fetch.c"
check_file "src/lumin-mgr.c" "lumin-mgr.c"
check_file "src/lumin-install.c" "lumin-install.c"

echo ""
echo "4. Package anchors..."
for pkg in base linux-cachyos hyprland networkmanager sddm; do
  if grep -Eq "^${pkg}$" iso/packages.x86_64; then
    echo "  [PASS] packages.x86_64 contains ${pkg}"
  else
    echo "  [FAIL] packages.x86_64 missing ${pkg}"
    ERRORS=$((ERRORS + 1))
  fi
done

# Lean policy: no heavy DE / gaming stack in base
for pkg in plasma-desktop wine winetricks steam; do
  if grep -Eq "^${pkg}$" iso/packages.x86_64; then
    echo "  [FAIL] lean policy violated: ${pkg} present"
    ERRORS=$((ERRORS + 1))
  else
    echo "  [PASS] lean policy: ${pkg} absent"
  fi
done

echo ""
echo "=========================================================="
if [[ "${ERRORS}" -eq 0 ]]; then
  echo "Audit passed. Ready for a Linux mkarchiso host (see docs/BUILDING.md)."
  exit 0
fi
echo "Audit failed with ${ERRORS} error(s)."
exit 1
