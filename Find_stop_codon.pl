#!/usr/bin/perl -w

use strict;

open IN, "$ARGV[0]"||die '!';

#>name
#AAAXAAA
my $name;
my %seq;

while (<IN>) {
	chomp;
	my @infor=split;
	if (/^>/) {
		$name=$infor[0];
		$name=~s/>//;
	}
	else{$seq{$name}.=$_;}
}
close IN;

my %stop;
foreach my $key (keys %seq) {
	my $len=length($seq{$key});
	for (my $i=0;$i<$len ;$i++) {
		my $tmp=substr ($seq{$key},$i,1);
		if ($tmp eq "X") {$stop{$key}=$i+1;last;}
	}
}

foreach my $key (keys %stop) {
	print "$key\t$stop{$key}\n";
}