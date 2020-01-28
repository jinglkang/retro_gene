#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open List1,"$ARGV[0]" || die"$!";
open List2,"$ARGV[1]" || die"$!";
open OUT,">$ARGV[2]" || die"$!";

#22217   chr1    227255256       227259142
#799     chr1    2616418 2620428
#13625   chr1    131158933       131161956

#chr1    77640   77776
#chr1    77777   78631
#chr1    83752   84794
my %hash_start;
my %hash_end;

while (<List2>) {
	chomp;
	my @infor=split;
	$hash_start{$_}=$infor[1];
	$hash_end{$_}=$infor[2];
}
close List2;

while (<List1>) {
	chomp;
	my @infor=split;
	
	#print ">>>>>>>>>>>>>>>>>\n";
	foreach my $key (keys %hash_start) {
		my $chr=(split /\s+/, $key)[0];
		
		if (($chr eq $infor[1]) && $infor[2]>=$hash_start{$key} && $infor[3]<=$hash_end{$key}) {
			print OUT $_,"\n";
			last;
		}
	}
}

