#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
open List,"$ARGV[1]" || die"!";


#Hs.315167       0       7       0

my %hash;
while (<IN>) {
	chomp;
	my @infor=split;
	$hash{$infor[0]}=$infor[1];
}

#>drg    8842
#Hs.469728
#Hs.16695


my %total_num;
my %old_gene_num;
my %new_gene_num;
my $all_total;
my $all_old;
my $all_new;
my %tag;
my $name;

while (<List>) {
	chomp;
	my @infor=split;
	if (/^>/) {
		#$name=$1;
		$name=$infor[0];$name=~s/>//;
		}
	else{
		if (!exists $hash{$infor[0]}) {next;}
		if (!exists $tag{$infor[0]}) {
			$all_total++;
			if ($hash{$infor[0]}==0) {$all_old++;}
			if ($hash{$infor[0]}>0) {$all_new++;}
			$tag{$infor[0]}=1;
		}

		
		$total_num{$name}++;
		if ($hash{$infor[0]}==0) {$old_gene_num{$name}++;}
		if ($hash{$infor[0]}>0){$new_gene_num{$name}++;}
	}
}

foreach my $key (keys %total_num) {
	print "$key\t$total_num{$key}\t$old_gene_num{$key}\t$new_gene_num{$key}\t$all_total\t$all_old\t$all_new\n";
}