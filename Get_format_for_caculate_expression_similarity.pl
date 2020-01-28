#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";
open OUT2,">$ARGV[2]" || die"$!";
open OUT3,">$ARGV[3]"||die '!';
#BQ878395,7      AK154422,7      90      100     83      83      up      10      NM_020936       NM_026409       Hs.286173   Mm.281601
#BP227544,2      BQ885824,1      87.5    100     202     202     up      12.5    NM_003368       NM_146144       Hs.35086    Mm.371692

my %human;
my %mouse;
my %homo;
while (<IN>) {
	chomp;
	my @infor=split;
	my $name="$infor[-4]\t$infor[-3]\t$infor[-2]\t$infor[-1]";
	if (!exists $homo{$name}) {$homo{$name}=$name;}
	$human{$infor[-2]}.="$infor[2]\t";
	$mouse{$infor[-1]}.="$infor[3]\t";
}




foreach my $key (keys %human) {
	print OUT2 "$key\t$human{$key}\n";
}

foreach my $key (keys %mouse) {
	print OUT3 "$key\t$mouse{$key}\n";
}

foreach my $key (keys %homo) {
	print OUT "$key\n";
}