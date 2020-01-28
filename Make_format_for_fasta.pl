#!/usr/bin/perl -w

use strict;
open List, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Seq, "$ARGV[1]"||die "can not open $ARGV[1]\n";

open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";

#>BC057147,4     NM_033078
#TATTGTGCAACAAGGAAGTCCCAGTTTCCTCAAGAG

#NM_009670       Mm.235960
#NM_170687       Mm.235960
#NM_177320       Mm.244960
#NM_009706       Mm.35059
#NM_011041       Mm.5035
#NM_177718       Mm.259328

my %hash_list;
while (<List>) {
	my @infor=split;
	$hash_list{$infor[0]}=$infor[1];
}

while (<Seq>) {
	chomp;
	if (/^>/) {
		my @infor=split;
		my $name=$infor[0];
		$name=~s/>//;
		print OUT "$infor[0]\t$hash_list{$name}\n";
	}
	else {print "$_\n";}
}