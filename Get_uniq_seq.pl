#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
open OUT,">$ARGV[1]" || die"!";

my %seq;
my %format;
my $name;
while (my $seq_line=<IN>) {
	if ($seq_line=~/^>([^\s+]+)/) {
	 $name=$1;
	 if (!exists $format{$name}) { $format{$name}=$seq_line;}
	 else {$seq{$name}='';}
	}
	else {$seq{$name}.=$seq_line;}
}

foreach my $key (keys %seq) {
	print OUT "$format{$key}$seq{$key}";
}