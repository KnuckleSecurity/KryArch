#!/bin/bash
#      __            __   __       
#|__/ |__) \ /  /\  |__) /  ` |__| 
#|  \ |  \  |  /~~\ |  \ \__, |  | 
#
#Author:Burak Baris
#Website:krygeNNN.github.io
echo -e "Select your CPU manufacturer\n1-AMD\n2-INTEL"
read -p ">>" CPU
case $CPU in

  1|AMD|amd|Amd)
    echo -n "amd cpu"
    ;;

  2|INTEL|intel|Intel)
    echo -n "intel cpu"
    ;;
  *)
    echo -n "other"
    ;;
esac

echo -e "Select your GPU manufacturer\n1-AMD\n2-NVIDIA"
read -p ">>" GPU
case $GPU in

  1|AMD|amd|Amd)
    echo -n "amd cpu"
    ;;

  2|NVIDIA|nvidia|Nvidia)
    echo -n ""
    ;;
  *)
    echo -n "other"
    ;;
esac
