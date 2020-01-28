#!/usr/bin/perl 

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open List,"$ARGV[1]" || die"$!";

open Deletion,">$ARGV[2]" || die"$!";
#open Deletion,">$ARGV[1]" || die"$!";


#chain 17408357451 chr1 229974691 + 243304 229800167 chr1 247249719 + 96118 246871250 1
#1474    1071    0
#63      0       4
#575     0       1
#193     100       0
my %list;
my $start;
my $pos;
my $chimp_pos;
my $chimp_start;
my $chain_start;
my $chain_end;
my $strand;
my $chain;
my $id;

while (<List>) {
	chomp;
	my @infor=split;
	$list{$infor[1]}=$infor[2];
}

while (<IN>) {
	chomp;
	my @infor=split;
	if (/^chain/) {
		$start=$infor[5];
		$chimp_start=$infor[10];
		$pos=0;
		$chimp_pos=0;
		$chain_start=$infor[5];
		$chain_end=$infor[6];
		$strand=$infor[9];
		$chain=$_;
		$id=$infor[-1];

	}
	elsif (/^\d+/) 
	{
		if (!exists $list{$id}) {next;}
		if ($list{$id} eq 'top') {
		$chimp_pos+=$infor[0];
		$pos+=$infor[0];
		if ($infor[1]==0 and $infor[2]>=100) {
			print Deletion $start+$pos-1,"\t",$start+$pos,"\t$infor[2]","\t",$chimp_start+$chimp_pos,"\t$id\t$chain\n";
		}
		$pos+=$infor[1];
		$chimp_pos+=$infor[2];
		#print "$pos\n";
		}
	}
}
