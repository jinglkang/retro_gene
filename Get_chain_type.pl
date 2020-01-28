#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";

#net chr1 247249719
# fill 464 19426 chr15 - 100030911 19150 id 1373 score 1329992 ali 18223 qDup 19150 type top tN 0 qN 336 tR 4194 qR 3774 tTrf
#594 qTrf 658
#  gap 631 10 chr15 - 100049894 0 tN 0 qN 0 tR 10 qR 0 tTrf 10 qTrf 0
my $chr;
my %chain;
while (<IN>) {
	chomp;
	my @infor=split;
	if (/^net/) {
		$chr=$infor[1];
	}
	else
	{
		if (/^\s+fill.*id\s(\d+)\s.*type\s(\w+)\s/) {
			$chain{"$chr\t$1"}=$2;
		}
	}
}

foreach my $key (keys %chain) {
	if ($key =~/random/ or $key=~/chrUn/) {next;}
	print OUT "$key\t$chain{$key}\n";
}