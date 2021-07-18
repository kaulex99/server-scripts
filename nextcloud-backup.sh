#!/bin/bash

user=$(whoami)
nextcloud_file_dir=""
nextcloud_data_dir=""
nextcloud_db=""
nextcloud_db_user=""
nextcloud_db_password=""
backup_destination_dir="/tmp/backup"

RED='\033[0;31m'
# Check if all

echo "${RED}test"
echo "test1"
exit 0;

# Enable nextcloud maintenance mode
if cd nextcloud_file_dir && sudo -u www-data php occ maintenance:mode --on; then
  echo "Enabled nextcloud maintenance mode"
else
  echo "Failed enabling nextcloud maintenance mode"
  exit 1
fi

# Create backup destination
if [ ! -d $backup_destination_dir ]; then
  mkdir -p $backup_destination_dir
fi

# Do backup
echo "Starting nextcloud file directory backup"
tar -cpzf /tmp/backup/NextcloudBackup_FileDir_`date +"%Y%m%d-%H-%M-%S"`.tar.gz -C "$nextcloud_file_dir" .
echo "Finished nextcloud file directory backup"

echo "Starting nextcloud data directory backup"
tar -cpzf /tmp/backup/NextcloudBackup_DataDir_`date +"%Y%m%d"`.tar.gz -C "$nextcloud_data_dir" .
echo "Finished nextcloud data directory backup"

echo "Starting nextcloud db backup"
mysqldump --single-transaction -h localhost -u "$nextcloud_db_user" -p "$nextcloud_db_password" "$nextcloud_db" > /tmp/backup/NextcloudBackup_DB_`date +"%Y%m%d"`.sql
echo "Finished nextcloud db backup"


# Disable nextcloud maintenance mode
if cd nextcloud_file_dir && sudo -u www-data php occ maintenance:mode --off; then
  echo "Disabled nextcloud maintenance mode"
else
  echo "Failed disabling nextcloud maintenance mode, you have to check if it still enabled!"
  exit 1
fi


echo "Finished backup for Nextcloud"
echo "You can find you backups in: $backup_destination_dir"
exit 0