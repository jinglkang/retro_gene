#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";

open Ref,"$ARGV[1]" || die"!";
open Change,"$ARGV[2]" || die"!";

#DA422670,1      chr1    +       75906107        75906194
#AK056852,1      NM_000014       -       9109689 9109923 235     low     100     1       1
#910     2465    0       91      0       0       0       7       23178   +       NM_003758       2558    0       2556    chr15       100338915       42616557        42642291        8       170,104,55,92,115,162,74,1784,  0,170,274,329,421,536,698,772,      42616557,42616813,42630365,42630920,42634042,42636978,42639738,42640507,

my %exon_of_ref;
while (<Change>) {
	chomp;
	my @infor=split;
	$exon_of_ref{$infor[0]}=$infor[1];
}
close Change;


my %strand;
while (<Ref>) {
	chomp;
	my @infor=split;
	$strand{$infor[10]}=$infor[9];
}
close Ref;


while (<IN>) {
	chomp;
	my @infor=split;
	if ($strand{$exon_of_ref{$infor[0]}} eq "-") {
		print "$infor[0]\t$infor[1]\t-\t$infor[3]\t$infor[4]\n";
	}
	elsif ($strand{$exon_of_ref{$infor[0]}} eq "+"){
		print "$infor[0]\t$infor[1]\t+\t$infor[3]\t$infor[4]\n";
	}
	else{die "!";exit;}
}
