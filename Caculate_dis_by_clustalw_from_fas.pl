#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Seq1,"$ARGV[0]" || die"$!";
open Seq2,"$ARGV[1]" || die"$!";
open List,"$ARGV[2]" || die"$!";
open OUT, ">$ARGV[3]" || die '!';
open Aln,">$ARGV[4]"||die '!';

#>1
#AAA
#>2
#AAA

my %seq;
my %format;
my $name;

while (<Seq1>) {
	chomp;
	if (/^>([^\s+]+)/) {
	 $name=$1;
	 if (!exists $format{$name}) { $format{$name}=$_;}
	 else {$seq{$name}='';}
	}
	else {$seq{$name}.=$_;}
}

while (<Seq2>) {
	chomp;
	if (/^>([^\s+]+)/) {
	 $name=$1;
	 if (!exists $format{$name}) { $format{$name}=$_;}
	 else {$seq{$name}='';}
	}
	else {$seq{$name}.=$_;}
}

while (<List>) {
	chomp;
	my @infor=split;
	if (!exists $seq{$infor[0]} or !exists $seq{$infor[5]}) {next;}

	open TMP, ">$infor[0]_$infor[5].tmp"||die '!';
		print TMP ">$infor[0]\n$seq{$infor[0]}\n>$infor[5]\n$seq{$infor[5]}\n";
	close TMP;

	system("clustalw-1.8 -infile=$infor[0]_$infor[5].tmp");
	system("clustalw-1.8 -infile=$infor[0]_$infor[5].aln  -outputtree=dis -tossgaps -kimura -tree");
	
	open TMP,"$infor[0]_$infor[5].aln";
		my @data=<TMP>;
		print Aln @data;
	close TMP;
	#exit;

	system ("rm $infor[0]_$infor[5].aln $infor[0]_$infor[5].dnd $infor[0]_$infor[5].ph $infor[0]_$infor[5].tmp");
	open TMP,"$infor[0]_$infor[5].dst";
		my @data=<TMP>;
		print OUT ">$infor[0]\t$infor[5]\n@data\n";
	close TMP;
	unlink "$infor[0]_$infor[5].dst";
}
close OUT;