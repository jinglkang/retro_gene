#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
open List,"$ARGV[1]" || die"!";

#BM052962|NM_014280      3.584962501
my %hash;
while (<List>) {
	chomp;
	my @infor=split;
	$hash{$infor[0]}=$infor[2];
}

while (<IN>) {
	chomp;
	my @infor=split;
	my @tmp=split /\|/,$infor[0];
	foreach my $item (@tmp) {
		if (exists $hash{$item}) {print "$hash{$item}\t$infor[1]\n";last;}
	}
}