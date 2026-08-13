#!/usr/bin/env bash
# LuminOS Master ISO Builder Script
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${PROJECT_DIR}/out"

mkdir -p "${OUT_DIR}"

echo "=========================================================="
echo "  🌟 LuminOS ISO Builder                                  "
echo "=========================================================="
echo "  • Source Profile:  ${PROJECT_DIR}/iso"
echo "  • Output Directory: ${OUT_DIR}"
echo "=========================================================="

# 1. Recompile C binaries
"${PROJECT_DIR}/build-lumin.sh"

# 2. Check for Archiso toolchain
if ! command -v mkarchiso &> /dev/null; then
    echo "❌ ERROR: 'mkarchiso' toolchain is not installed."
    echo "   Building a real bootable 1.8 GB ISO image requires Archiso tools and root privileges."
    echo ""
    echo "👉 Please run this command in your terminal to install dependencies & build the ISO:"
    echo "   sudo pacman -S --noconfirm archiso xorriso squashfs-tools && sudo mkarchiso -v -w /tmp/lumin-tmp -o ./out ./iso"
    echo ""
    exit 1
fi

echo "==> Compiling full bootable ISO image with mkarchiso..."
sudo mkarchiso -v -w /tmp/lumin-archiso-tmp -o "${OUT_DIR}" "${PROJECT_DIR}/iso"

echo "=========================================================="
echo "✅ Real ISO Generation Complete!"
echo "📍 ISO Location: ${OUT_DIR}/lumin-os-v1.0-x86_64.iso"
echo "=========================================================="
