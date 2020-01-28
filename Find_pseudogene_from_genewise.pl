#!/usr/bin/perl -w

use strict;

open Genewise, "$ARGV[0]"||die '!';

#genewise $Name: wise2-2-0 $ (unreleased release)
#This program is freely distributed under a GPL. See source directory
#Copyright (c) GRL limited: portions of the code are from separate copyright
#
#Query protein:       AY374480
#Comp Matrix:         blosum62.bla
#Gap open:            12
#Gap extension:       2
#Start/End            default
#Target Sequence      AY374480_4_3322062_3325265
#Strand:              forward
#Start/End (protein)  default
#Gene Paras:          human.gf
#Codon Table:         codon.table
#Subs error:          1e-05
#Indel error:         1e-05
#Model splice?        model
#Model codon bias?    flat
#Model intron bias?   tied
#Null model           syn
#Algorithm            623

#//
#Gene 1
#Gene 1001 2252 [pseudogene]
#  Exon 1001 1537 phase 0
#     Supporting 1001 1536 28 205
#  Exon 1618 2252 phase 1
#     Supporting 1620 2252 207 417
#//


my %hash;
my $name;
while (<Genewise>) {
	chomp;
	if (/^Target Sequence/) {
		my @infor=split;
		$name=$infor[2];
	}
	if (/pseudogene/) {$hash{$name}=1;}

}
close Genewise;

foreach my $key (keys %hash) {
	print "$key\n";
}