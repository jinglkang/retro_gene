#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open H,"$ARGV[1]" || die"$!";
open M,"$ARGV[2]" || die"$!";


#AL512764,2      BC058704,3      low     low     423     423
#BE327057,2      AK154968,15     major   constitutive    162     162
my %human;
while (<H>) {
	chomp;
	my @infor=split;
	$human{$infor[0]}=1;
}
close H;
my %mouse;
while (<M>) {
	chomp;
	my @infor=split;
	$mouse{$infor[0]}=1;
}
close M;

while (<IN>) {
	chomp;
	my @infor=split;
	if (exists $human{$infor[0]} && exists $mouse{$infor[1]}) {
		print "$_\n";
	}
}
close IN;
exit;