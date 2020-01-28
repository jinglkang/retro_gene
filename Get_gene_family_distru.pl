#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";

#NM_006228       1
#NM_183377       4
#NM_002115       5
#NM_004504       1
#NM_022114       571
my %hash;
while (<IN>) {
	chomp;
	my @infor=split;
	$hash{$infor[1]}++;
}
my @sort=sort by_chr_and_start keys %hash;
foreach my $key (@sort) {
	print "$key\t$hash{$key}\n";

}

sub by_chr_and_start {
	$a <=> $b
}
