#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Chimp,"$ARGV[0]" || die"$!";
open Macaca,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";

#AY494058,2      AG      GT      AG      GC      +
#DA815448,1      AG      GT      AT      GT      +

my %chimp_exon_left;
my %chimp_exon_right;

while (<Chimp>) {
	chomp;
	my @infor=split;
	$chimp_exon_left{$infor[0]}=$infor[3];
	$chimp_exon_right{$infor[0]}=$infor[4];
}
close Chimp;

while (<Macaca>) {
	chomp;
	my @infor=split;
	if (!exists $chimp_exon_left{$infor[0]}) {next;}
	if ($infor[3] eq $chimp_exon_left{$infor[0]} and $infor[4] eq $chimp_exon_right{$infor[0]}) {
		print OUT "$_\t$chimp_exon_left{$infor[0]}\t$chimp_exon_right{$infor[0]}\n";
	}
}
