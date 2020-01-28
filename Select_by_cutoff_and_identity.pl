#!/usr/bin/perl -w

use strict;
open IN, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open OUT, ">$ARGV[1]"||die "can not open $ARGV[1]\n";

#NM_167388       85      20.53   94.11
#NM_132982       73      6.99    84.93
#NM_167145       34      1.39    94.11
#NM_167201       64      4.19    98.43
#NM_132429       43      1.35    93.02

my %hash_list;
while (<IN>) {
	chomp;
	my @infor=split;
	if (($infor[1]>=200 or $infor[2]>50) and $infor[3]>=85) {  #$infor[1]>=300 or $infor[2]>50) and $infor[3]>=70,先前的标准
		$hash_list{$infor[0]}=$_;
	}
}

foreach my $key (keys %hash_list) {
	print OUT "$hash_list{$key}\n";
}
