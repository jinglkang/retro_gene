#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open Anno,"$ARGV[1]"||die "!";
open List,"$ARGV[2]"|| die "!";



my @tissue_name;
my %measure;

while (<IN>) {
	chomp;
	my %probe;
	my $highist=0;
		my @infor=split;
		for (my $i=1;$i<@infor;$i++) {
			if ($infor[$i]<100) {$infor[$i]=100;}
			$probe[$i]=$infor[$i];
		}
		
		for (my $i=1;$i<@infor;$i++) {
			if ($probe[$i]>$highist) {$highist=$probe[$i];}
		}
			

		for (my $i=1;$i<@infor;$i++) {
			$measure{$infor[0]}+=1-log($probe[$i])/log($highist);
		}
		$measure{$infor[0]}=$measure{$infor[0]}/((scalar @infor)-1);
	
}

my %ugid_of_seq;
while (<List>) {
	chomp;
	#BG618195        Noinfor Hs.2    Noinfor Noinfor
	my @infor=split;
	$ugid_of_seq{$infor[0]}=$infor[2];
}

my %gene_of_probe;
while (<Anno>) {
	chomp;
#	200000_s_at     NM_006445
	my @infor=split;
	$gene_of_probe{$infor[0]}=$infor[1];
}

my %measure_of_ugid;
my %num;
foreach my $key (%measure) {
	if (!exists $gene_of_probe{$key}){next;}
	if (!exists $ugid_of_seq{$gene_of_probe{$key}}){next;}
	$measure_of_ugid{$ugid_of_seq{$gene_of_probe{$key}}}+=$measure{$key};
	$num{$ugid_of_seq{$gene_of_probe{$key}}}++;
}

foreach my $key (keys %measure_of_ugid) {
	print "$key\t",$measure_of_ugid{$key}/$num{$key},"\n";
}