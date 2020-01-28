#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";

#75510   77490   1981    1       1981    100     100
my $chr=(split /\./,$ARGV[0])[0];
$chr=~s/result\///;
while (<IN>) {
	chomp;
	my @infor=split;
	print OUT "$infor[0]_$infor[1]\t$chr\t+\t$infor[0]\t$infor[1]\n";
}

#0610027H24      chr1    -       91155880        91167035