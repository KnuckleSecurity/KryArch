#!/bin/bash
#      __            __   __       
#|__/ |__) \ /  /\  |__) /  ` |__| 
#|  \ |  \  |  /~~\ |  \ \__, |  | 
#
#Author:Burak Baris
#Website:krygeNNN.github.io


bash ~/KryArch/banner.sh
echo "-------------------------------------------------"
echo " * Do you want to create a swap partition - y/N ?"
echo "-------------------------------------------------"
read -p ">> " SWP
case $SWP in
    1|y|Y|Yes|YES|yes)
        echo " * Declare the swap partition size. Minimum 512MB, Maximum 8GB Recommended."
        read -p "Enter as MegaBytes >> " SWPMB
        dd if=/dev/zero of=/swapfile bs=1M count=$SWPMB status=progress 
        chmod 600 /swapfile
        mkswap /swapfile
        echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
        swapon -a
esac

bash ~/KryArch/banner.sh
echo "-------------------------------------------"
echo " Installing and setting up GRUB bootloader. "
echo "-------------------------------------------"
pacman -Sy grub efibootmgr dosfstools os-prober mtools --noconfirm --needed
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

bash ~/KryArch/banner.sh
echo "-------------------------------------------------"
echo " Downloading and configuring networking packages."
echo "-------------------------------------------------"
pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable NetworkManager

bash ~/KryArch/banner.sh
echo "---------------------------------"
echo " Setting package manager configs."
echo "---------------------------------"
pacman -Sy --noconfirm pacman-contrib curl reflector rsync --needed
cores=$(grep -c ^processor /proc/cpuinfo)
sudo sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=-j${cores}/g" /etc/makepkg.conf 
sudo sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T ${cores} -z -)/g" /etc/makepkg.conf
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 3/' /etc/pacman.conf
sed -i '/#\[multilib\]/s/^#//' /etc/pacman.conf
sed -i '/\[multilib\]/{n;s/^#//;}' /etc/pacman.conf
pacman -Sy
#'/\[multilib\]/,/Include/s/^#//'

bash ~/KryArch/banner.sh
echo "------------------------------"
echo " * Create a password for root."
echo "------------------------------"
passwd root

bash ~/KryArch/banner.sh
echo "------------------------"
echo " * Specify the hostname."
echo "------------------------"
sleep 0.1
read -p "Hostname >> " hostname

bash ~/KryArch/banner.sh
echo "-----------------"
echo " * Create a user."
echo "-----------------"
sleep 0.1
read -p "Username >> " username
touch ~/KryArch/envs.conf
echo "username=${username}" > ~/KryArch/envs.conf
useradd -m -g users -G wheel -s /bin/bash $username 

bash ~/KryArch/banner.sh
echo "----------------------------------------"
echo " * Create a password for user $username: "
echo "----------------------------------------"
passwd $username

bash ~/KryArch/banner.sh
echo "-----------------------------------"
echo " Setting locales and host settings."
echo "-----------------------------------"
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

bash ~/KryArch/banner.sh
CPU=$(lscpu | awk '/Vendor ID:/ {print $3}')
case $CPU in

  AuthenticAMD)
    echo "-------------------------------"
    echo -e " * Installing AMD microcode."
    echo "-------------------------------"
    pacman -S amd-ucode --noconfirm 
    ;;

  GenuineIntel)
    echo "---------------------------------"
    echo -e " * Installing INTEL microcode."
    echo "---------------------------------"
    pacman -S intel-ucode --noconfirm
    ;;
esac

bash ~/KryArch/banner.sh
echo "------------------------"
echo -e " * Choose your graphics.\n--------------------------------\n1-AMD Radeon\n2-NVIDIA GeForce\n3-AMD Integrated\n4-Intel Integrated\n5-Virtual Machine\n6-Skip"
echo "------------------------"
sleep 0.1
read -p ">>" GPU
case $GPU in

  1)
    pacman -S mesa xorg-server xf86-video-amdgpu --noconfirm --needed
    ;;
  2)
    pacman -S nvidia nvidia-dkms xorg-server --noconfirm --needed
    ;;
  3)
    pacman -S mesa xorg-server xf86-video-ati --noconfirm 
    ;;
  4)
    pacman -S xorg-server libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
    ;;
  5)
    pacman -S virtualbox-guest-utils xf86-video-vmware xorg-server --noconfirm
    
    bash ~/KryArch/banner.sh
    echo "-----------------------------------"
    echo " * Are you using VirtualBox - y/N ?"
    echo "-----------------------------------"
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


bash ~/KryArch/banner.sh
echo "-----------------------"
echo -e " * Choose your desktop. \n-----------------------\n1-Gnome\n2-Xfce\n3-Plasma\n4-Mate\n5-i3\n6-Awesome\n7-Skip" 
echo "-----------------------"
read desktop

case $desktop in
    1|Gnome|gnome|GNOME)
        pacman -S gnome gnome-tweaks --noconfirm
        systemctl enable gdm
        ;;
    2|Xfce|xfce|XFCE)
        pacman -S xfce4 xfce4-goodies --noconfirm 
        pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm
        systemctl enable lightdm
        ;;
    3|Plasma|plasma|PLASMA)
        pacman -S plasma-meta terminator dolphin --noconfirm 
        pacman -S sddm --needed --noconfirm 
        systemctl enable sddm
        echo "[Theme]" > /etc/sddm.conf
        echo "Current=Nordic" > /etc/sddm.conf
        echo "Plasma=true" >> ~/KryArch/envs.conf
       ;;
    4|Mate|mate|MATE)
        pacman -S mate mate-extra
        pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm
        systemctl enable lightdm
        ;;
    5|i3|I3)
        pacman -S i3 xterm --noconfirm
        pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm
        systemctl enable lightdm
        ;;
    6|Awesome|awesome|AWESOME)
        pacman -S awesome xterm --noconfirm
        pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm
        systemctl enable lightdm
        ;;
    *)
        ;;
esac

cp -r /root/KryArch /home/$username/KryArch
chown $username:users /home/$username/KryArch
