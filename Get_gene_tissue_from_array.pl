#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open Ch1,"$ARGV[1]"||die '!';
open Ch2, "$ARGV[2]"||die '!';
open List1,"$ARGV[3]"||die '!';
open List2,"$ARGV[4]"||die '!';
open Tis1,"$ARGV[5]"||die '!';
open Tis2,"$ARGV[6]"||die '!';

my %exon_of_gene;
while (<Ch1>) {
	chomp;
	my @infor=split;
#CB268522,3      NM_001642       +       129510668       129510820       153     major   86.0869565217391        99      115
	$exon_of_gene{$infor[0]}=$infor[1];
}

while (<Ch2>) {
	chomp;
	my @infor=split;
#CB268522,3      NM_001642       +       129510668       129510820       153     major   86.0869565217391        99      115
	$exon_of_gene{$infor[0]}=$infor[1];
}

my %ugid_of_ref;
while (<List1>) {
	chomp;
	my @infor=split;
	$ugid_of_ref{$infor[0]}=$infor[2];
}

while (<List2>) {
	chomp;
	my @infor=split;
	$ugid_of_ref{$infor[0]}=$infor[2];
}

my %tis_of_ugid;
while (<Tis1>) {
	chomp;
	my @infor=split;
	$tis_of_ugid{$infor[0]}=$infor[1];
}

while (<Tis2>) {
	chomp;
	my @infor=split;
	$tis_of_ugid{$infor[0]}=$infor[1];
}

while (<IN>) {
	chomp;
	my @infor=split;
	#BU624639,2      AK035218,2      14.2857142857143
if ((!exists $tis_of_ugid{$ugid_of_ref{$exon_of_gene{$infor[0]}}}) or (!exists $tis_of_ugid{$ugid_of_ref{$exon_of_gene{$infor[1]}}})) {next;}
print "$infor[0]\t$infor[1]\t$ugid_of_ref{$exon_of_gene{$infor[0]}}\t$ugid_of_ref{$exon_of_gene{$infor[1]}}\t$infor[2]\t$infor[3]\t$tis_of_ugid{$ugid_of_ref{$exon_of_gene{$infor[0]}}}\t$tis_of_ugid{$ugid_of_ref{$exon_of_gene{$infor[1]}}}\t",abs($tis_of_ugid{$ugid_of_ref{$exon_of_gene{$infor[1]}}}-$tis_of_ugid{$ugid_of_ref{$exon_of_gene{$infor[0]}}}),"\n";

}