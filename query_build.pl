#!/usr/bin/perl
while (my $line= <>)
{
	my $str1 = $line;
	my $str1_r = $str1;
	$str1 =~ s/\?q=.*\n$/?q=/m;
	#print "$str1";

	$str1_r =~ s/^.*\?q=//g;
	#print "$str1_r";
	my $str2 = $str1_r; 
	my $str2_r = $str1_r; 
	$str2 =~ s/&.*\n$//g;
	$str2_r =~ s/^[^&]+&/\&/g;

	$UID_add="+OR+%28uid%3A%3A39512%29+OR+%28uid%3A%3A12375520%29+OR+%28uid%3A%3A20718739%29+OR+%28uid%3A%3A194959675%29+OR+%28uid%3A%3A260914755%29";
        print "$str1%28$str2$UID_add$str2_r";
}
