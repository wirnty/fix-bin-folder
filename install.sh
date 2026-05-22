#!/data/data/com.termux/files/usr/bin/sh

set -e

URL="https://neontal.ps.fhgdps.com/download/tools.zip"   # <-- поменяй на свою ссылку
TMP_DIR="$HOME/_install_tmp"
DEST_HOME="$HOME"
DEST_BIN="/data/data/com.termux/files/usr/bin"
BACKUP="$HOME/bin_backup_$(date +%s).tar.gz"

echo "[*] creating temp folder..."
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "[*] downloading archive..."
pkg install -y curl unzip >/dev/null 2>&1

curl -L "$URL" -o "$TMP_DIR/package.zip"

echo "[*] extracting..."
unzip -o "$TMP_DIR/package.zip" -d "$TMP_DIR"

echo "[*] backup usr/bin..."
tar -czf "$BACKUP" "$DEST_BIN" 2>/dev/null || true
echo "[*] backup saved: $BACKUP"

echo "[*] copying files to home..."
cp -r "$TMP_DIR"/* "$DEST_HOME"/

echo "[*] moving executables to usr/bin..."
for f in "$TMP_DIR"/*; do
    if [ -f "$f" ]; then
        name=$(basename "$f")
        cp "$f" "$DEST_BIN/$name"
        chmod +x "$DEST_BIN/$name"
    fi
done

echo "[*] cleaning..."
rm -rf "$TMP_DIR"

echo "[✓] done"
