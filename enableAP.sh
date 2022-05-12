sudo systemctl unmask hostapd > /dev/null 2>&1

sudo systemctl enable hostapd > /dev/null 2>&1

sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.org > /dev/null 2>&1

sudo cp /etc/dhcpcd.conf /PBX/dhcpcd.conf > /dev/null 2>&1

sudo echo "interface wlan0
    static ip_address=172.25.1.1/24
    nohook wpa_supplicant" >> /PBX/dhcpcd.conf

sudo mv /PBX/dhcpcd.conf /etc/dhcpcd.conf > /dev/null 2>&1

echo "# https://www.raspberrypi.org/documentation/configuration/wireless/access-point-routed.md
# Enable IPv4 routing
net.ipv4.ip_forward=1" > /PBX/routed-ap.conf

sudo chown root:root /PBX/routed-ap.conf > /dev/null 2>&1

sudo mv /PBX/routed-ap.conf /etc/sysctl.d/routed-ap.conf > /dev/null 2>&1

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE > /dev/null 2>&1

sudo netfilter-persistent save > /dev/null 2>&1

sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.org > /dev/null 2>&1

sudo cp /etc/dnsmasq.conf /PBX/dnsmasq.conf > /dev/null 2>&1

echo "interface=wlan0 # Listening interface
dhcp-range=172.25.1.2,172.25.1.20,255.255.255.0,24h
                # Pool of IP addresses served via DHCP
domain=wlan     # Local wireless DNS domain
address=/gw.wlan/172.25.1.1
                # Alias for this router" >> /PBX/dnsmasq.conf

sudo mv /PBX/dnsmasq.conf /etc/dnsmasq.conf > /dev/null 2>&1

sudo rfkill unblock wlan > /dev/null 2>&1

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

sudo chown root:root /PBX/hostapd.conf > /dev/null 2>&1

sudo mv /PBX/hostapd.conf /etc/hostapd/hostapd.conf > /dev/null 2>&1

echo "Access Point mode in Action
===========================

SSID        : bizstima
Passphrase  : bizstima123
Gateway IP  : 172.25.1.1
DHCP Range  : 172.25.1.2 - 172.25.1.20
Subnet Mask : 255.255.255.0
" > /PBX/status.out

sudo mv /etc/network/interfaces /etc/network/interfaces.org > /dev/null 2>&1

sudo mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.org > /dev/null 2>&1

clear

echo "The PBX Will reboot after 15 seconds in the Access Point mode with below details"

echo ""

more /PBX/status.out

sleep 15

sudo systemctl reboot

