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
