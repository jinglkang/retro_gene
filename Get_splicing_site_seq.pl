#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die "$!";
open Seq, "$ARGV[1]" || die "!";
my $flanking_len=$ARGV[2];
open OUT, ">$ARGV[3]" || die "!";

my $name;
my %seq;
while (<Seq>) {
	chomp;
	if (/^>/) {
		
		my @infor=split;
		$name=$infor[0];
		$name=~s/>//;
	}
	else {$seq{$name}.=$_;}
}
close Seq;

#BM714439,3      chr1    -       2526813 2526938
#DA448757,3      chr1    +       17296168        17296229

my %left;
my %right;
while (<IN>) {
	chomp;
	my @infor=split;
	if ($infor[-1]+$flanking_len > length($seq{$infor[1]}) or $infor[-2]-$flanking_len<=0) {
		print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$infor[0]\t$infor[1]\t$infor[-2]\t$infor[-1]\t",length($seq{$infor[1]}),"\n";
	}
	if ($infor[2] eq '+') {
		$left{$infor[0]}=uc(substr($seq{$infor[1]}, $infor[-2]-$flanking_len-1,$flanking_len));
		$right{$infor[0]}=uc(substr($seq{$infor[1]},$infor[-1]+1-1,$flanking_len));
	}
	else
	{
		my $tmp_left=uc(substr($seq{$infor[1]}, $infor[-2]-$flanking_len-1,$flanking_len));
		my $tmp_right=uc(substr($seq{$infor[1]},$infor[-1]+1-1,$flanking_len));
		
	$tmp_left=~tr/ATCGatcg/TAGCtagc/; $right{$infor[0]}=reverse $tmp_left;
	$tmp_right=~tr/ATCGatcg/TAGCtagc/; $left{$infor[0]}=reverse $tmp_right;


	}
}

foreach my $key (keys %left) {
	print OUT "$key\t$left{$key}\t$right{$key}\n";
}