#!/bin/bash

while getopts "m:l:p:" opt;
do
	case $opt in 
		m ) CACHESZ=$OPTARG;;
		l ) MYIP=$OPTARG;;
		p ) PORT=$OPTARG;;
		? ) echo "start.sh -m cachesz -l myip -p port"
		exit 1;;
	esac    
done
shift $(($OPTIND - 1))
echo "/home/admin/memcached/bin/memcached -d -m $CACHESZ -l $MYIP -p $PORT"
