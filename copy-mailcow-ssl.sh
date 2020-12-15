#!/bin/bash

# Check permissions
if [ "$(id -u)" -ne "0" ]; then
  echo "You need to be root"
  exit 1
fi

#copy cert files
cp /etc/letsencrypt/live/DOMAIN/privkey.pem /opt/mailcow-dockerized/data/assets/ssl/key.pem
cp /etc/letsencrypt/live/DOMAIN/cert.pem /opt/mailcow-dockerized/data/assets/ssl/cert.pem

#restart related containers
docker restart $(docker ps -qaf name=postfix-mailcow)
docker restart $(docker ps -qaf name=nginx-mailcow)
docker restart $(docker ps -qaf name=dovecot-mailcow)

#call mailcow check expired script

echo "Finished successfully"
exit 0
