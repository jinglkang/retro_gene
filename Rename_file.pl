#!/usr/bin/perl -w

use strict;

#Homo_sapiens.NCBI36.42.dna.chromosome.16.fa
my $name;
while (<>) {
	chomp;
	my @infor=split /\./,$_;
	$name="$infor[-2].$infor[-1]";
	system ("mv $_ $name");
}

