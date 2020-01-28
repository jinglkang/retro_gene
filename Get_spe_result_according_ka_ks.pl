#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open KaKs,"$ARGV[0]" || die"!";
open List,"$ARGV[1]" || die"!";
open Spe,"$ARGV[2]" || die"!";

#Hs.330742       Mm.3285 854.166666666667        282.833333333333        0.160427818759331       0.691690652512553       0.231935791204609
#							2							3					4							5
#Hs.315167       0       7       0
#Hs.502004       0       4       0

#Hs.528651       0.520534037670949       1194.72784810127        43812.5 4327.425        20

my %new_exon_number;
while (<List>) {
	chomp;
	my @infor=split;
	$new_exon_number{$infor[0]}=$infor[1];
}
close List;

my %spe;
while (<Spe>) {
	chomp;
	my @infor=split;
	$spe{$infor[0]}=$infor[1];
}

my $bin=500;
my $small=0.05;
my %old_gene_num;
my %total_spe_of_old;
my %new_gene_num;
my %total_spe_of_new;
my %group_num;
my %ka_of_old;
my %ka_of_old_site;
my %ks_of_old;
my %ks_of_old_site;
my %ka_of_new;
my %ka_of_new_site;
my %ks_of_new;
my %ks_of_new_site;
my $name;
while (<KaKs>) {
	chomp;
	my @infor=split;
	if (!exists $spe{$infor[0]}) {next;}
	if (!exists $new_exon_number{$infor[0]}) {next;}
	for (my $i=0;$i<=$bin ;$i++) {
		
		if ($infor[6]>=$i*$small and $infor[6]<($i+1)*$small) {
			my $left=$i*$small;my $right=($i+1)*$small;
			$name="$left\t$right";
			$group_num{$name}++;
			if ($new_exon_number{$infor[0]}==0) 
				{
				$old_gene_num{$name}++; 
				$total_spe_of_old{$name}+=$spe{$infor[0]}; 
				$ka_of_old{$name}+=$infor[2]*$infor[4];
				$ks_of_old{$name}+=$infor[3]*$infor[5];
				$ka_of_old_site{$name}+=$infor[2];
				$ks_of_old_site{$name}+=$infor[3];
				}
			elsif($new_exon_number{$infor[0]}>1)
				{
				$new_gene_num{$name}++; 
				$total_spe_of_new{$name}+=$spe{$infor[0]}; 
				$ka_of_new{$name}+=$infor[2]*$infor[4]; 
				$ks_of_new{$name}+=$infor[3]*$infor[5];
				$ka_of_new_site{$name}+=$infor[2];
				$ks_of_new_site{$name}+=$infor[3];
				}
		}
	}
}

foreach my $key (sort keys %group_num) {
	if ($group_num{$key}<100) {next;}
	if (!exists $old_gene_num{$key}) {$old_gene_num{$key}=0;};
	if (!exists $new_gene_num{$key}) {$new_gene_num{$key}=0;};
	if($old_gene_num{$key}==0 or $new_gene_num{$key}==0) {
		print "$key\t$group_num{$key}\t$new_gene_num{$key}\t$old_gene_num{$key}\n";
		next;
	}
	#print "$key\t$group_num{$key}\t$new_gene_num{$key}\t$old_gene_num{$key}\t",$total_spe_of_new{$key}/$new_gene_num{$key},"\t", $ka_of_new{$key}/$ka_of_new_site{$key},"\t",$ks_of_new{$key}/$ks_of_new_site{$key},"\t",($ka_of_new{$key}/$ka_of_new_site{$key})/($ks_of_new{$key}/$ks_of_new_site{$key}),"\t",$total_spe_of_old{$key}/$old_gene_num{$key},"\t",$ka_of_old{$key}/$ka_of_old_site{$key},"\t",$ks_of_old{$key}/$ks_of_old_site{$key},"\t",($ka_of_old{$key}/$ka_of_old_site{$key})/($ks_of_old{$key}/$ks_of_old_site{$key}),"\n";
	print "$key\t$group_num{$key}\t$new_gene_num{$key}\t$old_gene_num{$key}\t",$total_spe_of_new{$key}/$new_gene_num{$key},"\t", $total_spe_of_old{$key}/$old_gene_num{$key},"\t",($ka_of_new{$key}/$ka_of_new_site{$key})/($ks_of_new{$key}/$ks_of_new_site{$key}),"\t",($ka_of_old{$key}/$ka_of_old_site{$key})/($ks_of_old{$key}/$ks_of_old_site{$key}),"\n";

}