#!/bin/sh

if ip link show tun0 > /dev/null 2>&1; then
    IP=$(ip addr show tun0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

    if echo "$IP" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
        echo "%{F#8bcc6a} %{F#87CEEB}$IP%{u-}"
    else
        echo "%{F#8bcc6a} %{F#87CEEB}NOIP%{u-}"
    fi
else
    echo "%{F#8bcc6a} %{F#87CEEB}NOIP%{u-}"
fi