#!/usr/bin/perl -w

use strict;
open IN, "$ARGV[0]"||die "can not open $ARGV[0]\n";

while (<IN>) {
	chomp;
	if (/^>/) {
		my @infor=split;
		my $name=(split /\|/, $infor[0])[-1];
		rename ("$ARGV[0]", "$name");
		last;
	}
}
exit;