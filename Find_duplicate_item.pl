#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open IN_2,"$ARGV[1]" || die"$!";

#BF689635,4      NM_000014       +       9112046 9112087 42      major   99.3150684931507        290     292
#BC075029,4      Var_ture        NM_006849       275085  275201

my %hash;
while (<IN_2>) {
	chomp;
	my @infor=split;
	$hash{"$infor[2]\t$infor[3]\t$infor[4]"}=$infor[1];
}
close IN_2;

while (<IN>) {
	chomp;
	my @infor=split;
	if (exists $hash{"$infor[1]\t$infor[3]\t$infor[4]"}) {
		print "$infor[0]\t",$hash{"$infor[1]\t$infor[3]\t$infor[4]"},"\n";
	}
}
close IN;