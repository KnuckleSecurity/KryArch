#!/bin/bash
#      __            __   __       
#|__/ |__) \ /  /\  |__) /  ` |__| 
#|  \ |  \  |  /~~\ |  \ \__, |  | 
#
#Author:Burak Baris
#Website:krygeNNN.github.io


(
country=$(curl ifconfig.co/country-iso)
timedatectl set-ntp true
pacman -S --noconfirm pacman-contrib reflector rsync
rm /etc/pacman.d/mirrorlist
reflector -a 48 -c ${country} -l 20 --sort rate --save /etc/pacman.d/mirrorlist

DISK="/dev/sda"
sgdisk -Z ${DISK}
sgdisk -a 2048 -o ${DISK}

sgdisk -n 1:1MiB:1000MiB ${DISK}
sgdisk -n 2:0:0 ${DISK}

sgdisk -t 1:ef00 ${DISK}  
sgdisk -t 2:8300 ${DISK}  

sgdisk -c 1:"uefi" ${DISK}
sgdisk -c 2:"root" ${DISK}

mkfs.vfat -F32 "${DISK}1"
echo "y" | mkfs.ext4 "${DISK}2"

mount -t ext4 "${DISK}2" /mnt
mkdir -p /mnt/boot/efi
mount -t vfat "${DISK}1" /mnt/boot/efi

pacstrap /mnt base base-devel linux linux-firmware vim nano sudo archlinux-keyring --noconfirm --needed

echo "Do you want to create a swap partition ?"
read -p ">> " SWP

case $SWP in
    1|y|Y|Yes|YES|yes)
        echo "Declare the swap partition size. Minimum 512MB, Maximum 8GB Recommended."
        read -p "Enter as MegaBytes >> "
        dd if=/dev/zero of=/swapfile bs=1M count=$SWP status=progress 
        chmod 600 /swapfile
        mkswap /swapfile
        spawon -a
        ;;
    2|n|N|No|NO|no)
        echo "Skipping creating swap..."
        ;;
esac
genfstab -U /mnt >> /mnt/etc/fstab
) | tee kryarch1-logs.txt
mv ~/kryarch /mnt/root
arch-chroot /mnt
