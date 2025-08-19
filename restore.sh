#!/bin/bash
# Restore backup script with logging + syslog
# Usage: ./restore.sh <backup_file> <restore_dir>

BACKUP_FILE="$1"
RESTORE_DIR="$2"
LOG_FILE="/var/log/mini-devops-backup.log"
SYSLOG_TAG="mini-devops-restore"

# logging function (file + syslog)
log_msg() {
  local MSG="$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') $MSG" | tee -a "$LOG_FILE"
  logger -t "$SYSLOG_TAG" "$MSG"
}

# input validation
if [ -z "$BACKUP_FILE" ] || [ -z "$RESTORE_DIR" ]; then
  log_msg "❌ Usage: $0 <backup_file> <restore_dir>"
  exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
  log_msg "❌ Error: Backup file $BACKUP_FILE does not exist!"
  exit 1
fi

if [ ! -d "$RESTORE_DIR" ]; then
  log_msg "❌ Error: Restore directory $RESTORE_DIR does not exist!"
  exit 1
fi

log_msg "📦 Starting restore of $BACKUP_FILE into $RESTORE_DIR"

# extract backup
tar -xzf "$BACKUP_FILE" -C "$RESTORE_DIR" 2>>"$LOG_FILE"

if [ $? -eq 0 ]; then
  log_msg "✅ Restore completed successfully into: $RESTORE_DIR"
else
  log_msg "❌ Restore failed!"
fi
