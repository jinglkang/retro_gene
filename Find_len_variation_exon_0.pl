#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
open Change,"$ARGV[1]" || die"!";
#open List, "$ARGV[2]"||die '!';
open OUT, ">$ARGV[2]"||die '!';

#>>>     DA196784,2
#AF357013,2      NM_014839       +       99474315        99474444        130

#C04310,2        NM_000014       +       9123957 9124048 92      low     0.793650793650794       1       126

my %hash;
while (<Change>) {
	chomp;
	my @infor=split;
	$hash{$infor[0]}=$_;
}
close Change;

#>>>     AK056852,1
#AK056852,1      NM_000014       -       9109689 9109923 235
#my $name;
#my %rel;
#while (<List>) { #merge在一起的exon用其中一个代表
#	chomp;
#	my @infor=split;
#	if (/^>>>/) {
#		$name=$infor[1];
#	}
#	else{$rel{$infor[0]}=$name;}
#
#}

my $tmp;
my $tag;
while (<IN>) {
	chomp;
	
	my @infor=split;
	if (/^>>>/) {$tmp=$_;$tag=1;}
	else{
		if (!exists $hash{$infor[0]}) {print ">>>>>>>>>>>>wrong!!!!!\t",$infor[0],"\n";exit;}
		if ($tag==1) {print OUT "$tmp\n";$tag=0;}
		print OUT "$hash{$infor[0]}\n";
		}
}