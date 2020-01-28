#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
open List1,"$ARGV[1]" || die"!";
open List2,"$ARGV[2]" || die"!";

my %hash1;
while (<List1>) {
	chomp;
	my @infor=split;
	$hash1{$infor[0]}=$infor[0];
}
close List1;

my %hash2;
while (<List2>) {
	chomp;
	my @infor=split;
	$hash2{$infor[0]}=$infor[0];
}
close List2;

while (<IN>) {
	chomp;
	my @infor=split;
	if (!exists $hash1{$infor[0]} or !exists $hash2{$infor[1]}) {
		next;
	}
	print "$_\n";
}
