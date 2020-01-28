#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
open Ka_Ks, "$ARGV[1]" || die '!';
open Spe, "$ARGV[2]"||die '!';
open List, "$ARGV[3]"||die '!';


#Hs.100058       Mm.250414       Hs.100058_Mm.250414        2    1   408.0  1308.0   0.7255  5.7861  0.0369 0.0336 +- 0.0052 0.9095 +- 0.1218
#																										9		

#Hs.315167       0       7       0
#Hs.502004       0       4       0
my %new_exon_num;
while (<List>) {
	chomp;
	my @infor=split;
	$new_exon_num{$infor[0]}=$infor[1];
}

my %ka;
my %ks;
my %ka_ks;

while (<Ka_Ks>) {
	chomp;
	my @infor=split;
	my $name=$infor[0];
	$ka{$name}=$infor[10];
	$ks{$name}=$infor[13];
	$ka_ks{$name}=$infor[9];
}
close Ka_Ks;

my %spe;
while (<Spe>) {
	chomp;
	my @infor=split;
	$spe{$infor[0]}=$infor[1];
}


my $function;
my %total_ka;
my %total_ks;
my %total_ka_ks;
my %total_spe;
my %gene_num;
my %total_new_exon_num;


#<component>
# %cell	2718
#   Hs.10056


while (<IN>) {
	chomp;
	my @infor=split;
		if (/^</) {next;}
	if (/^\s%(.*)\t/) {
		$function=$1;
		next;
	}
	$_=~s/\s//g;
	if (!exists $ka{$_}) {next;}
	if (!exists $spe{$_}) {next;}

$total_ka{$function}+=$ka{$_};
$total_ks{$function}+=$ks{$_};
$total_ka_ks{$function}+=$ka_ks{$_};
$total_spe{$function}+=$spe{$_};
$total_new_exon_num{$function}+=$new_exon_num{$_};
$gene_num{$function}++;

}


foreach my $key (keys %gene_num) {
	print "$key\t$gene_num{$key}\t$total_new_exon_num{$key}\t",$total_new_exon_num{$key}/$gene_num{$key},"\t",$total_ka{$key}/$gene_num{$key},"\t", $total_ks{$key}/$gene_num{$key},"\t", $total_ka_ks{$key}/$gene_num{$key},"\t",$total_spe{$key}/$gene_num{$key},"\n";
}





#my @keys_sort_by_value= sort by_value keys %total_ks;
#
#foreach my $key (@keys_sort_by_value) {
#	print "$key\t",($total_ka{$key}/$total_ka_site{$key})/($total_ks{$key}/$total_ks_site{$key});
#	print "\t", ($total_ka_new{$key}/$total_ka_site_new{$key})/($total_ks_new{$key}/$total_ks_site_new{$key}),"\t";
#	print $total_spe{$key}/$gene_num{$key},"\t";
#	print $total_spe_new{$key}/$gene_num_new{$key},"\t";
#	print "$gene_num{$key}\t$gene_num_new{$key}\n";
#}
#
#sub by_value {
#	($total_ka{$a}/$total_ka_site{$a})/($total_ks{$a}/$total_ks_site{$a}) <=> ($total_ka{$b}/$total_ka_site{$b})/($total_ks{$b}/$total_ks_site{$b})  
#   }
