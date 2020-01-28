#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";

#>BC079107,5	NM_001001513
#GTGTGGATGGGACAGTGAGTGGCTGGGAAGAGACCAAAATCAACAGCTCCAGCCCTCTGCGCTATGACCGCCAGATTGGGGAATTTACGGTCATCAGGGCTGGGCTCTACTACCTGTACTGTCAG

while (<IN>) {
	chomp;
	if (/^>/) {
		my @infor=split;
		print OUT "$infor[0]\n";
	}
	else {print OUT $_,"\n";}
}
