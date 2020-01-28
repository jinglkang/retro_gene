#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open IN_2,"$ARGV[1]"||die '!';
open Homo, "$ARGV[2]"||die '!';
my %hash;
while (<IN>) {
	chomp;
	my @infor=split;
	$hash{$infor[0]}=$infor[-1];
}
close IN;

my %hash_2;
while (<IN_2>) {
	chomp;
	my @infor=split;
	$hash_2{$infor[0]}=$infor[-1];
}
close IN_2;

while (<Homo>) {
	chomp;
	my @infor=split;
	if (exists $hash{$infor[2]} && exists $hash_2{$infor[3]}) {
		print "$infor[2]\t$infor[3]\t$hash{$infor[2]}\t$hash_2{$infor[3]}\n";
	}
}