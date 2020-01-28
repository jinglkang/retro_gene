#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Homo,"$ARGV[0]" || die"$!";
open Mouse,"$ARGV[1]" || die"$!";
open Rat,"$ARGV[2]" || die"$!";

open OUT,">$ARGV[3]" || die"$!";

#13666   NM_172573       XM_221141
#8563    NM_145931       XM_340742

#NM_012060       +       Mm.17   104     841
#NM_017461       +       Mm.18   44      1141
my %mouse;
while (<Mouse>) {
	chomp;
	my @infor=split;
	$mouse{$infor[0]}=$infor[2];
}
close Mouse;

my %rat;
while (<Rat>) {
	chomp;
	my @infor=split;
	$rat{$infor[0]}=$infor[2];
}

while (<Homo>) {
	chomp;
	my @infor=split;
	if (!exists $mouse{$infor[1]} || !exists $rat{$infor[2]}) {next;}
	print OUT "$infor[1]\t$infor[2]\t$mouse{$infor[1]}\t$rat{$infor[2]}\n";
}