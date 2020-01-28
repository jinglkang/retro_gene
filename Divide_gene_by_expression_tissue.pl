#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open Anno,"$ARGV[1]"||die "!";
open List,"$ARGV[2]"|| die "!";

my %ugid_of_seq;
while (<List>) {

	chomp;
	#BG618195        Noinfor Hs.2    Noinfor Noinfor
	my @infor=split;
	$ugid_of_seq{$infor[0]}=$infor[2];
}

my %gene_of_probe;
while (<Anno>) {
	chomp;
#	200000_s_at     NM_006445
	my @infor=split;
	$gene_of_probe{$infor[0]}=$infor[1];
}


my @tissue_name;
my %expression_of_exp_tis;
my %count;
my $debug;

while (<IN>) {
	chomp;
	my %probe;
	my $tag=0;
	my $highist=0;
	if (/^Dataset/) {
		my @infor=split /\t/,$_;
		for (my $i=0; $i<@infor;$i++) {
			$tissue_name[$i]=lc($infor[$i]);
			$tissue_name[$i]=~s/\s+//;
		}
		#last;
	}
	else{
		my @infor=split;
		for (my $i=1;$i<@infor;$i++) {
			$probe{$tissue_name[$i]}+=$infor[$i];
		}
		
#		my $highist=0;
#		my $highist_tissue;
#		foreach my $key (keys %probe) {
#			$probe{$key}=$probe{$key}/2;
#			if ($probe{$key}>$highist) {
#				$highist=$probe{$key};
#				$highist_tissue=$key;
#			}
#		}
#	if ($highist<200) {next;}
#	if (!exists $gene_of_probe{$infor[0]}) {next;}
#	if (!exists $ugid_of_seq{$gene_of_probe{$infor[0]}}) {next;}
#	if (exists $expression_of_exp_tis{$highist_tissue} and $expression_of_exp_tis{$highist_tissue}=~/$ugid_of_seq{$gene_of_probe{$infor[0]}}/) {next;}
#	$expression_of_exp_tis{$highist_tissue}.="$ugid_of_seq{$gene_of_probe{$infor[0]}}\n";
#	$count{$highist_tissue}++;


		foreach my $key (keys %probe) {
			$probe{$key}=$probe{$key}/2;
			if ($probe{$key}>200) {
				$debug++;
				if (!exists $gene_of_probe{$infor[0]}) {next;}
				if (!exists $ugid_of_seq{$gene_of_probe{$infor[0]}}) {next;}
				if (exists $expression_of_exp_tis{$key} and $expression_of_exp_tis{$key}=~/$ugid_of_seq{$gene_of_probe{$infor[0]}}/) {next;}

				$expression_of_exp_tis{$key}.="$ugid_of_seq{$gene_of_probe{$infor[0]}}\n";
				$count{$key}++;
				}
			}
				


	}
}




foreach my $key (keys %expression_of_exp_tis) {
	print ">$key\t$count{$key}\n$expression_of_exp_tis{$key}";
}

print "$debug\n";