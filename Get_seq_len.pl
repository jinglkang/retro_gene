#!/usr/bin/perl -w

use strict;
open IN, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open OUT, ">$ARGV[1]"||die "can not open $ARGV[1]\n";

#>NM
#NNNNNNNNNNNNN
my %len;
my $name;
while (<IN>) {
chomp;
if (/^>/) {
	my @infor=split;
	$name=$infor[0];
	$name=~s/>//;
}
else{$_=~s/\s+//g;$len{$name}+=length ($_);}
}

foreach my $key (keys %len) {
	print OUT "$key\t$len{$key}\n";
}