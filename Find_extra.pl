#!/usr/bin/perl -w
open IN, "$ARGV[0]"||die '!';
my $pos=$ARGV[1]-1;
use strict;
my %hash;
my %tag;
while (<IN>) {
	chomp;
	my @infor=split;
	$hash{$infor[$pos]}.="$_\n";$tag{$infor[$pos]}++;
}
close IN;

foreach my $key (keys %hash) {
	if ($tag{$key}>1) {
		print $hash{$key};
	}
}