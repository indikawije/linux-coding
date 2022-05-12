

https://www.raspberrypi.org/documentation/configuration/wireless/access-point-routed.md
=======================================================================================



Pre activities
==============
su - 
sudo apt install hostapd
sudo apt install dnsmasq
sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent

sudo useradd bizstima -p user
sudo mkdir /home/bizstima
sudo chown -R bizstima:bizstima /home/bizstima/
sudo mkdir /PBX
sudo chown -R bizstima:bizstima /PBX
sudo usermod -aG sudo bizstima
echo "
bizstima    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
vi /home/bizstima/.profile
chown bizstima:bizstima /home/bizstima/.profile
echo PATH=$PATH:/PBX >> /home/bizstima/.profile
echo "echo "List of PBX Control Commands for the BIZStima Operation"" >> /home/bizstima/.profile
echo "echo "======================================================="" >> /home/bizstima/.profile
echo "echo "echo pbxctl ------------- For IP Configurations of the PBX"" >> /home/bizstima/.profile
touch /PBX/pbxctl
chown bizstima:bizstima /PBX/pbxctl
chmod 0700 /PBX/pbxctl





Enabling AP Mode
================
sudo systemctl unmask hostapd

sudo systemctl enable hostapd

sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.org

sudo cp /etc/dhcpcd.conf /PBX/dhcpcd.conf

sudo echo "interface wlan0
    static ip_address=172.25.1.1/24
    nohook wpa_supplicant" >> /PBX/dhcpcd.conf

sudo mv /PBX/dhcpcd.conf /etc/dhcpcd.conf

echo "# https://www.raspberrypi.org/documentation/configuration/wireless/access-point-routed.md
# Enable IPv4 routing
net.ipv4.ip_forward=1" > /PBX/routed-ap.conf

sudo chown root:root /PBX/routed-ap.conf

sudo mv /PBX/routed-ap.conf /etc/sysctl.d/routed-ap.conf

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

sudo netfilter-persistent save

sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.org

sudo cp /etc/dnsmasq.conf /PBX/dnsmasq.conf

echo "interface=wlan0 # Listening interface
dhcp-range=172.25.1.2,172.25.1.20,255.255.255.0,24h
                # Pool of IP addresses served via DHCP
domain=wlan     # Local wireless DNS domain
address=/gw.wlan/172.25.1.1
                # Alias for this router" >> /PBX/dnsmasq.conf

sudo mv /PBX/dnsmasq.conf /etc/dnsmasq.conf

sudo rfkill unblock wlan

echo "country_code=GB
interface=wlan0
ssid=bizstima
hw_mode=g
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=bizstima123
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP" > /PBX/hostapd.conf

sudo chown root:root /PBX/hostapd.conf

sudo mv /PBX/hostapd.conf /etc/hostapd/hostapd.conf

echo "Access Point mode in Action
===========================

SSID        : bizstima
Passphrase  : bizstima123
Gateway IP  : 172.25.1.1
DHCP Range  : 172.25.1.2 - 172.25.1.20
Subnet Mask : 255.255.255.0
" > /PBX/status.out

sudo mv /etc/network/interfaces /etc/network/interfaces.org

sudo mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.org

clear

echo "The PBX Will reboot after 15 seconds in the Access Point mode with below details"
echo ""
more /PBX/status.out

sleep 15

sudo systemctl reboot


Disabling Access Point Mode
===========================

sudo mv /PBX/interfaces /etc/network/interfaces

sudo mv /PBX/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf

sudo rm /etc/hostapd/hostapd.conf

sudo mv /etc/dnsmasq.conf.org /etc/dnsmasq.conf 

sudo iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

sudo netfilter-persistent save

sudo rm /etc/sysctl.d/routed-ap.conf

sudo mv /etc/dhcpcd.conf.org /etc/dhcpcd.conf

sudo systemctl disable hostapd

sudo systemctl mask hostapd

clear

echo "All Configurations Comleted and rebooting in 10 Seconds"

sleep 10

sudo systemctl reboot









