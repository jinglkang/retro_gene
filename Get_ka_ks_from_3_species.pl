#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open H_M,"$ARGV[0]" || die"!";
open H_C,"$ARGV[1]" || die"!";
open M_C,"$ARGV[2]" || die"!";
open List,"$ARGV[3]" || die"!";

#Hs.100299_NM_001038107     2    1   723.5  2030.5   0.3871  4.0081  0.1709 0.0567 +- 0.0055  0.3319 +- 0.0279

my %ka_ks_of_hc;
my %ka_ks_of_mc;
my %ka_of_hc;
my %ka_of_mc;

while (<H_C>) {
	chomp;
	my @infor=split;
	if (!defined $infor[7] ) {next;}
	my $name=(split /_/,$infor[0])[0];
	if (/^Hs/) {
	$ka_ks_of_hc{$name}=$infor[7];
	$ka_of_hc{$name}=$infor[8];
	}
	
}
close H_C;

while (<M_C>) {
	chomp;
	my @infor=split;
	#print ">>>>>>";
	if (!defined $infor[7] ) {next;}
	my $name=(split /_/,$infor[0])[0];
	if (/^Mm/) {
		$ka_ks_of_mc{$name}=$infor[7];
		$ka_of_mc{$name}=$infor[8];
	}
	
}
close H_C;

#Hs.100058       Mm.250414       Hs.100058_Mm.250414        2    1   408.0  1308.0   0.7255  5.7861  0.0369 0.0336 +- 0.0052 0.9095 +- 0.1218
my %homo;
my %ka_ks_of_hm;
my %ka_of_hm;
while (<H_M>) {
	chomp;
	my @infor=split;
	$homo{$infor[0]}=$infor[1];
	$ka_ks_of_hm{$infor[0]}=$infor[9];
	$ka_of_hm{$infor[0]}=$infor[10];
}
close H_M;

#Hs.315167       0       8       0

my %gene_num;
my %total_ka_ks;
my %total_ka;
my %total_ks;
while (<List>) {
	chomp;
	my @infor=split;
	if (!exists $ka_ks_of_hm{$infor[0]}) {next;}
	if (!exists $homo{$infor[0]}) {next;}
	if (!exists $ka_ks_of_hc{$infor[0]}) {next;}
	if (!exists $ka_ks_of_mc{$homo{$infor[0]}}) {next;}
	if ($infor[1]==0) {
		$total_ka_ks{"old_of_hc"}+=$ka_ks_of_hc{$infor[0]};
		$total_ka{"old_of_hc"}+=$ka_of_hc{$infor[0]};
		$gene_num{"old_of_hc"}++;
		$total_ka_ks{"old_of_mc"}+=$ka_ks_of_mc{$homo{$infor[0]}};
		$total_ka{"old_of_mc"}+=$ka_of_mc{$homo{$infor[0]}};
		$gene_num{"old_of_mc"}++;
		$total_ka_ks{"old_of_hm"}+=$ka_ks_of_hm{$infor[0]};
		$total_ka{"old_of_hm"}+=$ka_of_hm{$infor[0]};
		$gene_num{"old_of_hm"}++;
	}
	elsif($infor[1]>=1){
		$total_ka_ks{"new_of_hc"}+=$ka_ks_of_hc{$infor[0]};
		$total_ka{"new_of_hc"}+=$ka_of_hc{$infor[0]};
		$gene_num{"new_of_hc"}++;
		$total_ka_ks{"new_of_mc"}+=$ka_ks_of_mc{$homo{$infor[0]}};
		$total_ka{"new_of_mc"}+=$ka_of_mc{$homo{$infor[0]}};
		$gene_num{"new_of_mc"}++;
		$total_ka_ks{"new_of_hm"}+=$ka_ks_of_hm{$infor[0]};
		$total_ka{"new_of_hm"}+=$ka_of_hm{$infor[0]};
		$gene_num{"new_of_hm"}++;

	}
}
close List;

foreach my $key (keys %total_ka_ks) {
	print "$key\t$gene_num{$key}\t",$total_ka_ks{$key}/$gene_num{$key},"\t",$total_ka{$key}/$gene_num{$key},"\n";
}