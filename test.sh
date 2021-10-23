DSK="/dev/nvme0n1"

if [[ ${DSK} =~ "nvme" ]]; then
    echo "nvme"
else
    echo "notnvme"
fi
