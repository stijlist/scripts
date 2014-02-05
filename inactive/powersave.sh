#!/bin/sh


# Place this file in /etc/pm/power.d/ for automatic power state change detection and 
# make it executable (chmod 755). 

# If we want to disable modules, here's a list of ones to unload, space seperated. 
# having e1000e here (below) disables the ethernet controller by removing the module 
# when the computer is running on battery power. remove the module from the list if 
# you don't want this
modlist="e1000e" #uvcvideo

# Bus list for runtime pm. 
buslist="pci i2c" #spi if your system has it 

case "$1" in
    true)

	#all power management suggestions from powertop go here 
	#these settings are applied whilst on battery 

	#enable power management on wlan0
	iwconfig wlan0 power on

	#enable power saving on the intel audio 
	echo Y > /sys/module/snd_hda_intel/parameters/power_save_controller
	echo 1 > /sys/module/snd_hda_intel/parameters/power_save

	#disable wake on lan 
	ethtool -s eth0 wol d

	#set laptop mode 
	echo 5 > /proc/sys/vm/laptop_mode

	#allow a writeback timeout 
	echo 1500 > /proc/sys/vm/dirty_writeback_centisecs

	#enable usb autosuspend
	for i in /sys/bus/usb/devices/*/power/autosuspend; do
		echo 1 > $i
	done

	#enable sata link power management 
	for i in /sys/class/scsi_host/host*/link_power_management_policy; do
		echo min_power > $i
	done

	#enable runtime power management 
	for bus in $buslist; do
		for i in /sys/bus/$bus/devices/*/power/control; do
			echo auto > $i
		done
	done

	#enable the power aware cpu scheduler 
	echo 1 > /sys/devices/system/cpu/sched_mc_power_savings

	#disable the nmi watchdog 
	echo 0 > /proc/sys/kernel/nmi_watchdog

	#finally, disable any modules in the modlist
	for mod in $modlist; do
		grep $mod /proc/modules > /dev/null || continue
		modprobe -r $mod 2>/dev/null
	done 

	#tune biometric api power management 
	echo "auto" > /sys/bus/usb/devices/1-1.3/power/level

;;
    false)
       #Return settings to default on AC power
        echo 0 > /proc/sys/vm/laptop_mode
        echo 500 > /proc/sys/vm/dirty_writeback_centisecs
        echo N > /sys/module/snd_hda_intel/parameters/power_save_controller
        echo 0 > /sys/module/snd_hda_intel/parameters/power_save
        #echo 10 > /sys/devices/virtual/backlight/acpi_video0/brightness
        for i in /sys/bus/usb/devices/*/power/autosuspend; do
            echo 2 > $i
        done
        for i in /sys/class/scsi_host/host*/link_power_management_policy
            do echo max_performance > $i
        done
        for mod in $modlist; do
            if ! lsmod | grep $mod; then
                modprobe $mod 2>/dev/null
            fi
        done
        for bus in $buslist; do
            for i in /sys/bus/$bus/devices/*/power/control; do
                echo on > $i
            done
        done
    ;;
esac

exit 0