#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";

#CLUSTAL W (1.8) multiple sequence alignment
#
#
#DA411265_1      -------GAGCATCGTGCATCAAGTCACCAGGGTGGTCCATTCAAGCTGCAGATTTGTTT
#BY180693_1      AAGTATCCTGCACCGTGCAACAAGT-ACGAGGGCGGTCGCTTCAAGCTGCAGATCTGTCT
#                         *** ****** ***** ** **** ****  ************** *** *
#
#DA411265_1      GTCATCCTTGTACAGCAATCTCCTCCTCCACTGCCACTACAGGGAAGTGCATCACATGTC
#BY180693_1      GTCATCCTTATCCAACAGTCTCTTCCTCCACTCCCTCCACAGGGAAGGGCGTCACCTGTC
#                ********* * ** ** **** ********* ** * ********* ** **** ****
#
#DA411265_1      AG------
#BY180693_1      AGGTGAGA
#                **      
#CLUSTAL W (1.8) multiple sequence alignment


my $seq1;
my $seq2;
while (<IN>) {
	chomp;
	my @infor=split;
	if (/^CLUSTAL/) {next;}
	if (/^\w+/) {
		#print "$infor[1]\n";exit;
		$seq1.=$infor[1];
			$_=<IN>;
			chomp;
			my @infor1=split;
		$seq2.=$infor1[1];
	}
}

print ">seq1\n$seq1\n>seq2\n$seq2\n";