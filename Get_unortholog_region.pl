#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die "$!";
open List,"$ARGV[1]" ||die "!";
open OUT, ">$ARGV[2]" || die "!";
open TMP,">$ARGV[0].find.unorotholg.tmp"||die "!";
my %list;
my $start;
my $pos;
my $chain_start;
my $chain_end;
my $chain;
my $id;
my $chr;
my $chr_size;

while (<List>) {
	chomp;
	my @infor=split;
	$list{$infor[1]}=$infor[2];
	
	#if ($infor[1]==4949) {print ">>>>>>>>>>>>>>>>>>>>>>";}
}
while (<IN>) {
	chomp;
	my @infor=split;
	if (/^chain/) {
		$id=$infor[-1];
		if (!exists $list{$id}) {next;}
		if ($list{$id} eq 'top') {
		$start=$infor[5];
		$pos=0;
		$chain_start=$infor[5];
		$chain_end=$infor[6];
		$chain=$_;
		$chr=$infor[2];
		$chr_size=$infor[3];
		print TMP "$chr\t$chain_start\t$chain_end\t$id\t$chr_size\n";
	}
	}
}
close TMP;
system ("sort -k1,1 -k2,2n -k3,3n $ARGV[0].find.unorotholg.tmp>$ARGV[0].find.unorotholg.tmp.sort");
unlink ("$ARGV[0].find.unorotholg.tmp");
open TMP ,"$ARGV[0].find.unorotholg.tmp.sort"||die '!';

my %tag;
my $tag2=0;
my $tmp;
my %chr;
#chr1   98374   99409   id    chr_size
#98374   99409   1036    chr1    1       96118   246871250

while (<TMP>) {
	chomp;
	my @infor=split;
	$id=$infor[3];
	$chr=$infor[0];
	if (!exists $tag{$chr}) {
		if($tag2==1){print OUT "$tmp\n";}
		$tag{$chr}=1;
		print OUT "$chr\t0\t",$infor[1]-1,"\n";
		print OUT "$chr\t",$infor[2]+1,"\t";
		$tag2=1;
		$tmp=$infor[-1];
	}
	else{
		print OUT $infor[1]-1,"\n";
		print OUT "$chr\t",$infor[2]+1,"\t";
		#print ">>>>>>>>>$tmp\n";
	}
}
print OUT "$tmp\n";
