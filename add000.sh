#!/bin/bash

function strLeftPadded()
{
    _str=$1;
    _pad=$2;
    _maxLen=$3

    i=`expr length ${_str}`
    while [ $i -lt ${_maxLen} ];
    do
        let i++
        _str=${_pad}${_str}
    done

    echo ${_str} 
}


for((i = 0; i <= 16; i++))
do
    tableNum=`strLeftPadded ${i} 0 4`
    echo ${tableNum};
done

