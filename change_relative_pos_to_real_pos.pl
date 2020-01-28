#!/usr/bin/perl -w

use strict;
open Exon, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Ref, "$ARGV[1]"||die "can not open $ARGV[1]\n";

open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";
#W84225,1        NM_011418       +       22968   23158   191
#W84225,2        NM_011418       +       29966   30097   132
#CJ100471,1      NM_001002268    +       14447   14547   101
#BY344790,1      NM_198107       +       6286    6448    163


#NM_178779       chr1    -       105174100       105265921
#NM_008384       chr1    -       53017935        53056746
#NM_026976       chr1    +       130764850       130790046
#NM_013784       chr1    -       105414547       105567860

my %ref_start;
my %ref_end;
my %ref_strand;

while (<Ref>) {
	chomp;
	my @infor=split;
	$ref_start{$infor[0]}=$infor[3];
	$ref_end{$infor[0]}=$infor[4];
	$ref_strand{$infor[0]}=$infor[2];
}
close Ref;

while (<Exon>) {
	chomp;
	my @infor=split;
	my $est=$infor[0];
	my $ref=$infor[1];
	my $exon_start=$infor[3];
	my $exon_end=$infor[4];
	if (!exists $ref_start{$ref}) {next;}
	if ($ref_strand{$ref} eq '-') {
		print OUT "$est\t$ref\t$infor[2]\t";
		print OUT $ref_end{$ref}-$exon_end+1;
		print OUT "\t";
		print OUT $ref_end{$ref}-$exon_start+1;
		print OUT "\t";
		print OUT "$infor[-1]\n";
	}
	else {
		print OUT "$est\t$ref\t$infor[2]\t";
		print OUT $ref_start{$ref}+$exon_start-1;
		print OUT "\t";
		print OUT $ref_start{$ref}+$exon_end-1;
		print OUT "\t";
		print OUT "$infor[-1]\n";
		}

}