#!/bin/bash

if [[ $# -ne 3 ]] ; then
    echo "error : sh fewdocs.sh shop_all_20110321.xml 34 shop_all_20110322"
    exit 
fi


declare -i count=1
#head -n 3 $1 | grep "=" > /dev/null 
#if [[ $? -ne 0 ]] ; then
#    let count=$count+1
#    echo "aa"
#fi

let count=`head -n 300 $1 | awk 'BEGIN{i=0}/=/{i=i+1}/<\/doc>/{exit;}END{print i}'`+2

let count=$count*$2 
head -n $count $1 > $3
