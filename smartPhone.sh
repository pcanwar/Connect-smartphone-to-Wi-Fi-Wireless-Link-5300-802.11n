#!/usr/bin/env bash

# Connect a smartPhone to CSI tools
# I only tried on android smartphone
# First log as a root user
echo "log as a root user"
#1- stop and disable network manager
stop  network-manager
echo -n "we must stop and disable network manager\n"
echo -n "-------------------------------------------\n"

#2- step 4th and 5th of CSI website

make -C linux-80211n-csitool-supplementary/netlink

echo  "Bulit the iserspace logging tool\n"
echo  "Read more on the 4th step on the CSI website on the installation instruction section\n"
echo  "-------------------------------------------\n"
sleep 3
sudo pkill airbase-ng
sleep 3
sudo pkill dhcpd
sleep 3
sudo nmcli nm wifi off
sleep 3
sudo rfkill unblock wlan

sudo modprobe -r iwlwifi mac80211
sleep 1
sudo modprobe -r iwldvm iwlwifi mac80211
sleep 1
sudo modprobe iwlwifi connector_log=0x1
sleep 2
echo -n "Enable logging and test\n"
echo -n "Read more on the 5th step on the CSI website on the installation instruction section\n"
echo -n "-------------------------------------------\n"

#3- since the network is down, we need to bring all interfaces up
echo -n "Enter the name of the wifi interface> "
read wlan2
ifconfig $wlan2 up
echo "\n-------------------------------------------\n"
echo -n "Enter the name of the ethernet interface> "
read eth2
ifconfig $eth2 up
sleep 2
echo "\nInterfaces are up\n"
#4-  abca is the wifi hostpot's name in the smartphone.
# to set the essid (network name or domain ID)

echo -n "Enter the name of the network name of the wifi hostpot> "
read abca
iwconfig $wlan2 essid $abca
echo " wait... it is connecting to the hostpot\n"

# sleep 5 sec to a sign an ip address

#5- these steps are on the csi tool website, on the first question of FAQ page.
# how to set wifi data rates ...
sleep 5
outp="$(ls /sys/kernel/debug/ieee80211/phy0/netdev:$wlan2/stations/)"
echo $outp
cat  /sys/kernel/debug/ieee80211/phy0/netdev:$wlan2/stations/$outp/rate_scale_table
sleep 5
echo -n "Enter the rate that you want from the list, Don't including 0x> "
read rateList
echo 0x$rateList | tee /sys/kernel/debug/ieee80211/phy0/netdev:$wlan2/stations/$outp/rate_scale_table


echo  0x$rateList | tee /sys/kernel/debug/ieee80211/phy0/iwlwifi/iwldvm/debug/bcast_tx_rate

echo  0x$rateList | tee /sys/kernel/debug/ieee80211/phy0/iwlwifi/iwldvm/debug/monitor_tx_rate

iwconfig $wlan2 essid $abca
echo  "\n-------------------------------------------\n"
sudo dhclient $wlan2
sleep 7
ifconfig $wlan2
echo "\nif the system doesn't get an ip address, open a new terminal and write ifconfig -a"
sleep 2
echo -n "\nOpen new tirmanl and start ping IP of the smartphone\n"
echo  "\n-------------------------------------------\n"
echo -n "\nEnter your csi data file's name including .dat> "
read idata
linux-80211n-csitool-supplementary/netlink/log_to_file $idata
