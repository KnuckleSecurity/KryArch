#!/bin/bash
#      __            __   __       
#|__/ |__) \ /  /\  |__) /  ` |__| 
#|  \ |  \  |  /~~\ |  \ \__, |  | 
#
#Author:Burak Baris
#Website:krygeNNN.github.io
(
pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable NetworkManager

clear
echo "Create a password for root: "
passwd root
clear
echo "Declare a Hostname"
read -p ">> " hostname
pacman -S --noconfirm pacman-contrib curl reflector rsync

country=$(curl ifconfig.co/country-iso)
reflector -a 48 -c ${country} -l 20 --sort rate --save /etc/pacman.d/mirrorlist

cores=$(grep -c ^processor /proc/cpuinfo)
sudo sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=-j${cores}/g" /etc/makepkg.conf 
sudo sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T ${cores} -z -)/g" /etc/makepkg.conf
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 3/' /etc/pacman.conf
sed -i '/#\[multilib\]/s/^#//' /etc/pacman.conf
sed -i '/\[multilib\]/{n;s/^#//;}' /etc/pacman.conf
pacman -Sy --noconfirm

locale-gen
hwclock --systohc
timedatectl --no-ask-password set-timezone GB
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-keymap us
hostnamectl --no-ask-password set-hostname $hostname
echo "127.0.0.1     localhost" > /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     $hostname.localdomain $hostname" >> /etc/hosts
echo "$hostname" > /etc/hostname

clear
echo "Create a user"
read -p ">> " username
useradd -m -g users -G wheel -s /bin/bash $username 
clear
echo ">> Create a password for user $username: "
passwd $username

) | tee arch2-logs.txt
