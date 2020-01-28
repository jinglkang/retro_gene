#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open C,"$ARGV[0]" || die "$!";

open OUT,">$ARGV[2]" || die "$!";


#while (<IN>) {
#	chomp;
#	if (/^\#/) {next;}
#	if (/^\d/) {
#		#1 chr1 77777 78631 chr16 16245 17058 - 60812
#
#		my @tmp=split;
#		print OUT "$tmp[1]\t$tmp[2]\t$tmp[3]\n";
#		
#	}
#}

#13546 chr1 130483151 130486644 chr1 149655805 149659313 + 318020        0       4       3037    3037    1       130486187   130486187
#13546 chr1 130483151 130486644 chr1 149655805 149659313 + 318020        1       1       98      98      1       149655902   149655902


#chr18   3478    4164
#chr18   4327    4921

while (my $c_line=<C>) {
	chomp $c_line;
	my @infor=split /\s+/, $c_line;
	if ($infor[9]==1) {
		next;
	}
	
	my $start=$infor[11]-1;
	my $end=$start+1;
	
	open M,"$ARGV[1]" || die "$!";
		while (<M>) {
			chomp;
			my @tmp=split;
			if ($tmp[0] eq $infor[1]) {
				if ($start>=$tmp[1] && $end<=$tmp[2]) {
					print OUT $c_line,"\n";
					last;
				}
			}
		}
	close M;
}
close C;
exit;
