#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
my $name=(split /\//,$ARGV[0])[-1];
my $total;
my $num=$ARGV[1];
while (<IN>) {
	$total++;
}
close IN;

my $index=1;
my $count;
open IN,"$ARGV[0]" || die"!";
while (<IN>) {
	open TMP, ">>$name.$index";
	print TMP $_;
	close TMP;
	$count++;
	if ($count>=$total/$num) {$index++;$count=0;}
}
close IN;

