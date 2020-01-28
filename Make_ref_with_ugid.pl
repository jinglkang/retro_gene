#!/usr/bin/perl -w

use strict;
open Ref, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Ugid, "$ARGV[1]"||die "can not open $ARGV[1]\n";

open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";
#NM_001004214
#NM_017196
#NM_001000120
#
#NM_013046       +       Rn.22   103     870
#XM_580110       +       Rn.23   304     1038
#XM_233838       +       Rn.27   1       1494
#NM_019132       +       Rn.31   183     1367
#XM_575296       +       Rn.31   260     1030
#NM_212532       +       Rn.34   236     1093
#XM_579741       +       Rn.34   44      901
my %hash;
while (<Ugid>) {
 my @infor=split;
 $hash{$infor[0]}=$infor[2];
}

while (<Ref>) {
	chomp;
	if (exists $hash{$_}) {print OUT "$_\t$hash{$_}\n";}
	else {print $_,"\n";}
}