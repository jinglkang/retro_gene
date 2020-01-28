#!/usr/bin/perl -w

use strict;
open Homo, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Mouse, "$ARGV[1]"||die "can not open $ARGV[0]\n";
open Human, "$ARGV[2]"||die "can not open $ARGV[0]\n";

#8434    NM_013688       NM_182539
#5006    NM_023502       NM_201999
#55548   NM_009314       NM_001057
my %gene;
while (<Mouse>) {
	chomp;
	my @infor=split;
	$gene{$infor[0]}=$infor[0];
}

while (<Human>) {
	chomp;
	my @infor=split;
	$gene{$infor[0]}=$infor[0];
}

my %homo;
while (<Homo>) {
	chomp;
	my @infor=split;
	if (exists $gene{$infor[1]} && exists $gene{$infor[2]}) {
		print "$infor[1]\t$infor[2]\n";
	}
}