#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open C,"$ARGV[0]" || die"$!";
open M,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";


#2181 chr1 6786830 6821690 chr1 6866965 6901877 + 3221775        0       1       3556    3562    7       6790385 6790391
#2181 chr1 6786830 6821690 chr1 6866965 6901877 + 3221775        0       2       4857    4858    2       6791686 6791687

#33327 chr1 142069764 142073421 chr10 60962862 60966482 + 267439 0       1       249     249     1       142070012       142070012
#33327 chr1 142069764 142073421 chr10 60962862 60966482 + 267439 0       2       490     498     9       142070253       142070261
#my %start;
#my %end;
my %human_lost_hash;
my %human_gain_hash;

while (<C>) {
	chomp;
	my @infor=split;
	if ($infor[9]==1) {
		next;
	}
	$human_lost_hash{$infor[1]."\t".$infor[-2]."\t".$infor[-1]}=1;
}
close C;

while (<M>) {
	chomp;
	my @infor=split;
	if ($infor[9]==1) {next;}
	if (exists $human_lost_hash{$infor[1]."\t".$infor[-2]."\t".$infor[-1]}) {
		print OUT $_,"\n";
	}
}