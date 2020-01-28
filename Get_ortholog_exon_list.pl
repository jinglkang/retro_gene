#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Homo,"$ARGV[0]" || die"$!";
open Est_ugid,"$ARGV[1]" || die"$!";
open Change,"$ARGV[2]" || die"$!";

#NM_001001184    XM_341433       Mm.217385       Rn.145160

#AA891226        Noinfor Rn.2    Noinfor Noinfor

#DY550783,1      NM_001001505    +       262789002       262789115       114     low     100     2       2
my %homo;
while (<Homo>) {
	chomp;
	my @infor=split;
	$homo{$infor[-1]}=$infor[0];
}
close Homo;

my %est_ugid;
while (<Est_ugid>) {
	chomp;
	my @infor=split;
	$est_ugid{$infor[0]}=$infor[2];
}
close Est_ugid;

while (<Change>) {
	chomp;
	my @infor=split;
	my $tmp=(split /,/,$infor[0])[0];
	if (!exists $est_ugid{$tmp}) {print "wrong\n";exit;}
	if (exists $homo{$est_ugid{$tmp}}) {
		print "$infor[0]\t$est_ugid{$tmp}\n";
	}
}


