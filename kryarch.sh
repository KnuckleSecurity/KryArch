bash part1.sh
arch-chroot /mnt /root/KryArch/part2.sh
source /mnt/root/KryArch/username.conf
arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/KryArch/part3.sh
