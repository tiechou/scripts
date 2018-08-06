#!/bin/bash
bash query500.sh | grep "count=" | awk 'BEGIN{FS="\"";idx=0;i=0}
{
	if($4 == "tag_brand"||remark==1)
	{
		remark = 1;
		tag_brand_count = $2;
		if(tag_brand_count>=10)
		{
			if(i<=10)#包括当前的$4代表数量
			{
				i++;
				if(i==11)
				{
					remark = 2;
					i = 0;
				}
				tag[idx] = $4;
				count[idx] = $2;
				idx++;	
			}
		}
		else
		{
			if(i<=tag_brand_count)
			{
				tag[idx] = $4;
				count[idx] = $2;
				idx++;	
				i++;
			}
			else
			{	
				while(i<=10)
				{
					tag[idx] = " ";
					count[idx] = " ";
					idx++;	
					i++;
				}
				remark = 2;
				i = 0;
			}
		}
	}
	if($4 == "main_cat"||remark==2)
	{
		remark = 2;
		tag_brand_count = $2;
		if(tag_brand_count>=10)
		{
			if(i<=10)#包括当前的$4代表数量
			{
				i++;
				if(i==11)
				{
					remark = 3;
					i = 0;
				}
				tag[idx] = $4;
				count[idx] = $2;
				idx++;	
			}
		}
		else
		{
			if(i<=tag_brand_count)
			{
				tag[idx] = $4;
				count[idx] = $2;
				idx++;	
				i++;
			}
			else
			{	
				while(i<=10)
				{
					tag[idx] = " ";
					count[idx] = " ";
					idx++;	
					i++;
				}
				remark = 3;
				i = 0;
			}
		}
	}
	if($4 == "tag_cat"||remark==3)
	{
		remark = 3;
		tag_brand_count = $2;
		if(tag_brand_count>=10)
		{
			if(i<=10)#包括当前的$4代表数量
			{
				i++;
				if(i==11)
				{
					remark = 4;
					i = 0;
				}
				tag[idx] = $4;
				count[idx] = $2;
				idx++;	
			}
		}
		else
		{
			if(i<=tag_brand_count)
			{
				tag[idx] = $4;
				count[idx] = $2;
				idx++;	
				i++;
			}
			else
			{	
				while(i<=10)
				{
					tag[idx] = " ";
					count[idx] = " ";
					idx++;	
					i++;
				}
				remark = 4;
				i = 0;
			}
		}
	}
	if($4 == "tag_prd"||remark==4)
	{
		remark = 4;
		tag_brand_count = $2;
		if(tag_brand_count>=10)
		{
			if(i<=10)#包括当前的$4代表数量
			{
				i++;
				if(i==11)
				{
					remark = 1;
					i = 0;
				}
				tag[idx] = $4;
				count[idx] = $2;
				idx++;	
			}
		}
		else
		{
			if(i<=tag_brand_count)
			{
				tag[idx] = $4;
				count[idx] = $2;
				idx++;	
				i++;
			}
			else
			{	
				while(i<=10)
				{
					tag[idx] = " ";
					count[idx] = " ";
					idx++;	
					i++;
				}
				remark = 1;
				i = 0;
			}
		}
	}
}END{
	i = 0;
	array_count = NR - 2;
	while(i<array_count)
	{
		"cat query.xml"|getline d;
		print d;	
		print "---------tag = tag_brand -----------";
		++i;
		for(idx=0;idx<10;++idx)
		{
			print "tag_brand=",tag[i],"\t\t","count=",count[i];
			++i;
		}
		print "---------tag = main_cat -----------";
		++i;
		for(idx=0;idx<10;++idx)
		{
			print "main_cat=",tag[i],"\t\t","count=",count[i];
			++i;
		}
		print "---------tag = tag_cat -----------";
		++i;
		for(idx=0;idx<10;++idx)
		{
			print "tag_cat=",tag[i],"\t\t","count=",count[i];
			++i;
		}
		print "---------tag = tag_prd -----------";
		++i;
		for(idx=0;idx<10;++idx)
		{
			print "tag_prd=",tag[i],"\t\t","count=",count[i];
			++i;
		}
		print "\n";
	}
}' >./result.xml
