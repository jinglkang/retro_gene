#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Seq1,"$ARGV[0]" || die"$!";
open Seq2,"$ARGV[1]" || die"$!";
open List,"$ARGV[2]" || die"$!";
open OUT, ">$ARGV[3]" || die '!';
open Aln,">aln.out"||die '!';
#AK092274,6      TTTTATTTCTTACATGCTTTCTAGCTTCATTCATCTGTTCTTTTGTTTAG      GTAAGTTAAATATGCATTTGGCAATTTGAAAGTAGGTGAAAACACTATTT

my %seq1_left;
my %seq1_right;
my %seq2_left;
my %seq2_right;

while (<Seq1>) {
	chomp;
	my @infor=split;
	$seq1_left{$infor[0]}=$infor[1];
	$seq1_right{$infor[0]}=$infor[2];
}
close Seq1;

while (<Seq2>) {
	chomp;
	my @infor=split;
	$seq2_left{$infor[0]}=$infor[1];
	$seq2_right{$infor[0]}=$infor[2];
}
close Seq2;

while (<List>) {
	chomp;
	my @infor=split;
	if (!exists $seq1_left{$infor[0]} or !exists $seq2_left{$infor[1]}) {next;}

	open TMP, ">$infor[0]_$infor[1].tmp"||die '!';
		print TMP ">$infor[0]\n$seq1_left{$infor[0]}$seq1_right{$infor[0]}\n>$infor[1]\n$seq2_left{$infor[1]}$seq2_right{$infor[1]}\n";
	close TMP;

	system("clustalw-1.8 -infile=$infor[0]_$infor[1].tmp");
	system("clustalw-1.8 -infile=$infor[0]_$infor[1].aln  -outputtree=dis -tossgaps -kimura -tree");
	
	open TMP,"$infor[0]_$infor[1].aln";
		my @data=<TMP>;
		print Aln @data;
	close TMP;

	system ("rm $infor[0]_$infor[1].aln $infor[0]_$infor[1].dnd $infor[0]_$infor[1].ph $infor[0]_$infor[1].tmp");
	open TMP,"$infor[0]_$infor[1].dst";
		my @data=<TMP>;
		print OUT ">$infor[0]\t$infor[1]\n@data\n";
	close TMP;
	unlink "$infor[0]_$infor[1].dst";
}
close OUT;