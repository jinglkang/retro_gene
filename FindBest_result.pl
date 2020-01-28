#!/usr/bin/perl

open (IN,"$ARGV[0]")||die;
open (OUT,">$ARGV[1]")||die;

#910	2465	0	91	0	0	0	7	23178	+	NM_003758	2558	0	2556	chr15	100338915	42616557	42642291	8	170,104,55,92,115,162,74,1784,	0,170,274,329,421,536,698,772,	42616557,42616813,42630365,42630920,42634042,42636978,42639738,42640507,	Hs.404056	61	837



use strict;
my %best_result=();
my %best=();

while (<IN>) {
	chomp;
	if (!/^\d/) {next;}
	my @infor=split;
	my $name=$infor[10];
	if (!exists $best_result{$name}) {$best_result{$name}=$_;$best{$name}=$infor[1]+$infor[3];}
	else {
		if (($infor[1]+$infor[3])>$best{$name}) {
		$best_result{$name}=$_;
		$best{$name}=$infor[1]+$infor[3];
		}
	}
}

foreach my $key (keys %best_result) {
	print OUT $best_result{$key},"\n";
}

