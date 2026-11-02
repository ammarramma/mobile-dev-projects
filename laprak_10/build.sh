#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

PANDOC="${PANDOC:-pandoc}"
WEASYPRINT="${WEASYPRINT:-/home/ramma/.venv/bin/weasyprint}"
MARKDOWN="Laprak_Mobile_10.md"
CSS="style-academic-formal.css"
BASE="Laprak_10_AcademicFormal"
TITLE="Laprak Mobile 10 - Academic Formal"
PDF_TMP="${BASE}.tmp.pdf"
HTML_TMP="${BASE}.tmp.html"

trap 'rm -f "$PDF_TMP" "$HTML_TMP"' EXIT

if [[ ! -x "$WEASYPRINT" ]]; then
  echo "WeasyPrint tidak ditemukan di: $WEASYPRINT" >&2
  echo "Aktifkan venv atau set WEASYPRINT ke path yang benar." >&2
  exit 1
fi

build() {
  "$PANDOC" "$MARKDOWN" \
    --css="$CSS" \
    --pdf-engine="$WEASYPRINT" \
    --syntax-highlighting=pygments \
    --standalone \
    --metadata pagetitle="$TITLE" \
    -o "$PDF_TMP"

  "$PANDOC" "$MARKDOWN" \
    --css="$CSS" \
    --syntax-highlighting=pygments \
    --standalone --embed-resources \
    --metadata pagetitle="$TITLE" \
    -o "$HTML_TMP"

  cp -f "$PDF_TMP" "${BASE}.pdf"
  cp -f "$HTML_TMP" "${BASE}.html"

  echo "Selesai:"
  echo "  - ${BASE}.pdf"
  echo "  - ${BASE}.html"
}

wait_for_change() {
  python3 - "$MARKDOWN" "$CSS" <<'PY'
import os
import sys
import time

files = sys.argv[1:]
mtimes = {path: os.path.getmtime(path) for path in files}

while True:
    time.sleep(0.4)
    changed = [path for path in files if os.path.getmtime(path) != mtimes[path]]
    if not changed:
        continue

    time.sleep(0.2)
    for path in files:
        mtimes[path] = os.path.getmtime(path)

    print("Perubahan terdeteksi: " + ", ".join(changed), flush=True)
    break
PY
}

case "${1:-}" in
  "")
    build
    ;;
  --watch)
    echo "Mode watch aktif. Simpan $MARKDOWN atau $CSS untuk build ulang."
    echo "Tekan Ctrl+C untuk berhenti."
    while true; do
      build || echo "Build gagal. Menunggu perubahan berikutnya..." >&2
      wait_for_change
    done
    ;;
  *)
    echo "Usage: $0 [--watch]" >&2
    exit 2
    ;;
esac
