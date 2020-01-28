#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open H,"$ARGV[0]" || die"$!";
open M,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";

#38814050        38814365        316
#84179015        84179280        266
#28999776        28999932        157
my %hash;
while (<H>) {
	chomp;
	my @infor=split;
	$hash{"$infor[0]\t$infor[1]"}=1;
}
close H;

while (<M>) {
	chomp;
	my @infor=split;
	if (exists $hash{"$infor[1]\t$infor[2]"}) {
		print OUT "$_\n";
	}
}

