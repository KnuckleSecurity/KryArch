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

read -p "Enter Hostname:" hostname
echo "Create a password for root: "
passwd root
pacman -S --noconfirm pacman-contrib curl reflector rsync

country=$(curl ifconfig.co/country-iso)
reflector -a 48 -c ${country} -l 20 --sort score --save /etc/pacman.d/mirrorlist

cores=$(grep -c ^processor /proc/cpuinfo)
sudo sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=-j${nc}/g" /etc/makepkg.conf 
sudo sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T ${nc} -z -)/g" /etc/makepkg.conf
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
hwclock --systohc
timedatectl --no-ask-password set-timezone GB
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-keymap us
hostnamectl --no-ask-password set-hostname $hostname
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParrallellDownloads = 3/' /etc/pacman.conf
sed -i '/#\[multilib\]/s/^#//' /etc/pacman.conf
sed -i '/\[multilib\]/{n;s/^#//;}' /etc/pacman.conf
pacman -Sy --no-confirm

echo "127.0.0.1     localhost" > /etc/hosts
echo "::1     localhost" >> /etc/hosts
echo "127.0.1.1     $(hostname).localdomain $(hostname)" >> /etc/hosts
echo "$(hostname)" > /etc/hostname

read -p "Enter Username: " username
useradd -m -g users -G wheel -s /bin/bash $username 
echo "Create a password for user $(username): "
passwd $username
su $username 
echo "Running as $(username)."

) | tee arch2-logs.txt
