#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Human,"$ARGV[0]" || die"$!";
open Mouse,"$ARGV[1]" || die"$!";

#AK052599,5      182     4       182     +       BC031261,10     182     4       182     1       160     4,182;  4,182;  +160;
#BI329881,2      129     4       129     +       BX952891,5      129     4       129     1       115     4,129;  4,129;  +115;
my %human;
while (<Human>) {
	chomp;
	my @infor=split;
	$human{"$infor[0]\t$infor[5]"}=1;
}
close Human;

while (<Mouse>) {
	chomp;
	my @infor=split;
	if (exists $human{"$infor[5]\t$infor[0]"}) {
		print "$infor[5]\t$infor[0]\n";
	}
}