#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open PRO,"$ARGV[0]" || die"!";
open GENOMIC,"$ARGV[1]" || die"!";
open LIST, "$ARGV[2]"||die '!';
open OUT,">$ARGV[3]" || die"!";

my $name;
my %pro_seq;
my %seq;

while (<PRO>) {
	chomp;
	if (/^>/) {
		my @infor=split;
		$name=$infor[0];
		$name=~s/>//;
	}
	else {$pro_seq{$name}.=$_;}
}
close PRO;

#>GSTENP00004782001_15_random_132680_136159
#TTCTGCTGTAGGCTTGTTTTTAAAATGTAAATTAAAACAAGTGGTTAAATCAAAGGCTGG
#CTCACCCCAAACCCTTTAGGGTTCCTGCTTTATATGGTGGTCTTCTGAAAGGGGCACCCG

while (<GENOMIC>) {
		chomp;
	if (/^>/) {
		my @infor=split;
		$name=$infor[0];
		$name=~s/>//;
	}
	else {$seq{$name}.=$_;}

}
close GENOMIC;

#GSTENP00000073001_15_random_596403_597122       15_random       +       595403  598122
#GSTENP00000363001_15_random_1494539_1498044     15_random       +       1493539 1499044

while (<LIST>) {
	chomp;
	my @infor=split;
	my @tmp=split /_/,$infor[0];

	open TMP , ">$tmp[0]_$infor[0].seq1"||die "!";
	print TMP ">$tmp[0]\n$pro_seq{$tmp[0]}\n";
	close TMP;
	open TMP, ">$tmp[0]_$infor[0].seq2"||die "!";
	print TMP ">$infor[0]\n$seq{$infor[0]}\n";
	close TMP;
	
	system ("genewise  $tmp[0]_$infor[0].seq1  $tmp[0]_$infor[0].seq2   -quiet -genesf -pseudo >$tmp[0]_$infor[0].out");
	open TMP,"$tmp[0]_$infor[0].out"||die "!";
	my @data=<TMP>;
	print OUT @data;
	close TMP;
	system ("rm $tmp[0]_$infor[0].seq1 $tmp[0]_$infor[0].seq2 $tmp[0]_$infor[0].out");
}
close LIST;
close OUT;

