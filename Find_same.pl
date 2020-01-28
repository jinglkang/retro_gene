#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open List1,"$ARGV[0]" || die"$!";#list1<lsit2
open List2,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";
my %hash;
while (<List1>) {
		
        chomp;
		my @infor=split;
        $hash{$infor[0]}=$_;
}

while (<List2>) {
        chomp;
		my @infor=split;
        if (exists $hash{$infor[0]}) {
                print OUT $_."\n";
        }
}
