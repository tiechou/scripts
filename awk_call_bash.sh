#!/bin/bash
shell_func()
{
   echo "Function $FUNCNAME call with arguments \"$*\"."
}
var="this is test";
echo $var;
export -f shell_func;
shell_func heihei
awk '
function my_function( message )
{
	print " awk function my_function called, argument:" message;
}
BEGIN{
	print "'"$var"'";
	print " Calling my_function from BEGIN block.";
	my_function( " Hello there." );
	system("shell_func from shell");
	if ((getline d< "p.sh")>0)
		{print d;}
}'
   
