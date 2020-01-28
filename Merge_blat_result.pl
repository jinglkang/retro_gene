#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Chr, "$ARGV[1]"||die "can not open $ARGV[1]\n";

open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";
my %chr_size;
while (<Chr>) {
	chomp;
	my @infor=split;
	$chr_size{$infor[0]}=$infor[1];
}
close Chr;

while (<IN>) {
	chomp;
	my $start;my $end;
	my @infor=split;

	my $chr=$infor[14];
	if ($chr=~/-/) {
		my @tmp=split /_/,$chr;
		my @tmp2=split /-/,$tmp[-1];
		$start=$infor[16]+$tmp2[0]-1;
		$end=$infor[17]+$tmp2[0]-1;
		#$chr=$tmp[0];
		pop (@tmp);
		$chr=join "_", @tmp;
		print $chr,"\n";
		#print "$chr\t$chr_size{$chr}\t$start\t$end\n";
	}
	else {$start=$infor[16];$end=$infor[17];}
if(!exists $chr_size{$chr}){next;}
print OUT "$infor[0]\t$infor[1]\t$infor[2]\t$infor[3]\t$infor[4]\t$infor[5]\t$infor[6]\t$infor[7]\t$infor[8]\t$infor[9]\t$infor[10]\t$infor[11]\t$infor[12]\t$infor[13]\t$chr\t$chr_size{$chr}\t$start\t$end\t$infor[18]\t$infor[19]\t$infor[20]\t$infor[21]\n";
}

