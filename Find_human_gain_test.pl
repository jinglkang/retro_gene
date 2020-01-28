#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open C,"$ARGV[0]" || die "$!";
open M,"$ARGV[1]" || die "$!";
open OUT,">$ARGV[2]" || die "$!";


#while (<IN>) {
#	chomp;
#	if (/^\#/) {next;}
#	if (/^\d/) {
#		#1 chr1 77777 78631 chr16 16245 17058 - 60812
#
#		my @tmp=split;
#		print OUT "$tmp[1] \t$tmp[2]\t$tmp[3]\n";
#		
#	}
#}

#13546 chr1 130483151 130486644 chr1 149655805 149659313 + 318020        0       4       3037    3037    1       130486187   130486187
#13546 chr1 130483151 130486644 chr1 149655805 149659313 + 318020        1       1       98      98      1       149655902   149655902


#chr18   3478    4164
#chr18   4327    4921

my %hash_start;
my %hash_end;
while (<M>) {
	chomp;
	my @infor=split;
	$hash_start{$_}=$infor[1];
	$hash_end{$_}=$infor[2];
}
close M;

while (my $c_line=<C>) {
	chomp $c_line;
	my @infor=split /\s+/, $c_line;
	if ($infor[9]==0) {
		
	my $start=$infor[11]-1;
	my $end=$start+1;
	
	#print "$start\t$end\n";
		foreach my $key (keys %hash_start) {
			my @tmp=split /\s+/ ,$key;
			#print "$tmp[0]\t$infor[1]<<<<<<<<<<\n";
			if ($tmp[0] eq $infor[1]) {
				if ($start>=$hash_start{$key} && $hash_end{$key}<=$tmp[2]) {
					
					print OUT $c_line,"\n";
					last;
				}
			}
		}


	}
}
close C;
exit;
