#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
#open OUT,">$ARGV[1]" || die"$!";
#my $sum;
#my $len;
#my $tag=0;
#while (<IN>) {
#	chomp;
#	if (/^\#/ or /^\n/) {
#		next;
#	}
#	my @infor=split;
#	
#	if (/^chain/) {
##chain 17408357451 chr1 229974691 + 243304 229800167 chr1 247249719 + 96118 246871250 1
#		if ($tag==1) {print "$len\t$sum\n";}
#		$len=$infor[6]-$infor[5];
#		
#		$sum=0;
#		
#	}
#	elsif (/^\d+/) {
#	$sum+=$infor[0]+$infor[1];
#	$tag=1;
#	}
#}



##chain 17408357451 chr1 229974691 + 243304 229800167 chr1 247249719 + 96118 246871250 1
##782     1       0
#my $name;
#my %hash;
#while (<IN>){
#	#chomp;
#	if (/^\#/) {next;}
#
#	my @infor=split;
#	
#	if (/^chain/) {
#		chomp;
#		$name=$_;
#	}
#	else
#	{
#		$hash{$name}.=$_;
#	}
#}
#close IN;
#
#print ">>>>>>>>>>>>>>>>>\n";
#	
#foreach my $key (keys %hash) {
#	#print "$key\n";
#	my $chr=(split /\s+/,$key)[2];
#	print "$chr\n";
#	open TMP, ">>$chr"||die '!';
#	print TMP "$key\n$hash{$key}";
#	close TMP;
#}


while (<IN>) {
	chomp;
	my @infor=split;
	if ($infor[5]>90 && $infor[6]>90) {
	#if ($infor[4]>=50){
		print $_,"\n";
	}
}