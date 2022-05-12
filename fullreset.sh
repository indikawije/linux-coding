#!/bin/bash

line=$(head -n 1 /PBX/reset_status.txt)

if [[ $line ==  "Full Reset Started" ]]
then
echo "N/A" > /PBX/reset_status.txt
sudo fwconsole backup --restore /var/spool/asterisk/backup/My-backup/20210729-195525-1627568725-15.0.16.75-849187484.tar.gz
sudo sh /etc/enableAP.sh
fi

