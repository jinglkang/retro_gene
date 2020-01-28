#!/usr/bin/perl -w

use strict;
open Overlap, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Exon, "$ARGV[1]"||die "can not open $ARGV[1]\n";

open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";

#CK628492        NM_007775       1
#AK037364        NM_181048       2
#CA325593        NM_007775       2
#CA317705        NM_019999       4
#CO046011        NM_007775       1
#
#W84225,1        NM_011418       +       75560035        75560225        191
#W84225,2        NM_011418       +       75553096        75553227        132
#CJ100471,1      NM_001002268    +       14238147        14238247        101
#BY344790,1      NM_198107       +       79687507        79687669        163
#CF726677,1      NM_026101       +       62764205        62764235        31
#CF726677,2      NM_026101       +       62764609        62764912        304
#BI155468,1      NM_177614       +       126597091       126597185       95
#BI155468,2      NM_177614       +       126596881       126596935       55

my %overlap;
while (<Overlap>) {
	chomp;
	my @infor=split;
	$overlap{$infor[0]}=$infor[1];
}
close Overlap;

while (<Exon>) {
	chomp;
	my @infor=split;
	my $name=(split /,/ , $infor[0])[0];
	
	
	if (exists $overlap{$name}) {
		print OUT "$infor[0]\t$overlap{$name}\t$infor[2]\t$infor[3]\t$infor[4]\t$infor[5]\n";
		if ($overlap{$name} ne $infor[1]) {print "$name\t$infor[1]\t$overlap{$name}\n";}
	}
	else{print OUT $_."\n";}
}