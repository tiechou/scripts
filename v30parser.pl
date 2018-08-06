#!/usr/bin/perl
#*************************************************************************
#*  Copyright (c) 2008 www.taobao.com        ALL RIGHTS RESERVED.        *
#*************************************************************************

=head1 NAME

template.pl - command function here

=head1 SYNOPSIS

template.pl [--conf=conf_file] input

template.pl --help|h|?  brief help message

template.pl --man       full documentation

Mail bug reports and suggestions to <guinan@taobao.com>.;

=head1 OPTIONS

=over 8

=item B<-h, --help>

Print a brief help message and exits 1.

=item B<--man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<This program> will read the given input file(s) and do something useful with the contents thereof.


=head1 Author: Nan Zheng (guinan@taobao.com), www.taobao.com, Inc.

=head1 No known bugs

=head1 $Date:$

=head1 $Revision:$

=pod

detailed description here

=cut

# This file can parse both v3.0 and v2.0 iSearch returned format. But as you 
# see, the code is not clean yet.

#use strict;
#use warnings;
#use diagnostics;
use English;
use Getopt::Long;
use Pod::Usage;
#use lib '../perl';

my $PROGNAME = $0;
our $VERSION ='1.0';

my ($opt_help,$opt_man,$opt_conf);
#parse command line options
Getopt::Long::Configure('bundling','auto_version','auto_help');
GetOptions (    "help|h|?"      => \$opt_help,
                "man"           => \$opt_man,
            ) || pod2usage(-verbose=>0);

pod2usage (-verbose => 1) if ($opt_help);
pod2usage (-verbose => 2) if ($opt_man);

#main logic here
#head.version\1
#head.query_status\1
#head.query_time\1
#const\1
#6\1
#const.docs_found\1
#const.docs_search\1
#const.docs_restrict\1
#const.docs_return\1
#const.has_prepage\1
#const.has_nextpage\1

my %result;
while (my $line=<>)
{
	my @segs=split /\x1/,$line;
    # make the dicsion which version is returned.
    my $rev_version=$segs[0];
    if ($rev_version == "V3.0") {
        &parser30(@segs);
    } 
    else {
        # XXX This is not good, but currently just do it.
        &parser20(@segs);
    }
}

sub parser30 {

	my $docs_return=0;
    my @segs=@_;
	my $index=0;

	#head
	$result{'head'}{'version'}=$segs[$index++];
 	$result{'head'}{'query_status'}=$segs[$index++];
 	$result{'head'}{'query_time'}=$segs[$index++];
 	$result{'head'}{'query_time'}= 0;
	if ($result{'head'}{'query_status'} ne "OK")
	{
		next;
        }
	my $name= $segs[$index++];
	if ($name eq "const")#const
	{
		my $len=$segs[$index++];
		$result{'const'}{'docs_found'}=$segs[$index++];
		$result{'const'}{'docs_search'}=$segs[$index++];
		$result{'const'}{'docs_restrict'}=$segs[$index++];
		$docs_return=$segs[$index++];
		$result{'const'}{'docs_return'}=$docs_return;
		$result{'const'}{'has_prepage'}=$segs[$index++];
		$result{'const'}{'has_nextpage'}=$segs[$index++];
	}
	while ($index<@segs)
	{
		$name= $segs[$index++];
		if ($name eq "special")#specialKey
		{
			my $len=$segs[$index++];
			$result{'special'}{'key'}=$segs[$index++];
			$result{'special'}{'category'}=$segs[$index++];
			$result{'special'}{'kind'}=$segs[$index++];
			my $synonyms_count=$segs[$index++];
			my $len_of_relation=$segs[$index++];
			
			$result{'special'}{'synonyms_count'}=$synonyms_count;
			$result{'special'}{'len_of_relation'}=$len_of_relation;
			while ($synonyms_count-- > 0)
			{
				my $seg =$segs[$index++];
				push @{$result{'special'}{'synonyms'}},$seg;
			}
			while ($len_of_relation-- >0)			
			{
				my $seg =$segs[$index++];
				push @{$result{'special'}{'relation'}},$seg;
			}
		}
		elsif($name eq "echo")
		{
			my $len=$segs[$index++];
			$result{'echo'}{'do_echo_key'}=$segs[$index++];
			$result{'echo'}{'echo_keys'}=$segs[$index++];
			my $num_of_comb=$segs[$index++];
			$result{'echo'}{'num_of_comb'}=$num_of_comb;
			while ($num_of_comb-- > 0)
			{
				my $seg =$segs[$index++];
				push @{$result{'echo'}{'combs'}},$seg;
			}

			
		}
		elsif($name eq "stat")
		{
			my $len=$segs[$index++];
			my $stat_infos_num=$segs[$index++];
			$result{'stat'}{'num_of_stat_infos'}=$stat_infos_num;
			my $i=0;
			while ($i<$stat_infos_num)
			{
				my $stat_num =$segs[$index++];
				while ($stat_num -- >0)
				{
					my $seg = $segs[$index++];
					push @{$result{'stat'}{'stat_infos'}[$i]},$seg;
				}
				$i++;
			}
		}
		elsif($name eq "data")
		{
			my $len=$segs[$index++];
			my $field_count=$segs[$index++];
			$result{'data'}{'field_count'}=$field_count;
			my $i=0;
			while ($i++<$field_count)
			{
				my $field_name =$segs[$index++];
				push @{$result{'data'}{'field_name'}},$field_name;
			}
			$i=0;
			while ($i<$docs_return)
			{
				my $j=0;
				while($j++<$field_count)
				{
					push @{$result{'data'}{'docs'}[$i]},$segs[$index++];
				}
				$i++;
			}
		}
		else
		{
			next if ($name eq '');
		}
	}
 
    &print_result(\%result);
}

sub print_result
{
	my $ref=shift;
	my %result=%$ref;
	print "Version:".$result{'head'}{'version'}."\n"."QueryStatus:".$result{'head'}{'query_status'}."\n"."QueryTime:".$result{'head'}{'query_time'}."\n";
	if (defined $result{'const'})
	{
		print "DocsFound: ".$result{'const'}{'docs_found'}."\n"."DocsSearch:".$result{'const'}{'docs_search'}."\n"."DocsRestrict:".$result{'const'}{'docs_restrict'}."\n"."DocsReturn:".$result{'const'}{'docs_return'}."\n";
		print "HasPrepage: ".$result{'const'}{'has_prepage'}."\n"."HasNextPage: ".$result{'const'}{'has_nextpage'}."\n";
	}
	if (defined $result{'special'})
	{
		print "Key:".$result{'special'}{'key'}."\tCategory:".$result{'special'}{'category'}."\tKind:".$result{'special'}{'kind'}."\n";
		print $result{'special'}{'synonyms_count'}." Synonyms:";
		foreach my $sym (@{$result{'special'}{'synonyms'}})
		{
			print "\t".$sym;
		}
		print "\n";
		print $result{'special'}{'len_of_relation'}." Relations:";
		foreach my $sym (@{$result{'special'}{'relations'}})
		{
			print "\t".$sym;
		}
		print "\n";
	}
	if (defined $result{'echo'})
	{
		print "DoEchoKey:".$result{'echo'}{'do_echo_key'}."\tEchoKeys:".$result{'echo'}{'echo_keys'}."\n";
		print $result{'echo'}{'num_of_comb'}." Combinations:";
		foreach my $com (@{$result{'echo'}{'combs'}})
		{
			print "\t".$com;
		}
		print "\n";
	}
	if (defined $result{'stat'})
	{
		print $result{'stat'}{'num_of_stat_infos'}." Stats:\n";
		foreach my $stat_info (@{$result{'stat'}{'stat_infos'}})
		{
			foreach my $stat (@{$stat_info})
			{
				print $stat."\t";
			}
			print "\n\n";
		}

	}
	if (defined $result{'data'})
	{
		my $doc_num=@{$result{'data'}{'docs'}};
		print $doc_num." Docs\n";
		print "Field Names:\n";
		foreach my $field_name (@{$result{'data'}{'field_name'}})
		{
			print "\t".$field_name."\n";
		}
		print "\n";
		my $index=1;
		foreach my $doc (@{$result{'data'}{'docs'}})
		{
			print "Doc $index:\n";
			$index++;
			my $j=0;
			foreach my $field (@{$doc})
			{
				unless (defined $field)
				{
					if($result{'data'}{'field_name'}[$j] ne "online_status"){
						print "\t$result{'data'}{'field_name'}[$j]:\tNULL\n";
					}
				}
				else
				{
					if($result{'data'}{'field_name'}[$j] ne "online_status"){
						print "\t$result{'data'}{'field_name'}[$j]:\t".$field."\n";
					}
				}
				$j++;
			}
			print "\n";
		}
	}
}

sub parser20 {
    
    my @segs=@_;
    my $docs_return=0;
    my $index=0;
    $result{'version'}=substr($segs[$index++], 12);
    my $docs_found=$segs[$index++];
    if ($docs_found==-1)#error
    {
        $result{'type'}='error';
    }
    elsif ($docs_found==0) # empty result
    {
        $result{'type'}='empty';
        $result{'docsFound'}=$docs_found;
        $result{'docsSearch'}=$segs[$index++];
        $index+=4;
        my $num=$segs[$index++];
        $num=$num+1-1;
        $result{'specialKey'}{'iLenOfRelation'}=$num;
        for (my $i=0;$i<$num;$i++)
        {
            push @{$result{'specialKey'}{'rKeys'}},$segs[$index++];
        }
        $index+=3;
        $result{'doEchoKeys'}=$segs[$index++];
        $result{'echoKeys'}=$segs[$index++];
        $num=$segs[$index++];
        $num=$num+1-1;
        $result{'comb'}{'iNumOfComb'}=$num;
        for (my $i=0;$i<$num;$i++)
        {
            push @{$result{'comb'}{'value'}},$segs[$index++];
        }
        $result{'searchTime'}=$segs[$index++]+1-1;
    }
    else
    {
        $result{'type'}='ok';
        $result{'docsFound'}=$docs_found;
        $result{'docsSearch'}=$segs[$index++];
        $result{'docsReturn'}=$segs[$index++];
        $result{'hasPrevPage'}=$segs[$index++];
        $result{'hasNextPage'}=$segs[$index++];
        $result{'doEchoKeys'}=$segs[$index++];
        $result{'echoKeys'}=$segs[$index++];
        $result{'fieldnum'}=$segs[$index++];
        $result{'fieldCount'}=$result{'fieldnum'}-5;
        for (my $i=0; $i<$result{'fieldnum'};$i++)
        {
            $result{'fieldname'}[$i]=$segs[$index++];
        }
        for (my $i=0; $i<$result{'docsReturn'};$i++)
        {
            for (my $j=0; $j<$result{'fieldnum'};$j++)
            {
                push @{$result{'docs'}[$i]},$segs[$index++];
            }
        }
        $index+=4;
        my $num=$segs[$index++];
        $num=$num+1-1;
        $result{'specialKey'}{'iLenOfRelation'}=$num;
        for (my $i=0;$i<$num;$i++)
        {
            push @{$result{'specialKey'}{'rKeys'}},$segs[$index++];
        }
        $num=$segs[$index++];
        $num=$num+1-1;
        if ($num==0)
        {
            $result{'statInfos'}{'iNumOfStatInfos'}=$num;
        }
        elsif ($num>0)
        {
            my $i=0;
            while ($segs[$index+1])
            {
                $result{'statInfos'}{'iNumOfStatInfos'}++;
                $result{'statInfos'}{'stat'}[$i]{'num'}=$num;
                for (my $j=0;$j<$num;$j++)
                {
                    push @{$result{'statInfos'}{'stat'}[$i]{'value'}},$segs[$index++];
                    push @{$result{'statInfos'}{'stat'}[$i]{'count'}},$segs[$index++];
                }
                $i++;
            }
        }
#        print "gzhang--------- $index\n";
        $result{'searchTime'}=$segs[$index++]+1-1;
#        print "gzhang---------$result{'searchTime'}";
        
            
    }
    
    &print_result_v2(\%result);
}

sub print_result_v2
{
    my $ref=shift;
    my %result=%$ref;
    if ($result{'type'} eq 'error')
    {
        print "Search error!\n";
    }
    elsif ($result{'type'} eq 'empty')
    {
        print "DocsSearch: $result{'docsSearch'}\n";
        print "DocsFound: $result{'docsFound'}\n";
#        print "SearchTime: $result{'searchTime'}\n";
        print "DoEchoKeys: $result{'doEchoKeys'}\n";
        print "EchoKeys: \"$result{'echoKeys'}\"\n";
        my $num=$result{'specialKey'}{'iLenOfRelation'};
        print "LenOfRelation: $num\n";
        foreach my $value (@{$result{'spcialKey'}{'rKeys'}})
        {
            print "\t$value\n";
        }
        $num=$result{'comb'}{'iNumOfComb'};
        print "NumOfComb:$num \n";
        foreach my $value (@{$result{'comb'}{'value'}})
        {
            print "\t$value\n";
        }
    }
    elsif ($result{'type'} eq 'ok')
    {
        print "DocsSearch: $result{'docsSearch'}\n";
        print "DocsFound: $result{'docsFound'}\n";
        print "DocsReturn: $result{'docsReturn'}\n";
#        print "SearchTime: $result{'searchTime'}\n";
        print "DoEchoKeys: $result{'doEchoKeys'}\n";
        print "EchoKeys: \"$result{'echoKeys'}\"\n";
        print "FieldNum: $result{'fieldnum'}\n";
        my $num=$result{'specialKey'}{'iLenOfRelation'};
        print "LenOfRelation: $num\n";
        foreach my $value (@{$result{'spcialKey'}{'rKeys'}})
        {
            print "\t$value\n";
        }
        for (my $i=0; $i<$result{'docsReturn'};$i++)
        {
            my $num= $i+1;
            print "\nDoc $num:\n";
            for (my $j=0; $j<$result{'fieldnum'};$j++)
            {
                print "\t$result{'fieldname'}[$j]:\t $result{'docs'}[$i][$j]\n";
            }
            
        }
        
        for (my $i=0;$i<$result{'statInfos'}{'iNumOfStatInfos'}; $i++)
        {
            print "Stat $i:\n";
            for (my $j=0; $j<$result{'statInfos'}{'stat'}[$i]{'num'};$j++)
            {
                print "\t$result{'statInfos'}{'stat'}[$i]{'value'}[$j] $result{'statInfos'}{'stat'}[$i]{'count'}[$j]\n";
            }
        }
    }
    else
    {
        print "Bad format!\n";
    }
}

