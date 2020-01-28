#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";

#Hs.418167	0003677	0005386	0005504	0005504	0005504	0005507	0005515	0008144	0008144	0008144	0008144	0008144	0015643	0016209	0030170	0046872	0050824	0006810	0009267	0019836	0030104	0043066	0043072	0050891	0051659	0005576	0005615	0043234		0005386	0006810	0005615		0005386	0006810	0005615		0005386	0006810	0005615		
#Hs.42806	0005509		0005509		0005509		0005509		

my %Go;

while (<IN>) {
	chomp;
	my @infor=split;
	my %hash;
for (my $i=1;$i<=@infor-1 ;$i++) {
	if (!exists $hash{$infor[$i]}) {
		$Go{$infor[0]}.="$infor[$i]\t";
		$hash{$infor[$i]}=1;
	}
	else{next;}
}
}

foreach my $key (keys %Go) {
	print "$key\t$Go{$key}\n";
}