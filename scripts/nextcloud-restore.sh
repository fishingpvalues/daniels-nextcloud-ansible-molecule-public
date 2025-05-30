#!/bin/bash
set -e
# Nextcloud restore script: safe
# Usage: run as root or via Cockpit

DATA_DIR="/var/nextcloud_data"
BACKUP_DIR="/mnt/fritz-nas/backups"
BORG_REPO="$BACKUP_DIR/borg"

# Stop Nextcloud services
systemctl stop nginx || true
systemctl stop php8.2-fpm || true

# Find latest backup
LATEST=$(borg list "$BORG_REPO" | tail -n1 | awk '{print $1}')
if [ -z "$LATEST" ]; then
  echo "No backup found for restore!"
  exit 1
fi

# Restore
borg extract "$BORG_REPO"::$LATEST
chown -R www-data:www-data "$DATA_DIR"

# Start services
systemctl start php8.2-fpm
systemctl start nginx
