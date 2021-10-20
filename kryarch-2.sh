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
echo  " #-> SECTION-2 <-# Installing and configuring arch linux."
echo  "-------------------------------------------------------------------------------"
read anykey
clear

echo "-------------------------------------------------"
echo " Downloading and configuring networking packages."
echo "-------------------------------------------------"
./spinner.sh
(
pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable NetworkManager
) 2>1 1>/dev/null
kill $(cat /tmp/running)
clear

echo "-----------------------------"
echo " * Create a password for root"
echo "-----------------------------"
passwd root
clear

echo "-----------------------"
echo " * Specify the hostname"
echo "-----------------------"
sleep 0.1
read -p ">> " hostname
clear

echo  "----------------------"
echo  " Updating the mirrors."
echo  "----------------------"
./spinner.sh
(
pacman -S --noconfirm pacman-contrib curl reflector rsync
country=$(curl ifconfig.co/country-iso)
reflector -c ${country} -l 5 --sort rate --save /etc/pacman.d/mirrorlist
) 2>1 1>/dev/null
kill $(cat /tmp/running)
clear

echo "---------------------------------"
echo " Setting package manager configs."
echo "---------------------------------"
./spinner.sh
(
cores=$(grep -c ^processor /proc/cpuinfo)
sudo sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=-j${cores}/g" /etc/makepkg.conf 
sudo sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T ${cores} -z -)/g" /etc/makepkg.conf
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 3/' /etc/pacman.conf
sed -i '/#\[multilib\]/s/^#//' /etc/pacman.conf
sed -i '/\[multilib\]/{n;s/^#//;}' /etc/pacman.conf
pacman -Sy --noconfirm
) 2>1 1>/dev/null
kill $(cat /tmp/running)
clear

echo "-----------------------------------"
echo " Setting locales and host settings."
echo "-----------------------------------"
(
locale-gen
hwclock --systohc
timedatectl --no-ask-password set-timezone GB
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-keymap us
hostnamectl --no-ask-password set-hostname $hostname
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
echo "127.0.0.1     localhost" > /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     $hostname.localdomain $hostname" >> /etc/hosts
echo "$hostname" > /etc/hostname
) 2>1 1>/dev/null
kill $(cat /tmp/running)
clear

echo "--------------"
echo " Create a user"
echo "--------------"
sleep 0.1
read -p ">> " username
useradd -m -g users -G wheel -s /bin/bash $username 
clear

echo "---------------------------------------"
echo " Create a password for user $username: "
echo "---------------------------------------"
passwd $username

