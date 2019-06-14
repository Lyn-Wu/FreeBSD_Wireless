#!/usr/bin/env tcsh

# Check Run-Time Por
if ($uid != 0 ) then
	echo "Cannot Running with non-root user por!"
	echo "You can enter sudo ./config_wifi.sh.Try it again"
	exit 1
endif


# If already configure /boot/loader.conf
set LoadModuleNotice="# Load Wireless Modules"
set ConfigWiFiNotice="# Config WiFi"
set loader_file="test.c"
set etc_rc_file="/etc/rc.conf"
set loader_bak_file="test.c.bak"

if( -e $loader_file ) then
	echo
else
	echo "Warning: /boot/loader.conf is not exsit"
	echo -n "Would you want to build a New File?(N/Y)[default:N]"
	set user_input=$<
	switch($user_input)
		case "n":
		case "N":
			echo "exit"
			exit 0
		case "Y":
		case "y"
			# Process Load Modules
			breaksw
		default:
			echo "Nothing to do"
	endsw
endif

echo "Backup Old loader.conf"
mv $loader_file $loader_bak_file
cat $loader_bak_file > $loader_file
sleep 1

# Find Wireless product
set local_card=`sysctl net.wlan.devices | awk -F "[ 0-9]" '{print $2}'`
switch($local_card)
	case "iwm":
		echo $LoadModuleNotice >> $loader_file
		echo 'if_iwm_load="YES"' >> $loader_file
		echo 'iwm3160fw_load="YES"' >> $loader_file
		echo 'iwm3168fw_load="YES"' >> $loader_file
		echo 'iwm7260fw_load="YES"' >> $loader_file
		echo 'iwm7260Dfw_load="YES"'>> $loader_file
		echo 'iwm7265fw_load="YES"' >> $loader_file
		echo 'iwm7265Dfw_load="YES"'>> $loader_file
		echo 'iwm8000fw_load="YES"' >> $loader_file
		echo 'iwm8265fw_load="YES"' >> $loader_file
		echo " " >> $loader_file
		breaksw
	case "ath":
		echo "# Configure Atheros" >> $loader_file
		echo 'if_ath_load="YES"' >> $loader_file
		echo 'if_wi_load="YES"'	>> $loader_file
		breaksw
	default:
		echo "Unknow wireless card"
		exit 1
endsw

# General Configure
echo $ConfigWiFiNotice 		>> $loader_file
echo 'wlan_scan_ap_load="YES"' 	>> $loader_file
echo 'wlan_scan_sta_load="YES"'	>> $loader_file
echo 'wlan_wep_load="YES"'	>> $loader_file
echo 'wlan_ccmp_load="YES"'	>> $loader_file
echo 'wlan_tkip_load="YES"'	>> $loader_file



