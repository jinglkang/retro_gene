#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open New,"$ARGV[0]" || die"$!";

my %hash;
while (<New>) {
	chomp;
	my @infor=split;
	$hash{$infor[0]}++;
}
close New;

foreach my $key (keys %hash)
{
if ($hash{$key}>1){print "$key\n";}
}
