#!/bin/bash
#      __            __   __       
#|__/ |__) \ /  /\  |__) /  ` |__| 
#|  \ |  \  |  /~~\ |  \ \__, |  | 
#
#Author:Burak Baris
#Website:krygeNNN.github.io

clear
echo  "-------------------------------------------------------------------------------"
echo  " * Welcome to KryArch, archlinux installiation script, press any key to start."
echo  " #-> SECTION-1 <-# Disk Partitioning and Installing the linux kernel."
echo  "-------------------------------------------------------------------------------"
read anykey

clear
echo  "----------------------"
echo  " Updating the mirrors."
echo  "----------------------"
./spinner.sh
(
country=$(curl ifconfig.co/country-iso)
timedatectl set-ntp true
pacman -S --noconfirm pacman-contrib reflector rsync
rm /etc/pacman.d/mirrorlist
#Updating mirror list
reflector -c ${country} -l 5 --sort rate --save /etc/pacman.d/mirrorlist
) 2>/dev/null 1>&2
kill $(cat /tmp/running) 

clear
echo  "------------------------------------------------------------------"
echo -e " * Choose a disk to proceed with partitioning (example /dev/sda).\n -- Warning !The disk you choose will be wiped out, choose carefully."
echo -e "------------------------------------------------------------------\n"
fdisk -l
echo ""
read -p ">> " DSK

clear
echo "-----------------------"
echo " Partitioning the disk."
echo "-----------------------"
./spinner.sh
(
#Zapping disk
sgdisk -Z ${DSK}
sgdisk -a 2048 -o ${DSK}

#Partitioning disk size
sgdisk -n 1:1MiB:1000MiB ${DSK}
sgdisk -n 2:0:0 ${DSK}

#Declaring partition type
sgdisk -t 1:ef00 ${DSK}  
sgdisk -t 2:8300 ${DSK}  

#Labeling partitions
sgdisk -c 1:"uefi" ${DSK}
sgdisk -c 2:"root" ${DSK}

#Creating file systems
mkfs.vfat -F32 "${DSK}1"
echo "y" | mkfs.ext4 "${DSK}2"

#Mounting file systems
mount -t ext4 "${DSK}2" /mnt
mkdir -p /mnt/boot/efi
mount -t vfat "${DSK}1" /mnt/boot/efi
) 2>/dev/null 1>&2
kill $(cat /tmp/running) 

clear
#Installing linux the kernel
echo "-----------------------------"
echo " Installing the linux kernel."
echo "-----------------------------"
./spinner.sh
(
pacstrap /mnt base base-devel linux linux-firmware vim nano sudo archlinux-keyring --noconfirm --needed

#Creating fstab
genfstab -U /mnt >> /mnt/etc/fstab
mv ~/kryarch /mnt/root
) 2>/dev/null 1>&2
kill $(cat /tmp/running) 

#Entering arch-chroot environment
clear
echo "----------------------------------------------------------------------------------------------"
echo -e " * Entered to the arch-chroot environment. To proceed with the installiation follow those steps.\n 1 - cd root/kryarch\n 2 - bash kryarch-2.sh"
echo "----------------------------------------------------------------------------------------------"
cd /mnt
arch-chroot /mnt
