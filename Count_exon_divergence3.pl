#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open List,"$ARGV[0]" || die"$!";
open Human,"$ARGV[1]" || die"$!";
open Mouse,"$ARGV[2]" || die"$!";

open OUT1, ">$ARGV[3]";
open OUT2,">$ARGV[4]";

#BP370723,1      BI652496,2      major   constitutive    123     123
#CD617061,5      BQ770433,1      major   constitutive    96      96

#BG483229,4      AG      GT      AC      GT      +

my %human_left;
my %human_right;
my %mouse_left;
my %mouse_right;

while (<Human>) {
	chomp;
	my @infor=split;
	$human_left{$infor[0]}=uc($infor[1]);
	$human_right{$infor[0]}=uc($infor[2]);
}
close Human;

while (<Mouse>) {
	chomp;
	my @infor=split;
	$mouse_left{$infor[0]}=uc($infor[1]);
	$mouse_right{$infor[0]}=uc($infor[2]);
}
close Mouse;
while (<List>) {
	chomp;
	my @infor=split;
	#print "$infor[0]\t$human_left{$infor[0]}\t$mouse_left{$infor[0]}\t$human_right{$infor[0]}\t$mouse_right{$infor[0]}\n";
	if (!exists $human_left{$infor[0]} or !exists $mouse_left{$infor[1]}) {next;}
	if (($human_left{$infor[0]} eq $mouse_left{$infor[1]}) && ($human_right{$infor[0]} eq $mouse_right{$infor[1]})) {
		print OUT1 "$_\n";
	}
	else
	{print  OUT2 "$_\n";}
	#last;
}
close List;