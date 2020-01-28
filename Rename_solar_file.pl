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
	print "$hash{$infor[0]}\t";
	for (my $i=1;$i<@infor ;$i++) {
		print "$infor[$i]\t";
	}
	print "\n";
}
close IN;