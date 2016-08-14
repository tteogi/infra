#!/bin/bash

RAM=`free -m | grep Mem`
let FREE_RAM=`echo $RAM | cut -f3 -d' '`
let TOTAL_RAM=`echo $RAM | cut -f2 -d' '`
#`let $FREE_RAM/$TOTAL_RAM*100`
RAM_UTILIZATION=`awk -v s1="$FREE_RAM" -v s2="$TOTAL_RAM" 'BEGIN {print s1/s2*100}'`
RAM_UTILIZATION=${RAM_UTILIZATION%.*}

echo "RAM: "$RAM_UTILIZATION"%"

if (( $RAM_UTILIZATION > 75 ));
then
    exit 2
fi

if (( $RAM_UTILIZATION > 50 ));
then
    exit 1
fi

exit 0