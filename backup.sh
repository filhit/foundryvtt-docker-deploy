#!/bin/bash
set -e
scriptdir=`dirname "$BASH_SOURCE"`
echo "Starting foundry backup"
echo "Rotating local backups"
/usr/sbin/logrotate -f -s $scriptdir/logrotate.state $scriptdir/logrotate.conf
echo "Backing up to file"
tar --directory=$scriptdir/ --exclude-tag-under=_PUT_YOUR_MAP_FOLDERS_IN_HERE.txt -c data | gzip > $scriptdir/foundry-data.tar.gz
if [ "$1" == "--no-remote" ]; then
  echo "Skipping remote backup"
else
  echo "Backing up to aws s3"
  aws s3 cp $scriptdir/foundry-data.tar.gz s3://filhit-foundry-backups/foundry-data.tar.gz --no-progress
fi
echo "Backing up foundry finished"
