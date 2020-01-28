#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open EST,"$ARGV[0]" || die"$!";
open REF,"$ARGV[1]" || die"$!";

open Rel,"$ARGV[2]" || die"$!";
open OUT,">$ARGV[3]" || die"$!";
my $name;
my %est_seq;
my %seq;
while (<EST>) {
	chomp;
	if (/^>/) {
		my @infor=split;
		$name=$infor[0];
		$name=~s/>//;
	}
	else {$est_seq{$name}.=$_;}
}
while (<REF>) {
		chomp;
	if (/^>/) {
		my @infor=split;
		$name=$infor[0];
		$name=~s/>//;
	}
	else {$seq{$name}.=$_;}

}

while (<Rel>) {
	chomp;
	my @infor=split;
	#if (!exists $seq{$infor[0]} or !exists $seq{$infor[1]}) {next;}
	open TMP , ">tmp.seq1"||die "!";
	#print "$infor[0]\n$est_seq{$infor[0]}\n";
	print TMP ">$infor[0]\n$est_seq{$infor[0]}\n";
	close TMP;
	open TMP, ">tmp.seq2"||die "!";
	print TMP ">$infor[1]\n$seq{$infor[1]}\n";
	close TMP;
	system ("/disk/public/genomics/blast-2.2.8/bl2seq -i tmp.seq1 -j tmp.seq2 -p blastn -F F -e 1e-10 -D 0 -o tmp.bla");
	open TMP,"tmp.bla"||die "!";
	my @data=<TMP>;
	print OUT @data;
	close TMP;
}

#system ("rm tmp.seq1 tmp.seq2 tmp.bla");
close OUT;

