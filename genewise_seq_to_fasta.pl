#!/usr/bin/perl -w

use strict;

open Seq,"$ARGV[0]"||die '!';

# 1 750
#
#AY374475_10_8560829_8562487     atgtcaggacaagatacaagggccgccgtgattgggtggaccgctctggctctcctcacgtgtgtccacggaggacacatgctggacctgctga
#//

my $name;
my %seq;
while (<Seq>) {
	chomp;
	if (/^\w+/) {
		my @infor=split;
		$name=$infor[0];
		$seq{$name}=$infor[1];
		$seq{$name}=~s/-//g;
	}
}

foreach my $key (keys %seq)
{
	print ">$key\n$seq{$key}\n";
}

