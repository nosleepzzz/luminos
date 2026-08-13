#!/usr/bin/env bash
# LuminOS Custom Pacman Repository Generator (tools/make-repo.sh)

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIR="${PROJECT_DIR}/repo/x86_64"
BIN_DIR="${PROJECT_DIR}/iso/airootfs/usr/bin"

mkdir -p "${REPO_DIR}"

echo "=========================================================="
echo "  📦 LuminOS Pacman Repository Generator                  "
echo "=========================================================="

# Ensure all C binaries are built
"${PROJECT_DIR}/build-lumin.sh"

BUILD_PKG_DIR="/tmp/lumin-pkg-build"
rm -rf "${BUILD_PKG_DIR}"
mkdir -p "${BUILD_PKG_DIR}/usr/bin"

cp -r "${BIN_DIR}"/* "${BUILD_PKG_DIR}/usr/bin/"

# Create PKGINFO metadata
cat << 'EOF' > "${BUILD_PKG_DIR}/.PKGINFO"
pkgname = lumin-tools
pkgver = 1.0.0-1
pkgdesc = LuminOS Native C System Utilities, Gaming Engine, & Windows Installer Helper
url = https://github.com/nosleepzzz/luminos
builddate = 1786591200
packager = LuminOS Project <dev@luminos.org>
size = 2097152
arch = x86_64
license = GPL3
depend = bubblewrap
depend = mesa
depend = winetricks
EOF

# Package into .pkg.tar.zst using tar & zstd
PKG_FILE="${REPO_DIR}/lumin-tools-1.0.0-1-x86_64.pkg.tar.zst"
echo "==> Creating Arch Pacman Package: ${PKG_FILE}..."
(cd "${BUILD_PKG_DIR}" && tar -cf - .PKGINFO usr/ | zstd -c -z -q -19 - > "${PKG_FILE}")

echo "==> Generating Repo Database: luminos.db.tar.gz..."
(cd "${REPO_DIR}" && repo-add -n -R luminos.db.tar.gz lumin-tools-1.0.0-1-x86_64.pkg.tar.zst)

echo "=========================================================="
echo "✅ LuminOS Pacman Repository Created at ${REPO_DIR}"
echo "   • Package:  lumin-tools-1.0.0-1-x86_64.pkg.tar.zst"
echo "   • DB File:  luminos.db.tar.gz"
echo "   • Usage in /etc/pacman.conf:"
echo "     [luminos]"
echo "     Server = https://nosleepzzz.github.io/luminos/repo/\$arch"
echo "=========================================================="
