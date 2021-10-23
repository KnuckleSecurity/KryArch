#!/bin/bash
#      __            __   __       
#|__/ |__) \ /  /\  |__) /  ` |__| 
#|  \ |  \  |  /~~\ |  \ \__, |  | 
#
#Author:Burak Baris
#Website:krygeNNN.github.io
setfont ter-v20b

bash banner.sh
echo  "----------------------"
echo  " Updating the mirrors."
echo  "----------------------"
country=$(curl ifconfig.co/country-iso)
timedatectl set-ntp true
sed -i 's/#Color/Color/' /etc/pacman.conf
pacman -S --noconfirm pacman-contrib reflector rsync --needed
#Updating mirror list
reflector -c ${country} -l 5 --sort rate --save /etc/pacman.d/mirrorlist

bash banner.sh
echo  "----------------------------------------------------------------------"
echo -e " * Choose a disk to proceed with partitioning (example /dev/sda).\n -- Warning !The disk you choose will be wiped out, choose carefully."
echo -e "----------------------------------------------------------------------\n"
fdisk -l
echo ""
echo  "----------------------------------------------------------------------"

dsk=$(sudo fdisk -l | grep "Disk /dev" | cut -d " " -f 2 | sed -e "s/://")
declare -A disk_array
for disk in $dsk
do
    disk_array[$disk]=1
    echo " * ${disk}"
    disks_list+=(${disk})
done

while true
do
    read -p ">> " DSK
    if [[ ${disk_array[$DSK]} ]]     
    then 
        echo "need to break"
        break
    else
        echo "!! There is no device found named as '${DSK}', try again."
    fi
done

echo "Are you sure you want to proceed? All the data stored in ${DSK} will be erased (Y/N)" 
read -p ">> " erase

if [[ $erase == "Y" ]] || [[ $erase == "y" ]]; then
    bash banner.sh
    echo "-----------------------"
    echo " Partitioning the disk."
    echo "-----------------------"
else
    bash banner.sh
    echo "-----------------------------"
    echo " KryArch has been terminated."
    echo "-----------------------------"
    exit
fi
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
#Mounting file systems
if [[ ${DSK} =~ "nvme" ]]; then
    mkfs.vfat -F32 "${DSK}p1"
    mkfs.ext4 "${DSK}p2"
    mount -t ext4 "${DSK}p2" /mnt
    mkdir -p /mnt/boot/efi
    mount -t vfat "${DSK}p1" /mnt/boot/efi
else
    mkfs.vfat -F32 "${DSK}1"
    mkfs.ext4 "${DSK}2"
    mount -t ext4 "${DSK}2" /mnt
    mkdir -p /mnt/boot/efi
    mount -t vfat "${DSK}1" /mnt/boot/efi
fi


bash banner.sh
#Installing linux the kernel
echo "-----------------------------"
echo " Installing the linux kernel."
echo "-----------------------------"
pacstrap /mnt base base-devel linux linux-firmware vim nano sudo archlinux-keyring --noconfirm --needed

#Creating fstab
genfstab -U /mnt >> /mnt/etc/fstab

#Entering arch-chroot environment
cp -r ~/KryArch /mnt/root/KryArch
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
