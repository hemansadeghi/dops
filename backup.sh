#!/bin/bash
# Multi-source backup script with logging + syslog
# Usage: ./backup.sh <dest_dir> <source_dir1> <source_dir2> ...

DEST_DIR="$1"
shift  # remove first argument (destination)
LOG_FILE="/var/log/mini-devops-backup.log"
SYSLOG_TAG="mini-devops-backup"

# logging function (file + syslog)
log_msg() {
  local MSG="$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') $MSG" | tee -a "$LOG_FILE"
  logger -t "$SYSLOG_TAG" "$MSG"
}

# input validation
if [ -z "$DEST_DIR" ] || [ $# -eq 0 ]; then
  log_msg "❌ Usage: $0 <dest_dir> <source_dir1> <source_dir2> ..."
  exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
  log_msg "❌ Error: Destination directory $DEST_DIR does not exist!"
  exit 1
fi

# backup filename
DEST="$DEST_DIR/backup-$(date +%Y%m%d%H%M%S).tar.gz"

log_msg "📦 Starting backup of: $@"

# run backup
tar -czf "$DEST" "$@" 2>>"$LOG_FILE"

if [ $? -eq 0 ]; then
  log_msg "✅ Backup created at: $DEST"
else
  log_msg "❌ Backup failed!"
fi
