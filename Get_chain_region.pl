#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";

#chain 17408357451 chr1 247249719 + 96118 246871250 chr1 229974691 + 243304 229800167 1
while (<IN>) {
	chomp;
	if (/^\#/) {next;}
	if (/^chain/) {
		my @infor=split;
		print OUT "$infor[5]\t$infor[6]\n";
	}
}