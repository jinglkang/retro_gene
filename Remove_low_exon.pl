#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";

#BI000847,2      NM_016429       +       43460041        43460154        114     low     13.3333333333333        4       30
#CD109558,5      NM_018843       +       87123847        87123914        68      constitutive    100     20      20

while (<IN>) {
	chomp;
	my @infor=split;
	if ($infor[-1]<5) {next;;}
	my $type;
	my $coverage = 10000*$infor[-2]/$infor[-1];
	if ($coverage == 10000) {$type = "constitutive"}
	elsif ($coverage >= 6700) {$type = "major"}
	elsif ($coverage > 3300) {$type = "middle"}
	else {$type = "minor"};
	if($coverage > 10000) {$type = "wrong";}
	$coverage = $coverage/100;
	print "$infor[0]\t$infor[1]\t$infor[2]\t$infor[3]\t$infor[4]\t$infor[5]\t$type\t$coverage\t$infor[-2]\t$infor[-1]\n";
}