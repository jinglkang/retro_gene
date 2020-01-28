#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Homo,"$ARGV[0]" || die"$!";
open List1,"$ARGV[1]" || die"$!";#new exon list
open List2,"$ARGV[2]" || die"$!";#same exon list
open OUT1,">$ARGV[3]"||die '!';
open OUT2,">$ARGV[4]"||die '!';

#CJ040723,4      CF110386,3      constitutive    constitutive    123     123
#BF152300,2      BC061964,1      low     low     111     1473
#BU516716,6      CK363887,4      major   constitutive    70      70

#AI791058,1      AG      GT      TG      GT      -
#BG174514,1      AG      GT      AA      GT      -
my %hash_new;
while (<List1>) {
	chomp;
	my @infor=split;
	$hash_new{$infor[0]}=$infor[0];
}

my %hash_same;
while (<List2>) {
	chomp;
	my @infor=split;
	$hash_same{$infor[0]}=$infor[0];
}

while (<Homo>) {
	chomp;
	my @infor=split;
	if (exists $hash_new{$infor[0]}) {
		print OUT1 "$_\n";
	}
	elsif(exists $hash_same{$infor[0]}) 
	{
		print OUT2 "$_\n";
	}
}