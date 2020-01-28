#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
open OUT,">$ARGV[1]" || die"!";


#>>>     DA865069,1
#DA865069,1      NM_001397       +       21350990        21351164        175     low     0.645161290322581       1       155
#BX642912,1      NM_001397       +       21350990        21351137        148     low     0.645161290322581       1       155
#BX472983,1      NM_001397       +       21350990        21351134        145     low     2.58064516129032        4       155
#DA887312,1      NM_001397       +       21350990        21351178        189     low     0.645161290322581       1       155
#DA451750,2      NM_001397       +       21350990        21351131        142     major   69.0322580645161        107     155
#DA452501,1      NM_001397       +       21350990        21351145        156     low     0.645161290322581       1       155


my %exon_count;
my %exon_infor;
my %exon_len;
while (<IN>) {
	chomp;
	my @infor=split;
	if (/^>/) {next;}
	if ($infor[5]<=30) {next;}
	$exon_count{$infor[0]}=$infor[8];
	$exon_infor{$infor[0]}="$infor[1]\t$infor[3]\t$infor[4]";
	$exon_len{$infor[0]}=$infor[5];
}
close IN;

open IN,"$ARGV[0]" || die"!";

my $name;
my %total_exon_count;
my %total_exon_count_removed_low;
my %total_low_exon_count;
my %list_ture_var;
my %list_low;
while (<IN>){
	chomp;
	my @infor=split;
	if (/^>>>/) {$name=$infor[1];}
	else{
		if ($infor[5]<=30) {next;}
		$total_exon_count{$name}++;
		if ($infor[8]>5) {$total_exon_count_removed_low{$name}++;$list_ture_var{$name}.="$infor[0]\t";}
		else{$list_low{$name}.="$infor[0]\t";$total_low_exon_count{$name}++;}
	}
}
close IN;

foreach my $key (keys %total_exon_count) {
		if ($total_exon_count{$key}==1) {
		if(!exists $total_exon_count_removed_low{$key}){
			my @tmp=split /\t/,$list_low{$key};
			foreach my $item (@tmp) {
				print OUT "$item\tNO_len_var_but_low\t$exon_infor{$item}\n";
			}
			
			}
		
		elsif(exists $total_exon_count_removed_low{$key} and $total_exon_count_removed_low{$key}==1) {
			my @tmp=split /\t/,$list_ture_var{$key};
			foreach my $item (@tmp) {
				print OUT "$item\tNO_len_var_No_low\t$exon_infor{$item}\n";
			}
			
			}
		else{print "Wrong!!!!\t3\n";}

	}
	elsif($total_exon_count{$key}>1)
	{
		if (exists $total_exon_count_removed_low{$key} and $total_exon_count_removed_low{$key}==1) {
			my @tmp_ture=split /\t/, $list_ture_var{$key};
			foreach my $item (@tmp_ture) {
				print OUT "$item\tNO_var_removed_low\t$exon_infor{$item}\t$total_low_exon_count{$key}\n";
			}
			
			my @tmp=split /\t/, $list_low{$key};
			foreach my $item (@tmp) {
				print OUT "$item\tlow\t$exon_infor{$item}\n";
			}
			}
			elsif (exists $total_exon_count_removed_low{$key} and $total_exon_count_removed_low{$key}>1){
				my @tmp=split /\t/,$list_ture_var{$key};
				
				if (!exists $total_low_exon_count{$key}) {
				foreach my $item (@tmp) {
					print OUT "$item\tVar_ture_no_low\t$exon_infor{$item}\t0\n";
				}
					
				}
				elsif(exists $total_low_exon_count{$key}){
				foreach my $item (@tmp) {
					print OUT "$item\tVar_ture_but_with_low\t$exon_infor{$item}\t$total_low_exon_count{$key}\n";
				}
					my @tmp=split /\t/,$list_low{$key};
					foreach my $item (@tmp) {
						print OUT "$item\tlow\t$exon_infor{$item}\n";
					}
				}
			
			}
			elsif(!exists $total_exon_count_removed_low{$key}){
				my @tmp=split /\t/,$list_low{$key};
					foreach my $item (@tmp) {
					print OUT "$item\tlow\t$exon_infor{$item}\n";
				}
				}
			else {print "Wrong!!!!!!!!!\t1\n";}
	}
	else{print "Wrong!!!!!!!!!!!!\t2\n";}
}