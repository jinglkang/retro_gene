#!/usr/bin/perl -w

use strict;
open Seq,"$ARGV[0]" || die"$!";
open List,"$ARGV[1]" || die"$!";
open Random,"$ARGV[2]" || die"$!";

open OUT,">$ARGV[3]" || die"$!";

#>AF356523,6     NM_013811
#ATGCTACCATAAGCATCGAGGGGACAGTGATGTTGAAGAAGGTGGACAATATCGACTTCTCCAAGCTGCACACCTTTGAAGAGGTCACAGCTGCAGCAAGCAGCTCGGAGATGGTGCATCAGCT
#GGAGGAGGTGCTGATGGTGTGGTACAAGCAGATCGAGCAG


#NM_001001130	chrUn
#NM_001001144	chr8
#NM_001001152	chr2
#NM_001001160	chr4

#chr10_random
#chr11_random
#chr12_random
#chr13_random

my %random;
while (<Random>) {
	chomp;
	my @infor=split /_/, $_;
	$random{$infor[0]}=$_;
}

my %hash;
while (<List>) {
	chomp;
	my @infor=split;
	$hash{$infor[0]}=$infor[1];
}
my %tag;
my @infor;
while (<Seq>) {
	
	if (/^>/) {
		chomp;
		@infor=split;
		if(exists $random{$hash{$infor[1]}}){print OUT "$infor[0]\t$random{$hash{$infor[1]}}\n";$tag{$infor[0]}=1}
	}
	else {if(exists $tag{$infor[0]}){print OUT $_;}}
}