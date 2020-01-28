#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Homo,"$ARGV[0]" || die"$!";
open Mouse,"$ARGV[1]" || die"$!";
open Rat,"$ARGV[2]" || die"$!";


#BE633517,1      CR460184,1
#BY061022,1      CO807690,1

#AK030493,14     NM_145125       +       96389018        96389152        135     low     100     4       4
my %exon_mouse;
my %exon_len;
while (<Mouse>) {
	chomp;
	my @infor=split;
	$exon_mouse{$infor[0]}=$infor[7];
	$exon_len{$infor[0]}=$infor[5];
}
close Mouse;

my %exon_rat;
while (<Rat>) {
	chomp;
	my @infor=split;
	$exon_rat{$infor[0]}=$infor[7];
	$exon_len{$infor[0]}=$infor[5];
}

while (<Homo>) {
	chomp;
	my @infor=split;
	if (!exists $exon_mouse{$infor[0]} or !exists $exon_rat{$infor[1]}) {next;}
	print "$_\t$exon_mouse{$infor[0]}\t$exon_rat{$infor[1]}\t$exon_len{$infor[0]}\t$exon_len{$infor[1]}\n";
}