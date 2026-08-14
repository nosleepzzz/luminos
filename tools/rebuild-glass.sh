#!/usr/bin/env bash
# One-command clean Glass ISO rebuild on the CachyOS build VM.
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${PROJECT_DIR}"

echo "==> Syncing to origin/main"
git fetch origin
git reset --hard origin/main
git log -1 --oneline

echo "==> Cleaning old build artifacts"
rm -rf "${PROJECT_DIR}/.build/work"
rm -f "${PROJECT_DIR}"/out/luminos-glass-*.iso

if [[ "$(id -u)" -ne 0 ]]; then
  echo "==> Re-invoking as root for mkarchiso"
  exec sudo -- "$0" "$@"
fi

exec "${PROJECT_DIR}/tools/build-iso.sh"
