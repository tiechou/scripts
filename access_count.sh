#!/bin/bash

while (true); do 
    aaa=`date +"%Y-%m-%d %H:%M:%S" -d " 3 second ago "`;
    grep "$aaa" access_log_se | wc -l;
    echo $aaa;
    sleep 1; 
done
