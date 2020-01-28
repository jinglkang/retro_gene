#!/usr/bin/perl -w

use strict;
open IN, "$ARGV[0]"||die '!';
open OUT, ">$ARGV[1]"||die '!';
#>name
#AAA
my $index=0;
while (<IN>) {
	if (/^>/) {
		print OUT ">gene_$index\n";
		chomp $_;
		my $name=$_;$name=~s/>//;
		print "$name\tgene_$index\n";
		$index++;
	}
	else{print OUT $_;}
}

