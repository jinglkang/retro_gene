#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";

#>NM_000015 "NM_000015",,,,108,980,""
#TGAGATCACTTCCCTTGCACAGTTTGGAAGGGAGAGCACTTTATTACAGACCTTGGAAGC
my $name;
my %seq;
while (<IN>) {
	chomp;
	if (/^>/) {
		$name=(split /\s+/,$_)[0];
		$name=~s/>//;
		#print "$name\n";
	}
	else {$seq{$name}.=$_;}
}

foreach my $key (keys %seq) {
	if ($seq{$key}=~/(\wNNNNNNNN\w)/) {
		print OUT "$key\t$1\n";
	}
}

#BP377540,1