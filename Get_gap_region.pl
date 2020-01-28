#!/usr/bin/perl 

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die "$!";
open List,"$ARGV[1]" ||die "!";
open Insertion,">$ARGV[2]" || die"$!";

#open Deletion,">$ARGV[1]" || die"$!";


#chain 17408357451 chr1 229974691 + 243304 229800167 chr1 247249719 + 96118 246871250 1
#1474    1071    0
#63      0       4
#575     0       1
#193     100       0

#chr9    1341911 syn
#chr10   14110   syn
#chr19   23089   syn
my %list;
my $start;
my $pos;
my $chain_start;
my $chain_end;
my $chain;
my $id;
my $chr;
while (<List>) {
	chomp;
	my @infor=split;
	$list{$infor[1]}=$infor[1];
	
	#if ($infor[1]==4949) {print ">>>>>>>>>>>>>>>>>>>>>>";}
}
while (<IN>) {
	chomp;
	my @infor=split;
	if (/^chain/) {
		$start=$infor[5];
		$pos=0;
		$chain_start=$infor[5];
		$chain_end=$infor[6];
		$chain=$_;
		$id=$infor[-1];
		$chr=$infor[2];
		
	}
	elsif (/^\d+/) 
	{	
		if (!exists $list{$id}) {next;}
		$pos+=$infor[0];
		if ($infor[1]>=100 and $infor[2]==0) {
			print Insertion "$chr\t",$start+$pos,"\t",$start+$pos+$infor[1]-1,"\t$id\n";
		}
		$pos+=$infor[1];
		}
}
