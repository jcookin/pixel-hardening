#!/data/data/com.termux/files/usr/bin/sh

# Prevent android from killing CPU
termux-wake-lock

# Config
BACKUP_PATH="$HOME/storage/shared/Backups"
# http://rook-ceph-rgw-s3-ec-1.rook-ceph.svc:80
## Only accessible via internal DNS server routing
## Note http NO TLS
export RESTIC_REPOSITORY="s3:<S3_BUCKET_URL>"
export RESTIC_PASSWORD="<RESTIC_PASSWORD>"
export AWS_ACCESS_KEY_ID="<BUCKET_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<BUCKET_SECRET_ACCESS_KEY>"
export AWS_REGION="us-east-1"
# Or use "-o s3.bucket-lookup=path" in restic cmd 
export AWS_S3_FORCE_PATH_STYLE=true # Required since dns-based paths not configured

# Run Backup
echo "--- Backup Started at $(date)"

# Run restic
restic backup "$BACKUP_PATH" --tag "pixel9-daily" --compression auto
rc=$?
if [ $rc -ne 0 ];
  then echo "Error running restic backup, exit code: $rc";
  # Send notification to device
  termux-notification --title "Backup Script" --content "Backup failed, review logs" --priority high --action termux-toast
fi

restic forget --keep-daily 7 --prune
rc=$?
if [ $rc -ne 0 ]; then echo "Error pruning old backups, exit code: $rc"; fi

echo "--- Backup complete $(date) ---"

# Release wake lock
termux-wake-unlock
