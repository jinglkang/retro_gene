#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open List,"$ARGV[0]" || die"$!";
#open Bla,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[1]" || die"$!";

#AK160383,6      67      1       67      +       NM_139181       321480  134364  134564  1       67      1,67;   134364,134564;      +67;
my %start_pos;#存每个block的起始位置
while (<List>) {
	chomp;
	my @infor=split;
	my $name=$infor[0];
	my @q_start=split /;/,$infor[11];
	my @s_start=split /;/,$infor[12];
	for (my $i=0; $i<=@q_start-1;$i++) {
		my @tmp=split /\,/, $q_start[$i];
		my @tmp1=split /,/,$s_start[$i];
		$start_pos{$name}.="$name\t$tmp[0]\t$tmp1[0]\n";
	}
}

foreach my $key (keys %start_pos) {
	print OUT "$start_pos{$key}";
}