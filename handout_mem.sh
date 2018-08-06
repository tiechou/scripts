#!/bin/bash
#source /home/admin/shop_engine/dump/conf/main.conf

all_dst_host="search38c.cm3 search39c.cm3 s040001.cm4 s040002.cm4 s060039.cm5 s060040.cm5"
se_conf="/home/admin/memcached"

memcached=`basename ${se_conf}`
receive_path=/home/admin/

for host in $all_dst_host; do
	echo "${host}"
	scp -r "${se_conf}" "${host}:${receive_path}"
	#ssh ${host} ${receive_path}/${memcached}/bin/start.sh
	printf "\n${host} have handout ok\n "
done
