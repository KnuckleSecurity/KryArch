#!/bin/bash
#      __            __   __       
#|__/ |__) \ /  /\  |__) /  ` |__| 
#|  \ |  \  |  /~~\ |  \ \__, |  | 
#
#Author:Burak Baris
#Website:krygeNNN.github.io

clear
echo -e "Select your CPU manufacturer\n1-AMD\n2-INTEL\n3-Skip"
read -p ">>" CPU
case $CPU in

  1|AMD|amd|Amd)
    pacman -S amd-ucode  
    ;;

  2|INTEL|intel|Intel)
    pacman -S intel-ucode 
    ;;
  *)
    echo "Skipping..."
    ;;
esac

clear
echo -e "Select your GPU manufacturer\n1-AMD or INTEL\n2-NVIDIA\n3-VM\n4-Skip"
read -p ">>" GPU
case $GPU in

  1|AMD|amd|Amd|Intel|INTEL|intel)
    pacman -S mesa xorg-server 
    ;;

  2|NVIDIA|nvidia|Nvidia)
    pacman -S nvidia xorg-server
    ;;
  3|vm|VM|Vm)
    pacman -S virtualbox-guest-utils xf86-video-vmware xorg-server 
    clear
    echo "Are you using VirtualBox - y/N ?"
    read -p ">> " inpt
    if [[ $inpt == "y" ]]
    then
        systemctl enable vboxservice
    fi
    ;;
  *)
    echo "Skipping..."
    ;;
esac

clear
echo "Do you want to create a swap partition - y/N ?"
read -p ">> " SWP
case $SWP in
    1|y|Y|Yes|YES|yes)
        echo "Declare the swap partition size. Minimum 512MB, Maximum 8GB Recommended."
        read -p "Enter as MegaBytes >> " SWPMB
        dd if=/dev/zero of=/swapfile bs=1M count=$SWPMB status=progress 
        chmod 600 /swapfile
        mkswap /swapfile
        echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
        swapon -a
        free -m
        echo "If you can see swap size corresponds to your input, it has been created successfully."
        ;;
    2|n|N|No|NO|no)
        echo "Skipping creating swap..."
        ;;
esac
