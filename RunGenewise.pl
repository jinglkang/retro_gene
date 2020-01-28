#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open EST,"$ARGV[0]" || die"$!";
open REF,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";
my $name;
my %est_seq;
my %seq;
my $dir=(split /\//, $ARGV[0])[-1];
print $dir,"\n";
while (<EST>) {
	chomp;
	if (/^>/) {
		my @infor=split;
		$name=$infor[0];
		$name=~s/>//;
	}
	else {$est_seq{$name}.=$_;}
}
close EST;


while (<REF>) {
		chomp;
	if (/^>/) {
		my @infor=split;
		$name=$infor[0];
		$name=~s/>//;
	}
	else {$seq{$name}.=$_;}

}

open EST,"$ARGV[0]" || die"$!";
while (<EST>) {
	if (/^>/) {
	
	chomp;
	$_=~s/>//;
	my @infor=split;
	#if (!exists $seq{$infor[0]} or !exists $seq{$infor[1]}) {next;}
	open TMP , ">$dir.tmp.seq1"||die "!";
	#print "$infor[0]\n$est_seq{$infor[0]}\n";
	print TMP ">$infor[0]\n$est_seq{$infor[0]}\n";
	close TMP;
	open TMP, ">$dir.tmp.seq2"||die "!";
	print TMP ">$infor[1]\n$seq{$infor[1]}\n";
	close TMP;
	system ("genewise  -splice flat    $dir.tmp.seq1  $dir.tmp.seq2   -quiet -genesf -gff -pretty -para -pseudo >$dir.tmp.out");
	open TMP,"$dir.tmp.out"||die "!";
	my @data=<TMP>;
	print OUT @data;
	close TMP;
	}
}

#system ("rm tmp.seq1 tmp.seq2 tmp.bla");
close OUT;

