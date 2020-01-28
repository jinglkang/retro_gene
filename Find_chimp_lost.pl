#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open List,"$ARGV[0]" || die"$!";# insertion list

open OUT,">$ARGV[2]" || die"$!";

#113033  114109  1077    1       chain 17408357451 chr1 247249719 + 96118 246871250 chr1 229974691 + 243304 229800167 1


#chr1    35874036        35878827
#chr1    35878935        35884838

while (my $list_line=<List>) {
	chomp $list_line;
	my @infor=split /\s+/,$list_line;
	my $start=$infor[0];
	my $end=$infor[1];
	my $len=$infor[2];
	#print ">>>>>>>>>>\n";
	open Align,"$ARGV[1]" || die"$!"; #ortholog align reigon list
	while (<Align>) {
		chomp;
		my $overlap_size;
		my $overlap_rate;
		my $overlap_rate_2;
		my @infor_2=split;
		#if ($start>=$infor_2[1] && $end <=$infor_2[2]) {
		#	print "$list_line\n";
		#}
	
		
			if ($start>=$infor_2[1] && $end <=$infor_2[2]) {
				$overlap_size=$len;
				$overlap_rate=100;
				$overlap_rate_2=$overlap_size/($infor_2[2]-$infor_2[1]+1)*100;
				print OUT "$start\t$end\t$len\t1\t$overlap_size\t$overlap_rate\t$overlap_rate_2\n";
				last;
			}
			elsif ($start<=$infor_2[1] && $end >=$infor_2[2])
			{
				$overlap_size=$infor_2[2]-$infor_2[1]+1;
				$overlap_rate=$overlap_size/$len*100;
				$overlap_rate_2=$overlap_size/($infor_2[2]-$infor_2[1]+1)*100;
				print OUT "$start\t$end\t$len\t2\t$overlap_size\t$overlap_rate\t$overlap_rate_2\n";				
				last;
			}
			elsif ($end>$infor_2[1] && $end<$infor_2[2] && $start<$infor_2[1])
			{
				$overlap_size=abs($infor_2[1]-$end+1);
				$overlap_rate=$overlap_size/$len*100;
				$overlap_rate_2=$overlap_size/($infor_2[2]-$infor_2[1]+1)*100;
				print OUT "$start\t$end\t$len\t3\t$overlap_size\t$overlap_rate\t$overlap_rate_2\n";
				last;
			}
			elsif($start>$infor_2[1] && $start<$infor_2[2] && $end>$infor_2[2])
			{
				$overlap_size=abs($infor_2[2]-$start+1);
				$overlap_rate=$overlap_size/$len*100;
				$overlap_rate_2=$overlap_size/($infor_2[2]-$infor_2[1]+1)*100;
				print OUT "$start\t$end\t$len\t4\t$overlap_size\t$overlap_rate\t$overlap_rate_2\n";
				last;
			}
		}
	}
	close Align;
