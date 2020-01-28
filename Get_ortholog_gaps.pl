#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open List,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";

#14      chrY    80795   82775
#25      chrY    185160  185893
#28      chrY    187998  189019


#84 chrY 211605 212133 chrY 8484610 8485138 + 33047      0       1       143     144     2       211747  211748
#84 chrY 211605 212133 chrY 8484610 8485138 + 33047      1       1       38      39      2       8484647 8484648

my %hash;
while (<IN>) {
	chomp;
	my @infor=split;
	$hash{"$infor[1]\t$infor[0]"}=1;
}
close IN;

while (<List>) {
	chomp;
	my @infor=split;
	if ((exists $hash{"$infor[1]\t$infor[0]"}) && ($infor[9]==0)) {
		print OUT $_,"\n";
	}
}
