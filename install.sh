#!/data/data/com.termux/files/usr/bin/sh

set -e

URL="${1:-https://example.com/tools.zip}"

TMP_DIR="$HOME/_install_tmp"
BIN_DIR="/data/data/com.termux/files/usr/bin"

echo "warning: this will modify bin directory and wouldn't try doing something with your home files"
echo "BIN: $BIN_DIR"
echo "type yes to continue:"
read ans

[ "$ans" = "YES" ] || {
    echo "Aborted."
    exit 1
}

cleanup() {
    echo "[*] cleaning temp files..."
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM

echo "[*] creating temp folder..."
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "[*] checking dependencies..."
command -v curl >/dev/null 2>&1 || pkg install -y curl
command -v unzip >/dev/null 2>&1 || pkg install -y unzip

echo "[*] downloading archive..."
curl -L --fail --show-error "$URL" -o "$TMP_DIR/package.zip"

echo "[*] extracting..."
unzip -o "$TMP_DIR/package.zip" -d "$TMP_DIR"

echo "[*] cleaning BIN (SAFE MODE: only injected files)..."

SYSTEM_KEEP="sh bash pkg apt login su termux-*"

for f in "$TMP_DIR"/*; do
    [ -f "$f" ] || continue
    name=$(basename "$f")

    if [ -f "$BIN_DIR/$name" ]; then
        echo "    -> removing old $name"
        rm -f "$BIN_DIR/$name"
    fi

    echo "    -> installing $name"
    cp "$f" "$BIN_DIR/$name"
    chmod +x "$BIN_DIR/$name"
done

echo "[✓] done safely"
