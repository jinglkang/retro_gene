#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open Homo,"$ARGV[1]" || die"$!";
open List,"$ARGV[2]" || die"$!";
open Blast_list,"$ARGV[3]"||die '!';


#BF689635,4      NM_000014       +       9112046 9112087 42      major   99.3150684931507        290     292
#BF690537,3      NM_000014       -       9112603 9112705 103     major   97.6027397260274        285     292

#BQ942264,4      BQ568179,1
#CF121528,3      BY746763,3

my %homo;
while (<Homo>) {
	chomp;
	my @infor=split;
	$homo{$infor[0]}=$infor[0];
}
close Homo;

my %ugid_of_ref;
while (<List>) {
	#NM_000015       +       Hs.2    108     980
chomp;
my @infor=split;
$ugid_of_ref{$infor[0]}=$infor[2];
}
close List;
my %exon_of_ref;
my %total_exon_of_ugid;
my %total_new_exon_of_ugid;
while (<IN>) {
	chomp;
	my @infor=split;
	$exon_of_ref{$infor[0]}=$infor[1];
	$total_exon_of_ugid{$ugid_of_ref{$infor[1]}}++;
	if (exists $homo{$infor[0]}) {$total_new_exon_of_ugid{$ugid_of_ref{$infor[1]}}++;}
}
close IN;

my %use;
while (<Blast_list>) {
	chomp;
	my @infor=split;
	if (!exists $exon_of_ref{$infor[0]}) {next;}
	$use{$ugid_of_ref{$exon_of_ref{$infor[0]}}}=1;
}

foreach my $key (keys %total_exon_of_ugid) {
	if (!exists $use{$key}) {next;}
	if (!exists $total_new_exon_of_ugid{$key}) {$total_new_exon_of_ugid{$key}=0;}
	print "$key\t$total_new_exon_of_ugid{$key}\t$total_exon_of_ugid{$key}\t",$total_new_exon_of_ugid{$key}/$total_exon_of_ugid{$key},"\n";
}
