#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";

#>AJ278357,5     CK637933,3
#     2
# AJ278357_5  0.000  0.259
# CK637933_3  0.259  0.000

my $name;
my %dis;
while (<IN>) {
	chomp;
	my @infor=split;
	if (/^>/) {
		$name=$infor[0];
		$name=~s/>//;
		$_=<IN>;
		$_=<IN>;
	}
	else{
		$dis{$name}=$infor[1];
	}
}

foreach my $key (keys %dis) {
	print "$key\t$dis{$key}\t2\n";
}