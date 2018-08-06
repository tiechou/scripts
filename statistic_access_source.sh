#!/bin/awk -f
BEGIN{
	count[0]=0;
	num=0;
}{
	for(idx=0;(idx<num)&& ($1!=mcn[idx]);idx++)
	;
	if($1==mcn[idx])
	{
		count[idx]++;
	}else{
		num++;
		mcn[idx]=$1;
		count[idx]=1;
	}	
}END{
	for(i=0;i<num;i++)
	{
		print "\t",mcn[i]," = ",count[i],"\n";		
	}
}
