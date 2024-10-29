#!/bin/sh

if [ -f /tmp/target ]; then
    ip_target=$(awk '{print $1}' /tmp/target)
    name_target=$(awk '{print $2}' /tmp/target)

    if [ "$ip_target" ] && [ "$name_target" ]; then
        echo "%{F#00C8FF}🍪%{F#00C8FF} $ip_target - $name_target"
    elif [ $(wc -w < /tmp/target) -eq 1 ]; then
        echo "%{F#00C8FF}🍪%{F#00C8FF} $ip_target"
    else
        echo "%{F#D32F2F}😱 %{u-}%{F#D32F2F} No target"
    fi
else
    echo "%{F#D32F2F}🍬 %{u-}%{F#D32F2F} No target"
fi
