#!/bin/bash
#      __            __   __       
#|__/ |__) \ /  /\  |__) /  ` |__| 
#|  \ |  \  |  /~~\ |  \ \__, |  | 
#
#Author:Burak Baris
#Website:krygeNNN.github.io

clear
echo -e "* Welcome to KryArch, archlinux installiation script, press any key to start."
echo -e "#-> SECTION-1 <-# Disk Partitioning and Installing linux kernel."
read anykey

clear
echo -e "Updating mirrors.\n"
./spinner.sh
(
country=$(curl ifconfig.co/country-iso)
timedatectl set-ntp true
pacman -S --noconfirm pacman-contrib reflector rsync
rm /etc/pacman.d/mirrorlist
#Updating mirror list
reflector -c ${country} -l 5 --sort rate --save /etc/pacman.d/mirrorlist
) 2>1 1>/dev/null
kill $(cat /tmp/running) 

clear
echo -e "* Choose a partition to proceed the insalliation.\n-- Warning !The partition you choose will be wiped out, choose carefully.\n"
fdisk -l
read DSK

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

#Installing linux kernel
pacstrap /mnt base base-devel linux linux-firmware vim nano sudo archlinux-keyring --noconfirm --needed

#Creating fstab
genfstab -U /mnt >> /mnt/etc/fstab

mv ~/kryarch /mnt/root
#Entering arch-chroot environment
arch-chroot /mnt
) 1>2 2>/dev/null
kill $(cat /tmp/running) 
