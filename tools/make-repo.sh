#!/usr/bin/env bash
# Optional pacman repo generator for lumin-tools (Linux with repo-add/zstd)
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIR="${PROJECT_DIR}/repo/x86_64"
BIN_DIR="${PROJECT_DIR}/iso/airootfs/usr/bin"

mkdir -p "${REPO_DIR}"

echo "=========================================================="
echo "  LuminOS pacman repository generator"
echo "=========================================================="

"${PROJECT_DIR}/build-lumin.sh"

BUILD_PKG_DIR="$(mktemp -d)"
cleanup() { rm -rf "${BUILD_PKG_DIR}"; }
trap cleanup EXIT

mkdir -p "${BUILD_PKG_DIR}/usr/bin"
cp -a "${BIN_DIR}/." "${BUILD_PKG_DIR}/usr/bin/"

cat <<'EOF' > "${BUILD_PKG_DIR}/.PKGINFO"
pkgname = lumin-tools
pkgver = 1.0.0-1
pkgdesc = LuminOS native helper utilities (Glass Phase 1)
url = https://github.com/nosleepzzz/luminos
packager = LuminOS Project
arch = x86_64
license = GPL3
EOF

PKG_FILE="${REPO_DIR}/lumin-tools-1.0.0-1-x86_64.pkg.tar.zst"
echo "==> Creating ${PKG_FILE}"
(cd "${BUILD_PKG_DIR}" && tar -cf - .PKGINFO usr/ | zstd -c -z -q -19 - > "${PKG_FILE}")

if command -v repo-add >/dev/null 2>&1; then
  (cd "${REPO_DIR}" && repo-add -n -R luminos.db.tar.gz "$(basename "${PKG_FILE}")")
else
  echo "NOTE: repo-add not found; package archive created without db update."
fi

echo "Done. Repo dir: ${REPO_DIR}"
