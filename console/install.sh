#!/usr/bin/env bash
set -euo pipefail

# Always run relative to this script's directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[*] Building KhajuBridge console..."
cd "$ROOT_DIR/cmd/khajunbgui"
go build -o khajunbgui

echo "[*] Installing binary..."
sudo install -m 0755 khajunbgui /usr/local/bin/khajunbgui

echo "[*] Installing config..."
sudo mkdir -p /etc/khajubridge
sudo install -m 0644 "$ROOT_DIR/env.example" /etc/khajubridge/console.env

echo "[*] Installing systemd service..."
sudo install -m 0644 "$ROOT_DIR/khajunbgui.service" /etc/systemd/system/khajunbgui.service

echo "[*] Reloading systemd..."
sudo systemctl daemon-reload

echo "[✓] Installed."
echo "→ Edit: /etc/khajubridge/console.env"
echo "→ Start: sudo systemctl enable --now khajunbgui"
