# Mini DevOps Tools - Backup & Restore

A simple DevOps utility written in **Bash** for creating and restoring backups.  
It includes two scripts:

- `backup.sh` → Create compressed backups (`tar.gz`) from multiple directories.  
- `restore.sh` → Restore a backup into a given directory.  

All operations are logged both to a **log file** and to **syslog**.

---

## 🚀 Installation

Clone this repository and make the scripts executable:

```bash
git clone https://github.com/your-username/mini-devops-tools.git
cd mini-devops-tools
chmod +x backup.sh restore.sh
```

---

## 📦 Usage: `backup.sh`

### Syntax
```bash
./backup.sh <dest_dir> <source_dir1> <source_dir2> ...
```

- `<dest_dir>` → Directory where backup file will be saved.  
- `<source_dirX>` → One or more source directories to include in the backup.  

### Example
```bash
./backup.sh /home/hemn/backups /etc /var/www /home/hemn/projects
```

This will create a backup file like:
```
/home/hemn/backups/backup-20250819124533.tar.gz
```

---

## 🔄 Usage: `restore.sh`

### Syntax
```bash
./restore.sh <backup_file> <restore_dir>
```

- `<backup_file>` → Path to the backup file (`.tar.gz`).  
- `<restore_dir>` → Directory where the backup will be extracted.  

### Example
```bash
./restore.sh /home/hemn/backups/backup-20250819124533.tar.gz /tmp/restore-test
```

This will extract all files from the backup into `/tmp/restore-test`.

---

## 📊 Logging

Both scripts log events into:

- File log:  
  ```
  /var/log/mini-devops-backup.log
  ```

- Syslog (can be viewed with `journalctl`):  
  ```bash
  journalctl -t mini-devops-backup
  journalctl -t mini-devops-restore
  ```

### Example log output
```
2025-08-19 12:45:33 📦 Starting backup of: /etc /var/www
2025-08-19 12:45:35 ✅ Backup created at: /home/hemn/backups/backup-20250819124533.tar.gz
```

---

## ⚡ Notes
- Run with a user that has read access to the source directories and write access to the destination directory.  
- Backups are compressed with `tar.gz`.  
- Works on any Linux distribution with `tar` and `systemd` (for syslog).  

---

## 🛠️ Future Improvements
- Auto-clean old backups (rotation).  
- Systemd service & timer for automated daily backups.  
- Remote backup (e.g. rsync to another server or cloud storage).
