#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open IN_2,"$ARGV[1]"||die '!';
open Anno,"$ARGV[2]"||die '!';
open Anno_2,"$ARGV[3]"||die '!';
open List,"$ARGV[4]"||die '!';
open List_2,"$ARGV[5]"||die '!';
open OUT1,">$ARGV[6]"||die '!';
open OUT2,">$ARGV[7]"||die '!';


my %ugid_of_seq_human;
while (<List>) {
	chomp;
	#BG618195        Noinfor Hs.2    Noinfor Noinfor
	my @infor=split;
	$ugid_of_seq_human{$infor[0]}=$infor[2];
}

my %ugid_of_seq_mouse;
while (<List_2>) {
	chomp;
	#BG618195        Noinfor Hs.2    Noinfor Noinfor
	my @infor=split;
	$ugid_of_seq_mouse{$infor[0]}=$infor[2];
}



my %gene_of_probe;
while (<Anno>) {
	chomp;
#	200000_s_at     NM_006445
	my @infor=split;
	$gene_of_probe{$infor[0]}=$infor[1];
}

while (<Anno_2>) {
	chomp;
#	200000_s_at     NM_006445
	my @infor=split;
	$gene_of_probe{$infor[0]}=$infor[1];
}



my @human_tissue_name;
my @mouse_tissue_name;
my %human_name;
my %mouse_name;
while (<IN>) {
	chomp;
	
	if (/^Dataset/) {
		my @infor=split /\t/,$_;
		for (my $i=0; $i<@infor;$i++) {
			$human_tissue_name[$i]=lc($infor[$i]);
			$human_tissue_name[$i]=~s/\s+//;
			$human_name{$human_tissue_name[$i]}=$human_tissue_name[$i];
		}
	}
	last;
}
close IN;

while (<IN_2>) {
	chomp;
	
	if (/^Dataset/) {
		my @infor=split /\t/,$_;
		for (my $i=0; $i<@infor;$i++) {
			$mouse_tissue_name[$i]=lc($infor[$i]);
			$mouse_tissue_name[$i]=~s/\s+//;
			$mouse_name{$mouse_tissue_name[$i]}=$mouse_tissue_name[$i];
		}
	}
	last;
}
close IN_2;


open IN,"$ARGV[0]" || die"$!";
open IN_2,"$ARGV[1]"||die '!';


my $tag_2=0;
while (<IN>){ 
	chomp;
	if (/^Dataset/) {}
else{
		my @infor=split;
		my %probe;
		for (my $i=1;$i<@infor;$i++) {
			$probe{$human_tissue_name[$i]}+=$infor[$i];
		}
		if (!exists $gene_of_probe{$infor[0]} or !exists $ugid_of_seq_human{$gene_of_probe{$infor[0]}}) {next;}
		#print "$infor[0]\n";
		if($tag_2==0){print OUT1 "Dataset\t";}
		if($tag_2==0){foreach my $key(sort keys %probe) {if (exists $human_name{$key} && exists $mouse_name{$key}) {print OUT1 "$key\t";}}}
		if($tag_2==0){print OUT1 "\n";}
		print OUT1 "$ugid_of_seq_human{$gene_of_probe{$infor[0]}}\t";
		foreach my $key (sort keys %probe) {
			if (exists $human_name{$key} && exists $mouse_name{$key}) {
				
				print OUT1 $probe{$key}/2,"\t";
			}
		}
		print OUT1 "\n";
		
		$tag_2=1;
		#last;
	}
}



my $tag=0;
while (<IN_2>){ 
	chomp;
	if (/^Dataset/) {}
	else{
		my @infor=split;
		my %probe;
		for (my $i=1;$i<@infor;$i++) {
			$probe{$mouse_tissue_name[$i]}+=$infor[$i];
		}
		if (!exists $gene_of_probe{$infor[0]} or !exists $ugid_of_seq_mouse{$gene_of_probe{$infor[0]}}) {next;}
		#print "$infor[0]\n";

		if($tag==0){print OUT2 "Dataset\t";}
		if($tag==0){foreach my $key(sort keys %probe) {if (exists $human_name{$key} && exists $mouse_name{$key}) {print OUT2 "$key\t";}}}
		if($tag==0){print OUT2 "\n";}

		print OUT2 "$ugid_of_seq_mouse{$gene_of_probe{$infor[0]}}\t";
		foreach my $key (sort keys %probe) {
			if (exists $human_name{$key} && exists $mouse_name{$key}) {
				print OUT2 $probe{$key}/2,"\t";
			}
		}
		print OUT2 "\n";
		$tag=1;
		#last;
	}
}





#my %measure_of_ugid;
#my %num;
#foreach my $key (%measure) {
#	if (!exists $gene_of_probe{$key}){next;}
#	if (!exists $ugid_of_seq{$gene_of_probe{$key}}){next;}
#	$measure_of_ugid{$ugid_of_seq{$gene_of_probe{$key}}}+=$measure{$key};
#	$num{$ugid_of_seq{$gene_of_probe{$key}}}++;
#}
#
#foreach my $key (keys %measure_of_ugid) {
#	print "$key\t",$measure_of_ugid{$key}/$num{$key},"\n";
#}