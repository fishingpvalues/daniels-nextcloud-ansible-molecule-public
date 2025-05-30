#!/bin/bash
set -e
# Nextcloud backup script: encrypted, rotated
# Usage: run as root or via systemd/cron

# Load config from environment or Ansible vars
DATA_DIR="/var/nextcloud_data"
BACKUP_DIR="/mnt/fritz-nas/backups"
BORG_REPO="$BACKUP_DIR/borg"
GPG_RECIPIENT="daniel"
KEEP_DAYS=7

# Ensure backup dir exists
mkdir -p "$BACKUP_DIR"

# Export GPG key if needed (assume already imported)
# Initialize Borg repo if needed
if [ ! -d "$BORG_REPO" ]; then
  borg init --encryption=repokey-blake2 "$BORG_REPO"
fi

# Run backup
borg create --stats --compression lz4 \
  "$BORG_REPO"::"nextcloud-$(date +%Y-%m-%d_%H-%M)" "$DATA_DIR"

# Prune old backups
borg prune -v "$BORG_REPO" --keep-daily=$KEEP_DAYS
