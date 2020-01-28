#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";

#AI528951,2      CO555152,2      10     30   52      185

my %mouse_expression;
my %rat_expression;
while (<IN>) {
	chomp;
	my @infor=split;
	if ($infor[2]>100 or $infor[3]>100) {print "wrong!";next;}
	if ($infor[2]>$infor[3]) {
		print "$_\tdown\t",abs($infor[2]-$infor[3]),"\n";
	}
	elsif($infor[3]>$infor[2])
	{
		print "$_\tup\t",abs($infor[2]-$infor[3]),"\n";	
	}
	elsif ($infor[2]==$infor[3])
	{
		print "$_\tunchange\t0\n";
	}
}
