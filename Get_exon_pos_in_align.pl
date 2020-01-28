#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open Exon,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";

#0 chr1 465 1249 chr15 13362 14061 - 51988

#BE294483,2      chr1    +       39876660        39876796
#DA011479,4      chr1    +       219249332       219249395
my %align_start;
my %align_end;
while (<IN>) {
	chomp;
	my @infor=split;
	$align_start{$infor[0]}=$infor[2];
	$align_end{$infor[0]}=$infor[3];
}
close IN;

while (<Exon>) {
	chomp;
	my @infor=split;
	my $start=$infor[3];
	my $end=$infor[4];
	#print ">>>\n";
	foreach my $key (keys %align_start) {
		if ($align_start{$key}<=$start && $align_end{$key}>=$end) {
			print OUT "$infor[0]\t$key\n";
			last;
		}
	}
}