#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die "$!";
open List,"$ARGV[1]" ||die "!";
open TMP,">$ARGV[0].tmp"||die "!";
open OUT,">$ARGV[2]" || die"$!";
open OUT2, ">$ARGV[3]" || die "!";

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
		if(@infor==1){
			next;
		}
		if (!exists $list{$id}) {next;}
		$pos+=$infor[0];
		if ($infor[1]>=100 && $infor[2]==0) {
			print TMP $start+$pos,"\t",$start+$pos+$infor[1]-1,"\t$infor[1]\t$chr\t$id\t$chain_start\t$chain_end\n";
		}
		elsif ($infor[1]>=50 && $infor[2]>=50)
			{print TMP $start+$pos,"\t",$start+$pos+$infor[1]-1,"\t$infor[1]\t$chr\t$id\t$chain_start\t$chain_end\n";
			 print OUT2 "$chr\t",$start+$pos,"\t",$start+$pos+$infor[1]-1,"\t$infor[1]\t$chr\t$id\t$chain_start\t$chain_end\n";
			}
		$pos+=$infor[1];
		}
}
close TMP;

open TMP ,"$ARGV[0].tmp"||die '!';
#98374   99409   1036    chr1    1       96118   246871250
#101451  102011  561     chr1    1       96118   246871250
my %tag;
my $tag2=0;
my $tmp;
my %chr;
while (<TMP>) {
	chomp;
	my @infor=split;
	$id=$infor[4];
	$chr{$id}=$infor[3];
	if (!exists $tag{$id}) {
		if($tag2==1){print OUT "$tmp\t$id\n";}
		$tag{$id}=1;
		print OUT "$chr{$id}\t$infor[5]\t",$infor[0]-1,"\t$id\n";
		print OUT "$chr{$id}\t",$infor[1]+1,"\t";
		$tag2=1;
		$tmp=$infor[-1];
	}
	else{
		print OUT $infor[0]-1,"\t$id\n";
		print OUT "$chr{$id}\t",$infor[1]+1,"\t";
		#print ">>>>>>>>>$tmp\n";
	}
}
print OUT "$tmp\t$id\n";
