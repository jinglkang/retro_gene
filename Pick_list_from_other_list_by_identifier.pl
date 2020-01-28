#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open List,"$ARGV[0]" || die"$!";
open IN,"$ARGV[1]" || die"$!";


open OUT,">$ARGV[2]" || die"$!";

#>>>     AA401607,1
#AA401607,1      NM_000014       +       9116317 9116349 33
#>>>     DA761696,3
#DA761696,3      NM_000014       +       9116516 9116571 56
#>>>     AW848807,1
my $name;
my %hash;
while (<IN>) {
	chomp;
	if (/>>>/) {
		$name=(split /\s+/,$_)[1];
	}
	else {$hash{$name}.="$_\n";}
}

while (<List>) {
	chomp;
	my @infor=split;
	print OUT $hash{$infor[0]};
}