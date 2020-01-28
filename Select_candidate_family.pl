#!/usr/bin/perl -w

use strict;

open Multi, "$ARGV[0]"||die '!';
open Struc,	"$ARGV[1]"||die '!';


#GSTENP00004122001_21_701938_704704      GSTENP00004122001_Un_random_58000001-88000000_21346451_21404976 2

#250     0       0       0       0       0       0       0       +       AY374475        250     1       250     AY374475_10_8560829_8562487   10000000        1001    2659    6       37,43,24,39,53,51,      1,39,83,107,147,200,    1001,1471,1727,1990,2184,2507,        1112,1603,1799,2107,2344,2659,

my %exon_num;
while (<Struc>) {
	chomp;
	my @infor=split;
	$exon_num{$infor[13]}=$infor[17];
}
close Struc;


while (<Multi>) {
	chomp;
	my $tag_single=0;
	my $tag_multi=0;
	my @infor=split;
	for (my $i=0;$i<$infor[-1] ;$i++) {
		if(!exists $exon_num{$infor[$i]}){next;}
		if ($exon_num{$infor[$i]}==1) {$tag_single=1;}
		if ($exon_num{$infor[$i]}>1) {$tag_multi=1;}
	}
	if ($tag_single==1 and $tag_multi==1) {
		for (my $i=0;$i<$infor[-1] ;$i++) {
			if(!exists $exon_num{$infor[$i]}){next;}
			print "$infor[$i]\t$exon_num{$infor[$i]}\t";
		}
		print "\n";
	}
	
}