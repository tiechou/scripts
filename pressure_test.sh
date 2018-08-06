#!/bin/bash
while
	read url
do	
	S1=`echo $url |sed -re "s/\?q=.*$/?q=/g"`
	S1_r=`echo $url |sed -re "s/^.*\?q=//g"`
	S2=`echo ${S1_r} |sed -re "s/&.*$//g"`
	S2_r=`echo ${S1_r} |sed -re "s/^[^&]+&/\&/g"`

	#echo ">>" $url
	#echo "1:" $S1
	#echo "2:" $S2
	#echo "3:" $S2_r

	UID_add="+OR+%28uid%3A%3A39512%29+OR+%28uid%3A%3A12375520%29+OR+%28uid%3A%3A20718739%29+OR+%28uid%3A%3A194959675%29+OR+%28uid%3A%3A260914755%29"
	url2=`echo $S1"%28"$S2${UID_add}$S2_r`

	echo $url2
done
