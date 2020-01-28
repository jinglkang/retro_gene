#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
open IN_2,"$ARGV[1]" || die"!";
open Homo1,"$ARGV[2]" || die"!";
open Homo2,"$ARGV[3]"||die '!';
open List,"$ARGV[4]" || die"!";
open List_2,"$ARGV[5]" || die"!";

open Blast_list,"$ARGV[6]"||die '!';
open Blast_list_2,"$ARGV[7]"||die '!';
open Gene,"$ARGV[8]" || die"!";




#BF689635,4      NM_000014       +       9112046 9112087 42      major   99.3150684931507        290     292
#BF690537,3      NM_000014       -       9112603 9112705 103     major   97.6027397260274        285     292

#BQ942264,4      BQ568179,1
#CF121528,3      BY746763,3

my %homo_human;
my %homo_mouse;
while (<Homo1>) {
	chomp;
	my @infor=split;
	$homo_human{$infor[0]}=$infor[5];
	$homo_mouse{$infor[5]}=$infor[0];
}
close Homo1;

while (<Homo2>) {
	chomp;
	my @infor=split;
	$homo_human{$infor[5]}=$infor[0];
	$homo_mouse{$infor[0]}=$infor[5];
}
close Homo2;

my %ugid_of_ref;
while (<List>) {
	#NM_000015       +       Hs.2    108     980
chomp;
my @infor=split;
$ugid_of_ref{$infor[0]}=$infor[2];
}

close List;

while (<List_2>) {
	chomp;
my @infor=split;
$ugid_of_ref{$infor[0]}=$infor[2];
}


my %use;
my %exon_use;
while (<Blast_list>) {
	chomp;
	my @infor=split;
	$exon_use{$infor[0]}=1;
}
close Blast_list;
while (<Blast_list_2>) {
	chomp;
	my @infor=split;
	$exon_use{$infor[0]}=1;
}
close Blast_list;
open Blast_list,"$ARGV[6]"||die '!';
open Blast_list_2,"$ARGV[7]"||die '!';



my %exon_of_ref;
my %total_exon_of_ugid;
my %total_new_exon_of_ugid;
while (<IN>) {
	chomp;
	my @infor=split;
	if (!exists $exon_use{$infor[0]}) {next;}
	$exon_of_ref{$infor[0]}=$infor[1];
	$total_exon_of_ugid{$ugid_of_ref{$infor[1]}}++;
	if (!exists $homo_human{$infor[0]}) {$total_new_exon_of_ugid{$ugid_of_ref{$infor[1]}}++;}
}
close IN;


while (<IN_2>) {
	chomp;
	my @infor=split;
	if (!exists $exon_use{$infor[0]}) {next;}
	$exon_of_ref{$infor[0]}=$infor[1];
	$total_exon_of_ugid{$ugid_of_ref{$infor[1]}}++;
	if (!exists $homo_mouse{$infor[0]}) {$total_new_exon_of_ugid{$ugid_of_ref{$infor[1]}}++;}

}


while (<Blast_list>) {
	chomp;
	my @infor=split;
	$use{$ugid_of_ref{$exon_of_ref{$infor[0]}}}=1;
	#print ">>>$infor[0]\t$exon_of_ref{$infor[0]}\t$ugid_of_ref{$exon_of_ref{$infor[0]}}\t$use{$ugid_of_ref{$exon_of_ref{$infor[0]}}}\n";exit;

}
close Blast_list;
while (<Blast_list_2>) {
	chomp;
	my @infor=split;
	$use{$ugid_of_ref{$exon_of_ref{$infor[0]}}}=1;
}

#NM_020979       NM_018825       Hs.489448       Mm.277333
while (<Gene>) {
	chomp;
	my @infor=split;
	if (!exists $use{$infor[2]}) {next;}
	if (!exists $use{$infor[3]}) {next;}
	if (!exists $total_new_exon_of_ugid{$infor[2]}) {$total_new_exon_of_ugid{$infor[2]}=0;}
	if (!exists $total_new_exon_of_ugid{$infor[3]}) {$total_new_exon_of_ugid{$infor[3]}=0;}
	print "$infor[2]\t$infor[3]\t","$total_new_exon_of_ugid{$infor[2]}\t$total_new_exon_of_ugid{$infor[3]}\t$total_exon_of_ugid{$infor[2]}\t$total_exon_of_ugid{$infor[3]}\t",$total_new_exon_of_ugid{$infor[2]}/$total_exon_of_ugid{$infor[2]},"\t",$total_new_exon_of_ugid{$infor[3]}/$total_exon_of_ugid{$infor[3]},"\t",$total_new_exon_of_ugid{$infor[2]}+$total_new_exon_of_ugid{$infor[3]},"\t",$total_exon_of_ugid{$infor[2]}+$total_exon_of_ugid{$infor[3]},"\t",($total_new_exon_of_ugid{$infor[2]}+$total_new_exon_of_ugid{$infor[3]})/($total_exon_of_ugid{$infor[2]}+$total_exon_of_ugid{$infor[3]}),"\n";


}

