dsk=$(sudo fdisk -l | grep "Disk /dev" | cut -d " " -f 2 | sed -e "s/://")
declare -A disk_array
for disk in $dsk
do
    disk_array[$disk]=1
    echo " * ${disk}"
    disks_list+=(${disk})
done

while true
do
    read -p ">> " selected_disk
    (
    if [[ ${disk_array[$selected_disk]} ]]     
    then 
        echo "exists"
        break
    else
        echo "!! There is no device found named as '${selected_disk}', try again."
    fi
) 2>/dev/null
done

