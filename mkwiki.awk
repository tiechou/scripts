#!/bin/gawk -f
BEGIN{
    count = 1    
}
/剑豪/{
    print "|-style=\"background:white; color:green\"";
}
/樵隐/{
    print "|-style=\"background:white; color:red\"";
    count += 1;
    print "| " count ". " $0;
    print "|-"
    next; 
}
    {   
    print "| " $0;
    print "|-"
}
