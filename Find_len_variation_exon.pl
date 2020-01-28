#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";

#>>>     DA865069,1
#DA865069,1      NM_001397       +       21350990        21351164        175     low     0.645161290322581       1       155
#BX642912,1      NM_001397       +       21350990        21351137        148     low     0.645161290322581       1       155
#BX472983,1      NM_001397       +       21350990        21351134        145     low     2.58064516129032        4       155
#DA887312,1      NM_001397       +       21350990        21351178        189     low     0.645161290322581       1       155
#DA451750,2      NM_001397       +       21350990        21351131        142     major   69.0322580645161        107     155
#DA452501,1      NM_001397       +       21350990        21351145        156     low     0.645161290322581       1       155
my $name;
my %hash;
while (<IN>) {
	chomp;
	my @infor=split;
	if (/^>>>/) {
		$name=$infor[1]; #代表所有这个位置的exon的名字
	}
	else
	{$hash{"$name\t$infor[5]"}=1;}
}
close IN;

my %count;
foreach my $key (keys %hash) {
	my @infor=split /\t/,$key;
	$count{$infor[0]}++;
}

foreach my $key (keys %count) {
	if ($count{$key}>1) {
		print "$key\n";
	}
}