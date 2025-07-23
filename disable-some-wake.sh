#! /bin/bash

case $1 in
    pre)
        declare -a devices=(GPP0 GPP8 GPPB GP12 GP13 XHC0 GPP2 I211 PTXH) # <-- Add your entries here

        for device in "${devices[@]}"; do
            if $(grep -qw ^${device}.*enabled /proc/acpi/wakeup); then
                echo ${device} > /proc/acpi/wakeup
            fi
        done
    ;;
esac
