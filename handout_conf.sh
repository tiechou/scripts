#!/bin/bash
source /home/admin/shop_engine/dump/conf/main.conf

se_conf="/home/admin/shop_search/etc/se.conf"
se_conf_build="/home/admin/shop_search/etc/se.conf.build"
searcher_server_cfg="/home/admin/shop_search/etc/searcher_server.cfg"
searcher_sort_xml="/home/admin/shop_search/etc/searcher_sort.xml"
seserver_conf="/home/admin/shop_search/etc/seserver.conf"
FE_conf="/home/admin/shop_search/etc/FE.conf"

receive_path=/home/admin/shop_search/etc/

for host in $all_dst_host; do
	echo "${host}"
	scp -r "${se_conf}" "${host}:${receive_path}"
	scp -r "${se_conf_build}" "${host}:${receive_path}"
	scp -r "${searcher_server_cfg}" "${host}:${receive_path}"
	scp -r "${searcher_sort_xml}" "${host}:${receive_path}"
	scp -r "${seserver_conf}" "${host}:${receive_path}"
	scp -r "${FE_conf}" "${host}:${receive_path}"
	echo "${host} have handout ok "
done
