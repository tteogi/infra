#!/bin/bash
file_path=$1
exclude_servers=$2

include_servers=""
for i in $@
do
    if [ "$exclude_servers" != "$i" -a $file_path != $i ]; then
        if [ $include_servers ]; then
            include_servers+=","
        fi
        include_servers+="\"$i\""
    fi
done

sed -i 's/&join_servers&/'$include_servers'/g' $file_path

echo $include_servers