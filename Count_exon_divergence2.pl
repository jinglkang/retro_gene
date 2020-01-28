#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";

#AI528951,2      CO555152,2      low     major   52      185
#BM729732,3      CF249246,3      low     constitutive    100     100

my %mouse_expression;
my %rat_expression;
while (<IN>) {
	chomp;
	my @infor=split;
	if ($infor[2] eq 'low') {$mouse_expression{$infor[0]}=1;}
	elsif ($infor[2] eq 'minor'){$mouse_expression{$infor[0]}=2;}
	elsif ($infor[2] eq 'middle'){$mouse_expression{$infor[0]}=3;}
	elsif ($infor[2] eq 'major'){$mouse_expression{$infor[0]}=4;}
	elsif ($infor[2] eq 'constitutive'){$mouse_expression{$infor[0]}=5;}
	else{print "$infor[2]\twrong>>>>>>>>\n";next;}

	if ($infor[3] eq 'low') {$rat_expression{$infor[1]}=1;}
	elsif ($infor[3] eq 'minor'){$rat_expression{$infor[1]}=2;}
	elsif ($infor[3] eq 'middle'){$rat_expression{$infor[1]}=3;}
	elsif ($infor[3] eq 'major'){$rat_expression{$infor[1]}=4;}
	elsif ($infor[3] eq 'constitutive'){$rat_expression{$infor[1]}=5;}
	else{print "$infor[3]\twrong>>>>>>>>\n";next;}
	
	if ($mouse_expression{$infor[0]}-$rat_expression{$infor[1]}>=1) {
		print OUT "$_\tdown\t",abs($mouse_expression{$infor[0]}-$rat_expression{$infor[1]}),"\n";
	}
	elsif ($rat_expression{$infor[1]}-$mouse_expression{$infor[0]}>=1)
	{
		print OUT "$_\tup\t",abs($rat_expression{$infor[1]}-$mouse_expression{$infor[0]}),"\n";
	}
	elsif ($mouse_expression{$infor[0]}==$rat_expression{$infor[1]})
	{print OUT "$_\tunchange\t0\n";}
}
