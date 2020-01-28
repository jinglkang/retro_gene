#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
open Len,"$ARGV[1]" || die"!";

#BF689635,4      BF689635,4      NM_000014       +       3       41
#BF689635,4      NM_000014       +       9112046 9112087 42      major   99.3150684931507        290     292
my %len;
while (<Len>) {
	chomp;
	my @infor=split;
	$len{$infor[0]}=$infor[5];
}
close Len;

while (<IN>) {
	chomp;
	my @infor=split;
	if ($infor[4]<=0) {next;}
	if ($infor[4]>20) {
		print "$_\t$len{$infor[0]}\t5UTR\n";next;	
	}
	if ($len{$infor[0]}-$infor[5]>20) {
		print "$_\t$len{$infor[0]}\t3UTR\n";next;
	}
}
close IN;