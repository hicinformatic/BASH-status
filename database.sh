#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $dir/config/database.config 
jsontmp="$sysuser.json.tmp"
$(cat $dir/json/database.json > $jsontmp)

# UPTIME
uptime=$(ps -u $sysuser -o etimes,cmd | grep "$bind" | awk '{print $1}' | head -n1)
$(sed -i "s/#{UPTIME}#/\"$uptime\"/g" $jsontmp)

# CPU
for c in `ps -u $sysuser -o %cpu --no-headers`
do
    if [ -n "$pscpu" ]
    then
        $(sed -i "s/#{CPU}#/\"$pscpu\",\n        #{CPU}#/g" $jsontmp)
    fi
    pscpu=$c
done
$(sed -i "s/#{CPU}#/\"$pscpu\"/g" $jsontmp)

# MEM
for m in `ps -u $sysuser -o %mem --no-headers`
do
    if [ -n "$psmem" ]
    then
        $(sed -i "s/#{MEM}#/\"$psmem\",\n        #{MEM}#/g" $jsontmp)
    fi
    psmem=$m
done
$(sed -i "s/#{MEM}#/\"$psmem\"/g" $jsontmp)

$(chown $user:$group $jsontmp)
$(chmod $chmod $jsontmp)
$(mv $jsontmp $json)
