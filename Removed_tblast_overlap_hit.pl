#!/usr/bin/perl -w

use strict;
 open IN, "$ARGV[0]"||die '!';
open List,"$ARGV[1]"||die '!';

#GSTENP00000073001       163     31      155     +       15_random       3125405 596403  597122  2       78      31,114;99,155;       596403,596747;596967,597122;    +55;+33;
#::::::::::::::
#10.solar.by.chr.overlap.define.del
#GSTENP00000073001_10_10836410_10836966
my %hash;
while (<List>) {
	chomp;
	if (/_/) {
		my @infor=split;
		$hash{$infor[0]}=$infor[0];
	}
}
close List;

while (<IN>) {
	chomp;
	my @infor=split;
	if (exists $hash{"$infor[0]_$infor[5]_$infor[7]_$infor[8]"}) {next;}
	else
	{print "$infor[0]_$infor[5]_$infor[7]_$infor[8]\t$infor[5]\t$infor[4]\t",$infor[7]-1000,"\t",$infor[8]+1000,"\n";}
}