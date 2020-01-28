#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";

#DA315588,2      81      1       81      +       BI990889,1      81      1       81      1       73      1,81;   1,81;   +73;
my %hash;
while (<IN>) {
	chomp;
	my @infor=split;
	$hash{$infor[5]}++;
}
close IN;

open IN,"$ARGV[0]" || die"$!";
while (<IN>) {
	chomp;
	my @infor=split;
	if ($hash{$infor[5]}>1) {print "$_\n";}
}