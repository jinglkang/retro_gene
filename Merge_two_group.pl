#!/usr/bin/perl -w

use strict;
open G1,"$ARGV[0]" || die"$!";
open G2,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";

#ºÏ²¢2¸ögroup
my %hash;
while (<G1>) {
	chomp;
	my @infor=split;
	$hash{$infor[0]}=$_;
}
close G1;

while (<G2>) {
	chomp;
	my @infor=split;
	if(exists $hash{$infor[0]})
	{
		print OUT "$hash{$infor[0]}\t$_\n";
	}
}