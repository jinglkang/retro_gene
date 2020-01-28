#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Insertion_list,"$ARGV[0]" || die"$!";
open Gap_type,"$ARGV[1]" || die"$!";
open Exon_infor,"$ARGV[2]" || die"$!";

open OUT,">$ARGV[3]" || die"$!";

#220383259_220535540	NM_000573,22    205785760_205804333     103     100     87.37
#220383259_220535540	X05309,9        205785760_205804333     100     100     100
#220383259_220535540	U04817,14       1619197_1671806 117     100     96.58

#23734415_23742802       inv     99.964234620887 far     duplication
#23734415_23742802       inv     99.964234620887 far     duplication
#23829194_23831583       inv     100     far     duplication

#AB033108,9	NM_012284	+	48230130	48230379	250	low	100	2	2
#AY423378,3	NM_003330	+	103179127	103179221	95	low	25	1	4
#BP299206,4	NM_018460	+	143819882	143819969	88	constitutive	100	36	36
#/disk/home/lix/result/human/human_insertion/chr9.insertion.seq.bla.solar.best.tab
my $tmp=(split /\//,$ARGV[0])[-1];
my $chr=(split /\./,$tmp)[0];
my %exon_gene;
my %exon_type;
while (<Exon_infor>) {
	chomp;
	my @infor=split;
	$exon_gene{$infor[0]}=$infor[1];
	$exon_type{$infor[0]}=$infor[6];
}
close Exon_infor;

my %gap_arrangement;
my %gap_duplicate;
while (<Gap_type>) {
	chomp;
	my @infor=split;
	$gap_arrangement{$infor[0]}=$infor[1];
	$gap_duplicate{$infor[0]}=$infor[-1];
}
close Gap_type;

while (<Insertion_list>) {
	chomp;
	my @infor=split;
	my $name=$infor[1];
	my $gap_name=$infor[2];
	my $gap_len=(split /_/,$infor[2])[1]-(split /_/,$infor[2])[0]+1;
	if (exists $gap_arrangement{$gap_name}) {
	print OUT "$chr\t$name\t$exon_gene{$name}\t$exon_type{$name}\t$gap_name\t$gap_len\t$gap_arrangement{$gap_name}\t$gap_duplicate{$gap_name}\n";
	}
	else
	{
	print OUT "$chr\t$name\t$exon_gene{$name}\t$exon_type{$name}\t$gap_name\t$gap_len\tuniq_seq\tNA\n";
	}
}