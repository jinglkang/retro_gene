#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
open Spe,"$ARGV[1]" || die"!";
open OUT, ">$ARGV[2]"||die '!';

#Hs.521168       1       1       1

#Hs.1	0.1

my %spe;
while (<Spe>) {
	chomp;
	my @infor=split;
	$spe{$infor[0]}=$infor[1];
}
close Spe;

my %hash;
my %num;
while (<IN>) {
	chomp;
	my @infor=split;
	if (!exists $spe{$infor[0]}) {next;}
		#if ($infor[2]<3) {next;}

#	if ($infor[3]>0 && $infor[3]<=0.1) {$infor[3]=0.1;}
#	elsif($infor[3]>0.1 && $infor[3]<=0.2) {$infor[3]=0.2;}
#	elsif($infor[3]>0.2 && $infor[3]<=0.3) {$infor[3]=0.3;}
#	elsif($infor[3]>0.3 && $infor[3]<=0.4) {$infor[3]=0.4;}
#	elsif($infor[3]>0.4 && $infor[3]<=0.5) {$infor[3]=0.5;}
#	elsif($infor[3]>0.5 && $infor[3]<=0.6) {$infor[3]=0.6;}
#	elsif($infor[3]>0.6 && $infor[3]<=1) {$infor[3]=0.7;}
#
#	$hash{$infor[3]}+=$spe{$infor[0]};
#	$num{$infor[3]}++;
print OUT "$infor[1]\t$spe{$infor[0]}\n";
if ($infor[1]>=6) {$infor[1]=6;}
$hash{$infor[1]}+=$spe{$infor[0]};
$num{$infor[1]}++;

}
close IN;

foreach my $key (sort keys %num) {
	print "$key\t$num{$key}\t",$hash{$key}/$num{$key},"\n";
}