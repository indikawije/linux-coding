#!/bin/bash

sleep 30

line=$(head -n 1 /PBX/reset_status.txt)

if [[ $line ==  "NW Reset Started" ]]
then
echo "N/A" > /PBX/reset_status.txt
sudo sh /etc/enableAP.sh
fi

