#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open Anno,"$ARGV[1]"||die "!";
open List,"$ARGV[2]"|| die "!";



my @tissue_name;
my %measure;
my %expression;
my %expression_of_exp_tis;
my %max_exp;
my %exp_tis_num;
#my %measure_remove_low;
#my %expression_remove_low;
#my %num_remove_low;
my $debug;
while (<IN>) {
	chomp;
	my %probe;
	my $tag=0;
	my $highist=0;
	if (/^Dataset/) {
		my @infor=split /\t/,$_;
		for (my $i=0; $i<@infor;$i++) {
			$tissue_name[$i]=lc($infor[$i]);
			$tissue_name[$i]=~s/\s+//;
		}
		#last;
	}
	else{
		my @infor=split;
		for (my $i=1;$i<@infor;$i++) {
#			if ($infor[$i]<100) {$infor[$i]=100;}
			
			$probe{$tissue_name[$i]}+=$infor[$i];
		}
		
		foreach my $key (keys %probe) {$probe{$key}=$probe{$key}/2;if ($probe{$key}>200) {$tag=1;}}

if ($tag!=1) {next;} #若无一个tissue的值大于200,则认为这个gene没有检测到表达,去掉不用

$debug++;

		foreach my $key (keys %probe) {if ($probe{$key}>$highist) {$highist=$probe{$key};}}

		$max_exp{$infor[0]}=$highist;

		foreach my $key (keys %probe) {

			$measure{$infor[0]}+=1-log($probe{$key})/log($highist);
			$expression{$infor[0]}+=$probe{$key};
			if ($probe{$key}>200) {$exp_tis_num{$infor[0]}++;$expression_of_exp_tis{$infor[0]}+=$probe{$key};}
			#$measure{$infor[0]}+=1-sqrt($probe{$key})/sqrt($highist);
			#$measure{$infor[0]}+=1-$probe{$key}/$highist;
		}

		$measure{$infor[0]}=$measure{$infor[0]}/(((scalar @infor)-1)/2-1);
		$expression{$infor[0]}=$expression{$infor[0]}/(((scalar @infor)-1)/2);
		$expression_of_exp_tis{$infor[0]}=$expression_of_exp_tis{$infor[0]}/$exp_tis_num{$infor[0]};
		#$exp_tis_num{$infor[0]}=(1-$exp_tis_num{$infor[0]}/(((scalar @infor)-1)/2));

	}
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
my %expression_of_ugid;
my %max_exp_of_ugid;
my %exp_tis_num_of_ugid;
my %expression_of_exp_tis_of_ugid;
my %num;
foreach my $key (keys %measure) {

	if (!exists $gene_of_probe{$key}){next;}
	if (!exists $ugid_of_seq{$gene_of_probe{$key}}){next;}
	$measure_of_ugid{$ugid_of_seq{$gene_of_probe{$key}}}+=$measure{$key};
	$expression_of_ugid{$ugid_of_seq{$gene_of_probe{$key}}}+=$expression{$key};
	$max_exp_of_ugid{$ugid_of_seq{$gene_of_probe{$key}}}+=$max_exp{$key};
	$exp_tis_num_of_ugid{$ugid_of_seq{$gene_of_probe{$key}}}+=$exp_tis_num{$key};
	$expression_of_exp_tis_of_ugid{$ugid_of_seq{$gene_of_probe{$key}}}+=$expression_of_exp_tis{$key};
	$num{$ugid_of_seq{$gene_of_probe{$key}}}++;
}



foreach my $key (keys %measure_of_ugid) {
	print "$key\t",$measure_of_ugid{$key}/$num{$key},"\t",$expression_of_ugid{$key}/$num{$key},"\t",$max_exp_of_ugid{$key}/$num{$key},"\t",$expression_of_exp_tis_of_ugid{$key}/$num{$key},"\t",$exp_tis_num_of_ugid{$key}/$num{$key},"\n";
}
print "$debug\n";
