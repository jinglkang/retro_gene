#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
open OUT,">$ARGV[1]" || die"!";

#NM_174635       +       Bt.1    232     1407
#XM_865068       +       Bt.1    1       759

my %hash;
my %best;


while (<IN>) {
	chomp;
	my @infor=split;
if (!exists $hash{$infor[2]}) {
	$hash{$infor[2]}=$_; 
	$best{$infor[2]}=$infor[4]-$infor[3];
}
else{
	if ($infor[4]-$infor[3]>$best{$infor[2]}) {
	$hash{$infor[2]}=$_;
	$best{$infor[2]}=$infor[4]-$infor[3];
	}
	}

}

foreach my $key (keys %hash) {
	print OUT $hash{$key}, "\n";
}