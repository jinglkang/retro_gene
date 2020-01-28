#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Exon,"$ARGV[0]" || die"!";
open Cdd_Pfam,"$ARGV[1]" || die"!";
open Pfam_GO,"$ARGV[2]" || die"!";

#BP348476,1      53      1       53      102     158     731     39.1    6e-05   18/59   30      gnl|CDD|40965
#BX344012,2      46      1       45      147     192     206     35.4    8e-04   17/46   36      gnl|CDD|40367

#gnl|CDD|40775 pfam00694
#gnl|CDD|45378 pfam05478
#gnl|CDD|47358 smart00002

#!Uses Interpro2Go by Nicola Mulder, Hinxton
#!
#Pfam:PF00001 7tm_1 > GO:rhodopsin-like receptor activity ; GO:0001584
#Pfam:PF00001 7tm_1 > GO:G-protein coupled receptor protein signaling pathway ; GO:0007186

#SMART:SM00003 NH > GO:neurohypophyseal hormone activity ; GO:0005185
my %go_of_pfam;
my $name;
while (<Pfam_GO>) {
	chomp;
	if (/^!/) {next;}
	if (/^Pfam:(\w+)/) {
		$name=$1;
		$name=~s/PF/pfam/;
		my @infor=split /;/,$_;
		$infor[-1]=~s/\sGO://;
		$go_of_pfam{$name}.="$infor[-1]\t";
	}
	if (/^SMART:(\w+)/) {
		$name=$1;
		$name=~s/SM/smart/;
		my @infor=split /;/,$_;
		$infor[-1]=~s/\sGO://;
		$go_of_pfam{$name}.="$infor[-1]\t";
		#print "$name\t$go_of_pfam{$name}\n";
#		exit;
	}
}

my %pfam_of_cdd;
while (<Cdd_Pfam>) {
	chomp;
	my @infor=split;
	$pfam_of_cdd{$infor[0]}=$infor[1];
}
close Cdd_Pfam;

my %cdd_of_exon;
while (<Exon>) {
	chomp;
	my @infor=split;
	$cdd_of_exon{$infor[0]}=$infor[-1];
	if (!exists $pfam_of_cdd{$infor[-1]}) {next;}
	if (!exists $go_of_pfam{$pfam_of_cdd{$infor[-1]}}) {next;}
	print "$infor[0]\t$go_of_pfam{$pfam_of_cdd{$infor[-1]}}\n";
}
