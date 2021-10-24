bash part1.sh
if test -f flag_done; then
    rm flag_done
    arch-chroot /mnt /root/KryArch/part2.sh
    source /mnt/root/KryArch/envs.conf
    if [[ $plasma == "true" ]]; then
        arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/KryArch/part3.sh
    else
        bash ~/KryArch/banner.sh
        echo "--------------------------------------------------"
        echo -e " Installiaton has been completed.\n You can remove installiation media now and Reboot.\n Thanks for using KryArch"
        echo "--------------------------------------------------"
    fi
fi

