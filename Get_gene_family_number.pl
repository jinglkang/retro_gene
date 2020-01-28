#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";

#2       NM_005160
#2       NM_005163
#2       NM_005204
#2       NM_005308
#2       NM_005400
my %index;
my %gene;
while (<IN>) {
	chomp;
	my @infor=split;
	$index{$infor[0]}++;
	$gene{$infor[1]}=$infor[0];
}

foreach my $key (keys %gene) {
	print "$key\t$index{$gene{$key}}\n";
}
