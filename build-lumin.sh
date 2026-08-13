#!/usr/bin/env bash
# Compile LuminOS native helpers into the ISO airootfs bindir
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${PROJECT_DIR}/iso/airootfs/usr/bin"
mkdir -p "${BIN_DIR}"

CFLAGS="${CFLAGS:--O2 -Wall -Wextra}"

echo "=========================================================="
echo "  Compiling LuminOS helpers"
echo "=========================================================="

compile_one() {
  local src="$1"
  local out="$2"
  echo "==> ${out}"
  # shellcheck disable=SC2086
  gcc ${CFLAGS} "${src}" -o "${BIN_DIR}/${out}"
}

compile_one "${PROJECT_DIR}/src/lumin-fetch.c" "lumin-fetch"
compile_one "${PROJECT_DIR}/src/lumin-mgr.c" "lumin-mgr"
compile_one "${PROJECT_DIR}/src/lumin-powerd.c" "lumin-powerd"
compile_one "${PROJECT_DIR}/src/lumin-security.c" "lumin-security"
compile_one "${PROJECT_DIR}/src/lumin-game.c" "lumin-game"
compile_one "${PROJECT_DIR}/src/lumin-install.c" "lumin-install"

ln -sfn lumin-mgr "${BIN_DIR}/lumin"
chmod 755 "${BIN_DIR}/lumin-"* "${BIN_DIR}/lumin"

echo "=========================================================="
echo "  Done -> ${BIN_DIR}"
echo "=========================================================="
