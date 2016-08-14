#!/bin/bash
file_path=$1
exclude_servers=$2
my_address=$2

include_servers=""
for i in $@
do
    if [ "$exclude_servers" != "$i" -a $file_path != $i ]; then
    #if [ $file_path != $i ]; then
        if [ $include_servers ]; then
            include_servers+=","
        fi
        include_servers+="\"$i\""
    fi
done

# if [ $include_servers ]; then
#     include_servers+=","
# fi
#include_servers+="\"$my_address\""


sed -i 's/&join_servers&/'$include_servers'/g' $file_path
sed -i 's/&my_address&/'$my_address'/g' $file_path

echo $include_servers