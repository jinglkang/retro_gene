#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";

#Hs.108080       0008270 0046872 0005634
#Hs.110837       0000166 0003924 0005200 0005525 0007018 0051258 0005856 0005874 0043234
#Hs.119598       0003723 0003735 0006412 0005622 0005730 0005840 0005842         0003735 0006412 0005622 0005840 

my %GO_num;
while (<IN>) {
	chomp;
	my @infor=split;
	for (my $i=1;$i<=@infor-1 ;$i++) {
		$GO_num{$infor[$i]}++;
	}
}

foreach my $key (keys %GO_num) {
	print "GO:$key\t$GO_num{$key}\n";
}