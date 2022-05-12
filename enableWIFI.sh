sudo mv /PBX/interfaces /etc/network/interfaces > /dev/null 2>&1

sudo mv /PBX/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null 2>&1

sudo rm /etc/hostapd/hostapd.conf > /dev/null 2>&1
 
sudo mv /etc/dnsmasq.conf.org /etc/dnsmasq.conf > /dev/null 2>&1

sudo iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE > /dev/null 2>&1

sudo netfilter-persistent save > /dev/null 2>&1

sudo rm /etc/sysctl.d/routed-ap.conf > /dev/null 2>&1

sudo mv /etc/dhcpcd.conf.org /etc/dhcpcd.conf > /dev/null 2>&1

sudo systemctl disable hostapd > /dev/null 2>&1

sudo systemctl mask hostapd > /dev/null 2>&1

clear

echo "The PBX Will reboot after 15 seconds in the WIFI connected mode with below details"

echo ""

more /PBX/status.out

sleep 15

sudo systemctl reboot
