#!/usr/bin/perl -w

use strict;

open IN,"$ARGV[0]"||die '!';

open Index,"$ARGV[1]"||die '!';

my %hash;
while (<Index>) {
	chomp;
	my @infor=split;
	$hash{$infor[1]}=$infor[0];
}
close Index;

while (<IN>) {
	chomp;
	my @infor=split;
	print "$infor[0]\t$infor[1]\t$infor[2]\t$infor[3]\t$infor[4]\t$hash{$infor[5]}\t";
	for (my $i=6;$i<@infor ;$i++) {
		print "$infor[$i]\t";
	}
	print "\n";
}
close IN;