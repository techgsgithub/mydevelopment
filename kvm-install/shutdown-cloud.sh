#!/bin/bash

#title           :KVM Shut
#description     :This script will shutdown all running KVM VMs before the host shutdown/reboot. 
#date            :07-Dec-2016
version=1.1.3


### VARIABLES: ##############################

# This VM will be shut down as the last one.
# It is usefull if you are running one VM as a router and want it to sthutdown as a last one.
# (Leave this field empty if you do not need it)
LASTONE=router

# Timeout before forced stop of the VM
TIMEOUT=30

# Shutdown command
SHUTDOWN="sudo /usr/sbin/shutdown now"

# Reboot command
REBOOT="sudo /usr/bin/systemctl reboot"


### CODE: ####################################

TEMP=`getopt -o rvh --long help,version: -- "$@"`
eval set -- "$TEMP"

###Shutdown function. You can choose and change it fot your favorite shutdown command
shutdown_f(){
	echo " System is shutting down..."
	$SHUTDOWN
}

###Reboot function. You can choose and change it for your favorite reboot command
reboot_f(){
	echo " System is rebooting..."
	$REBOOT
}


shut(){
    if [ -n $LASTONE ]; then VMS=$(virsh --connect qemu:///system list | tail -n +3 | awk '{print $2}' | grep -v $LASTONE ); fi
    if [ -z $LASTONE ]; then VMS=$(virsh --connect qemu:///system list | tail -n +3 | awk '{print $2}'); fi
    if [ -n "$VMS" ]; then
	for ACTIVEVM in $VMS ; do
		COUNT=0
		echo " "
		while [ "$COUNT" -lt "$TIMEOUT" ]; do
			VMSTATE=$(virsh --connect qemu:///system domstate $ACTIVEVM )
			echo -en "\e[0K\r Shutting down the $ACTIVEVM [PROCESSING   ]"
			if [ "$VMSTATE" == "running" ]; then
				virsh --connect qemu:///system shutdown $ACTIVEVM > /dev/null
				sleep 0.5
				echo -en "\033[4D.  ]"
				sleep 0.5
				echo -en "\033[3D. ]"
				sleep 0.5
				echo -en "\033[2D.]"
				sleep 0.5
				COUNT=$(($COUNT+2))	
			else
				echo -e "\e[0K\r Shutting down the $ACTIVEVM [DONE]          "
				COUNT=9999
			fi
		done	
		if [ "$VMSTATE" == "running" ]; then
			virsh --connect qemu:///system destroy $ACTIVEVM > /dev/null
			echo -e "\e[0K\r Shutting down the $ACTIVEVM [FORCED]        "
			sleep 0.5
		fi
	done
    fi
    lastone
    echo ""
    echo " .:[ ALL VMs ARE DOWN ]:. "
    sleep 1
    echo ""
    if [ "$REB" == 1 ]; then reboot_f ; fi
    if [ "$REB" == 0 ]; then shutdown_f ; fi
    exit 0
}

lastone() {
	if [ -n $LASTONE ]; then
                COUNT=0
                echo " "
                while [ "$COUNT" -lt "$TIMEOUT" ]; do
			VMSTATE=$(virsh --connect qemu:///system domstate $LASTONE )
                        echo -en "\e[0K\r Shutting down the $LASTONE [PROCESSING   ]"
                        if [ "$VMSTATE" == "running" ]; then
                                virsh --connect qemu:///system shutdown $LASTONE > /dev/null
                                sleep 0.5
                                echo -en "\033[4D.  ]"
                                sleep 0.5
                                echo -en "\033[3D. ]"
                                sleep 0.5
                                echo -en "\033[2D.]"
                                sleep 0.5
                                COUNT=$(($COUNT+2))
                        else
                                echo -e "\e[0K\r Shutting down the $LASTONE [DONE]          "
                                COUNT=9999
                        fi
                done
                if [ "$VMSTATE" == "running" ]; then
                        virsh --connect qemu:///system destroy $LASTONE > /dev/null
                        echo -e "\e[0K\r Shutting down the $LASTONE [FORCED]        "
			sleep 0.5
                fi

	fi
}

help() {
        echo ""
        echo "KVM Shut $version"
        echo ""
        echo "This script may be used to shutdown all running KVM VMs before the host goes down."
        echo "Once all the VMs are off, host will be shutdown or rebooted."
        echo ""
        echo "USAGE: shut [OPTIONS...]"
        echo ""
        echo "OPTIONS:"
        echo "    If there is no option provided, system will be shutdown "
        echo ""
        echo "-r		Shutdown the VMs and reboot the host."
        echo "-v, --version	Show KVM Shut version"
        echo "-h, --help	This Help page"
        echo ""
        exit 0
}

ver() {
        echo "KVM Shut $version"
        echo "Author: Michal Muransky"
        exit 0
}


REB=0
while true ; do
    case "$1" in
        -v|--version)
            ver
            ;;
        -r)
            REB=1
	    shut
            ;;
        -h|--help)
            help
            ;;
        --) shut ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done
