#!/bin/bash

clear

echo ""
echo "Welcome to BIZStima PBX IP Control Center"
echo "========================================="
echo "Select your choice to proceed ....."
echo ""
echo "1 : To query the present mode"
echo "2 : To configure PBX in Access Point Mode"
echo "3 : To configure PBX in Normal Operation Mode"
echo ""
echo "Press CRTL+C to exit the program"
echo ""
read -p 'Enter your Option : ' option





if [[ $option -eq 1 ]]
then
clear
more /PBX/status.out
echo ""
read -p  "press any key to Continue ...." -n1 -s
pbxctl
fi






if [[ $option -eq 2 ]]
then
clear
echo ""
line=$(head -n 1 /PBX/status.out)
if [[ $line ==  "Access Point mode in Action" ]]
then
echo "The PBX is already in the Access Point Mode "
echo "Query the present mode for more information"
echo ""
else
read -p 'Confirm the execution by entering YES to convert into Access Point Mode : ' yes
if [[ $yes == "YES" ]]
then
clear
echo "Conversion into Access Point Mode will begin shortly ..............."
sleep 5
clear
sudo sh /etc/enableAP.sh
else
clear 
echo "You have not confirmed the conversion. Exiting to Main Menu"
echo ""
read -p  "press any key to Continue ...." -n1 -s
pbxctl
fi
fi
read -p  "press any key to Continue ...." -n1 -s
pbxctl
fi





if [[ $option -eq 3 ]]
then
clear
echo ""
line=$(head -n 1 /PBX/status.out)

if ([[ $line ==  "Normal Operation Mode via WiFi in Action" ]] || [[ $line ==  "Normal Operation Mode via LAN in Action" ]])
then

if [[ $line ==  "Normal Operation Mode via WiFi in Action" ]]
then
echo "The PBX is already in the Normal Operation Mode via WIFI connectivity"
echo "Query the present mode for more information"
echo ""
else
echo ""
fi

if [[ $line ==  "Normal Operation Mode via LAN in Action" ]]
then
echo "The PBX is already in the Normal Operation Mode via LAN Connectivity "
echo "Query the present mode for more information"
echo ""
else
echo ""
fi

else
echo "Select below options to convert the PBX into normal operational mode"
echo ""
echo "1 : To connect the PBX via WIFI"
echo "2 : To connect the PBX via LAN"
echo ""
read -p 'Enter your option to configure PBX : ' ipoption


if [[ $ipoption -eq 1 ]]
then
clear
echo " Provide Configurations for the WIFI Connectivity"
echo " ================================================"
echo ""

read -p 'Enter your SSID : ' ssid
read -p 'Enter your Network Password : ' password
read -p 'Enter the preferred IP adress for the PBX : ' ipaddress
read -p 'Enter the the Sub Net Mask : ' subnetmask
read -p 'Enter the Gateway IP of the Router : ' gatewayip
echo ""
read -p 'Confirm the execution by entering YES to Continue with above data : ' yes

if [[ $yes == "YES" ]]
then
clear
echo "Conversion into WIFI Connected Mode will begin shortly ..............."
sleep 5
clear
sudo rm /PBX/interfaces > /dev/null 2>&1
echo "auto wlan0" > /PBX/interfaces
echo "allow-hotplug wlan0" >> /PBX/interfaces
echo "iface wlan0 inet static" >> /PBX/interfaces
echo "address $ipaddress" >> /PBX/interfaces
echo "netmask $subnetmask" >> /PBX/interfaces
echo "gateway $gatewayip" >> /PBX/interfaces
echo "wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf" >> /PBX/interfaces
sudo chown root:root /PBX/interfaces

sudo rm /PBX/wpa_supplicant.conf > /dev/null 2>&1
echo "network={" > /PBX/wpa_supplicant.conf
echo "ssid=\"$ssid\"" >> /PBX/wpa_supplicant.conf
echo "psk=\"$password\"" >> /PBX/wpa_supplicant.conf
echo "proto=RSN" >> /PBX/wpa_supplicant.conf
echo "key_mgmt=WPA-PSK" >> /PBX/wpa_supplicant.conf
echo "pairwise=CCMP" >> /PBX/wpa_supplicant.conf
echo "auth_alg=OPEN" >> /PBX/wpa_supplicant.conf
echo "}" >> /PBX/wpa_supplicant.conf

sudo chown root:root /PBX/wpa_supplicant.conf

echo "Normal Operation Mode via WiFi in Action" > /PBX/status.out
echo "========================================" >> /PBX/status.out
echo "" >> /PBX/status.out
echo "SSID        : $ssid" >> /PBX/status.out
echo "ID Address  : $ipaddress" >> /PBX/status.out
echo "Subnet Mask : $subnetmask" >> /PBX/status.out
echo "Gateway IP  : $gatewayip" >> /PBX/status.out

sudo sh /etc/enableWIFI.sh
else
clear
echo "You have not confirmed the conversion. Exiting to Main Menu"
read -p  "press any key to Continue ...." -n1 -s
pbxctl
fi
fi



if [[ $ipoption -eq 2 ]]
then
clear
echo " Provide Configurations for the LAN Connectivity"
echo " ==============================================="
echo ""
read -p 'Enter the preferred IP adress for the PBX : ' ipaddress
read -p 'Enter the the Sub Net Mask : ' subnetmask
read -p 'Enter the Gateway IP of the Router : ' gatewayip
echo ""
read -p 'Confirm the execution by entering YES to Continue with above data : ' yes
if [[ $yes == "YES" ]]
then
clear
echo "Conversion into LAN Connected Mode will begin shortly ..............."
sleep 5
clear
sudo rm /PBX/interfaces > /dev/null 2>&1
echo "auto lo" > /PBX/interfaces
echo "iface lo inet loopback" >> /PBX/interfaces
echo "auto eth0" >> /PBX/interfaces
echo "iface eth0 inet static" >> /PBX/interfaces
echo "address $ipaddress" >> /PBX/interfaces
echo "netmask $subnetmask" >> /PBX/interfaces
echo "gateway $gatewayip" >> /PBX/interfaces
sudo chown root:root /PBX/interfaces

echo "Normal Operation Mode via LAN in Action" > /PBX/status.out
echo "========================================" >> /PBX/status.out
echo "" >> /PBX/status.out
echo "ID Address  : $ipaddress" >> /PBX/status.out
echo "Subnet Mask : $subnetmask" >> /PBX/status.out
echo "Gateway IP  : $gatewayip" >> /PBX/status.out

sudo sh /etc/enableLAN.sh
else
clear
echo "You have not confirmed the conversion. Exiting to Main Menu"
read -p  "press any key to Continue ...." -n1 -s
pbxctl
fi
fi





fi
read -p  "press any key to Continue ...." -n1 -s
pbxctl
else
clear
echo "Enter a valid input ......."
echo ""
read -p  "press any key to Continue ...." -n1 -s
pbxctl
fi

