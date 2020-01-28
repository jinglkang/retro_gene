#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
open Ka_Ks, "$ARGV[1]" || die '!';
open Spe,"$ARGV[2]" || die"!";
open List,"$ARGV[3]" || die"!";


#<component>
# %cell	2718
#   Hs.10056

#Hs.330742       Mm.3285 854.166666666667        282.833333333333        0.160427818759331       0.691690652512553       0.231935791204609

my %ka;
my %ka_site_num;
my %ks;
my %ks_site_num;
my %ka_ks;

#Hs.315167       0       7       0
#Hs.502004       0       4       0

my %new_exon;
while (<List>) {
	chomp;
	my @infor=split;
	$new_exon{$infor[0]}=$infor[1];
}


while (<Ka_Ks>) {
	chomp;
	my @infor=split;
	my $name=$infor[0];
	$ka{$name}=$infor[4];
	$ks{$name}=$infor[5];
	$ka_site_num{$name}=$infor[2];
	$ks_site_num{$name}=$infor[3];
	$ka_ks{$name}=$infor[6];
}
close Ka_Ks;

my %spe;
while (<Spe>) {
	chomp;
	my @infor=split;
	$spe{$infor[0]}=$infor[1];
}

my $function;
my %total_ka_site;
my %total_ka_site_new;
my %total_ks_site;
my %total_ks_site_new;
my %total_ka;
my %total_ka_new;
my %total_ks;
my %total_ks_new;
my %total_spe;
my %total_spe_new;
my %gene_num;
my %gene_num_new;

while (<IN>) {
	chomp;
	my @infor=split;
		if (/^</) {next;}
	if (/^\s%(.*)\t/) {
		$function=$1;
		#$total_ka_site=0;$total_ks_site=0;$total_ka=0;$total_ks=0;
		next;
	}
	$_=~s/\s//g;
	if (!exists $ka_site_num{$_}) {next;}
	if (!exists $spe{$_}) {next;}
	if (!exists $new_exon{$_}) {next;}

	if ($new_exon{$_}==0) {
	$gene_num{$function}++;
	$total_spe{$function}+=$spe{$_};
	$total_ka_site{$function}+=$ka_site_num{$_};
	$total_ks_site{$function}+=$ks_site_num{$_};
	$total_ka{$function}+=$ka_site_num{$_}*$ka{$_};
	$total_ks{$function}+=$ks_site_num{$_}*$ks{$_};
	}
	elsif($new_exon{$_}>0){
	$gene_num_new{$function}++;
	$total_spe_new{$function}+=$spe{$_};
	$total_ka_site_new{$function}+=$ka_site_num{$_};
	$total_ks_site_new{$function}+=$ks_site_num{$_};
	$total_ka_new{$function}+=$ka_site_num{$_}*$ka{$_};
	$total_ks_new{$function}+=$ks_site_num{$_}*$ks{$_};

	
	}
	else{die "!!!";}
}

my @keys_sort_by_value= sort by_value keys %total_ks;

foreach my $key (@keys_sort_by_value) {
	print "$key\t",($total_ka{$key}/$total_ka_site{$key})/($total_ks{$key}/$total_ks_site{$key});
	print "\t", ($total_ka_new{$key}/$total_ka_site_new{$key})/($total_ks_new{$key}/$total_ks_site_new{$key}),"\t";
	print $total_spe{$key}/$gene_num{$key},"\t";
	print $total_spe_new{$key}/$gene_num_new{$key},"\t";
	print "$gene_num{$key}\t$gene_num_new{$key}\n";
}

sub by_value {
	($total_ka{$a}/$total_ka_site{$a})/($total_ks{$a}/$total_ks_site{$a}) <=> ($total_ka{$b}/$total_ka_site{$b})/($total_ks{$b}/$total_ks_site{$b})  
   }
