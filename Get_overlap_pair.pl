#!/usr/bin/perl -w

use strict;

#gi|22027570|ref|NM_080799.2|    10      +       3085    71231649        71232478        38      exon_1  830     0       829  830      0       829
#gi|22027594|ref|NM_080808.2|    10      +       3058    71231649        71232478        37      exon_1  830     0       829  830      0       829
#gi|22027570|ref|NM_080799.2|    10      +       3085    71252130        71252199        38      exon_2  70      830     899  70       830     899

open IN, "$ARGV[0]"||die '!';
open OUT, ">$ARGV[1]"||die '!';

my %hash;
while (<IN>) {
	chomp;
	my @infor=split;
	my $name1=$infor[0];
	$_=<IN>;
	@infor=split;
	my $name2=$infor[0];
	$hash{"$name1\t$name2"}="$name1\t$name2";
}
close IN;

foreach my $key (keys %hash) {
	print OUT "$key\n";
}