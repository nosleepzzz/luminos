#!/usr/bin/env bash
# Master Build Script for LuminOS ("Windows & Gaming Killer")

set -e

BIN_DIR="./iso/airootfs/usr/bin"
mkdir -p "${BIN_DIR}"

echo "=========================================================="
echo "    🌟 Compiling LuminOS Binaries & Installer Engine      "
echo "=========================================================="

echo "==> Compiling Lumin Fetch Utility..."
gcc -O3 -Wall src/lumin-fetch.c -o "${BIN_DIR}/lumin-fetch"

echo "==> Compiling Lumin Control Manager..."
gcc -O3 -Wall src/lumin-mgr.c -o "${BIN_DIR}/lumin-mgr"

echo "==> Compiling Lumin Battery & Thermal Daemon..."
gcc -O3 -Wall src/lumin-powerd.c -o "${BIN_DIR}/lumin-powerd"

echo "==> Compiling Lumin Security & Sandbox Engine..."
gcc -O3 -Wall src/lumin-security.c -o "${BIN_DIR}/lumin-security"

echo "==> Compiling Lumin Gaming & Steam Engine..."
gcc -O3 -Wall src/lumin-game.c -o "${BIN_DIR}/lumin-game"

echo "==> Compiling Lumin One-Click App Installer Helper..."
gcc -O3 -Wall src/lumin-install.c -o "${BIN_DIR}/lumin-install"

echo "==> Creating system symlinks..."
ln -sf lumin-mgr "${BIN_DIR}/lumin" 2>/dev/null || true

chmod +x ${BIN_DIR}/*

echo "=========================================================="
echo "✅ LuminOS Binaries & One-Click Installer Ready!"
echo "=========================================================="
