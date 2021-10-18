#!/bin/bash
(
country=$(curl ifconfig.co/country-iso)
timedatectl set-ntp true
pacman -Sy
pacman -S --noconfirm pacman-contrib reflector rsync
rm /etc/pacman.d/mirrorlist/
reflector -a 48 -c ${country} -l 20 --sort score --save /etc/pacman.d/mirrorlist

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
mount -t vfat "${DISK}1" /mnt/boot/

pacstrap /mnt base base-devel linux linux-firmware vim nano sudo archlinux-keyring --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable NetworkManager

passwd root
pacman -S --noconfirm pacman-contrib curl reflector rsync

country=$(curl ifconfig.co/country-iso)
reflector -a 48 -c ${country} -l 20 --sort score --save /etc/pacman.d/mirrorlist

cores=$(grep -c ^processor /proc/cpuinfo)
sudo sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=-j${nc}/g" /etc/makepkg.conf 
sudo sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T ${nc} -z -)/g" /etc/makepkg.conf
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
hwclock --systhoc
timedatectl --no-ask-password set-timezone GB
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_COLLATE="" LC_TIME="en_US.UTF-8"
localectl --no-ask-password set-keymap us
hostnamectl --no-ask-password set-hostname $hostname
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/^#ParallellDownloads/ParrallellDownloads=3/'
sed -i '/#\[multilib\]/s/^#//' /etc/pacman.conf
sed -i '/\[multilib\]/{n;s/^#//;}' /etc/pacman.conf

) | tee logs.txt
