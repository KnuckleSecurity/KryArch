#!/bin/bash

echo "---------------------"
echo -e "Choose your desktop. \n---------------------\n1-Gnome\n2-Xfce\n3-Plasma\n4-Mate\n5-i3\n6-Awesome" 
echo "---------------------"
read desktop

case $desktop in
    1|Gnome|gnome|GNOME)
        pacman -S gnome gnome-tweaks
        systemctl enable gdm
        ;;
    2|Xfce|xfce|XFCE)
        pacman -S xfce4 xfce4-goodies --noconfirm 
        pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm
        systemctl enable lightdm
        ;;
    3|Plasma|plasma|PLASMA)
        pacman -S plasma-meta --noconfirm 
        pacman -S sddm --needed --noconfirm 
        systemctl enable sddm
        ;;
    4|Mate|mate|MATE)
        pacman -S mate mate-extra
        pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm
        systemctl enable lightdm
        ;;
    5|i3|I3)
        pacman i3
        pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm
        systemctl enable lightdm
        ;;
    6|Awesome|awesome|AWESOME)
        pacman -S awesome
        pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm
        systemctl enable lightdm
        ;;
    *)
        echo "else"
        ;;
esac

echo "---------------------"
echo -e "You can reboot now."
echo "---------------------"
