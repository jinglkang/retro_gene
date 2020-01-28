#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open Tumor, ">tumor.express.gene.list"||die '!';
open Brain,">brain.express.gene.list" || die"$!";
open Testis,">testis.express.gene.list" || die"$!";
open Total, ">have.data.list"||die "!";

#> 1|Tissue
#bone    0 / 35141
#bone marrow     1 / 146603
#> 1|Developmental Stage
#adult (7 weeks days post natal and older)       64 / 1058998
#juvenile (from 7 to 49 days post natal) 36 / 292233

my %tissue;
my %stage;
my %health;

my $tag;
my $name;

while (<IN>) {
	chomp;
	if (/^>(.*)\|Tissue/) {
		$name=$1;
		$name=~s/\s+//;
		$tag=1;
		next;
	}
	
	if (/^>(.*)\|Developmental/) {
		$name=$1;
		$name=~s/\s+//;
		$tag=2;
		next;
	}

	if (/^>(.*)\|Health/) {
		$name=$1;
		$name=~s/\s+//;
		$tag=3;
		next;
	}

	#print ">$name\n";
	if ($tag==1) {
		my @tmp=split /\t/,$_;
		my $tissue_name=$tmp[0];
		if ($tissue_name=~/brain|ganglia|spinal cord|cerebrum|cerebellum|mesencephalon|pineal gland|prosencephalon/) {
			$tissue_name='brain';
		}
		$tissue{$name."\t".$tissue_name}=int((1000000/(split /\s+/,$tmp[1])[2])*(split /\s+/,$tmp[1])[0]);
		$tissue{$name."\ttotal"}+=$tissue{$name."\t".$tissue_name};
		$tissue{$name."\treal"}+=(split /\s+/,$tmp[1])[0];
		#print $tissue{$name."\t".$tissue_name},"\t",$tissue{$name."\ttotal"},"\n";
		
	}
	elsif($tag==2){
		my @tmp=split /\t/,$_;
		my $stage_name=$tmp[0];
		$stage{$name."\t".$stage_name}=int((1000000/(split /\s+/,$tmp[1])[2])*(split /\s+/,$tmp[1])[0]);
		$stage{$name."\ttotal"}+=$stage{$name."\t".$stage_name};
	}
	elsif ($tag==3)
	{
		my @tmp=split /\t/,$_;
		my $health_name=$tmp[0];
		if ($health_name=~/tumor|chondrosarcoma|glioma|cancer|retinoblastoma/ and !($health_name=~/mixed/)) {
			$health_name='tumor';
		}

		$health{$name."\t".$health_name}=int((1000000/(split /\s+/,$tmp[1])[2])*(split /\s+/,$tmp[1])[0]);
		$health{$name."\ttotal"}+=$health{$name."\t".$health_name};
		$health{$name."\treal"}+=(split /\s+/,$tmp[1])[0];

	}
	else{}
}
#print ">>>>>>>>>>>>>>>>>>>>>>>\n";
my %brain_tag;
my %testis_tag;
my %total_tag;

foreach my $key (keys %tissue) {
		my $gene_name=(split /\t/,$key)[0];
		
		#print ">>>>>>>>>$gene_name\n";
		if ((split /\t/,$key)[1]=~/total|real/) {next;}
		if ($tissue{$gene_name."\ttotal"}==0) {next;}
		if ($tissue{$gene_name."\treal"}<10) {next;}
		$total_tag{$gene_name}=1;
		if ($tissue{$gene_name."\tbrain"}/$tissue{$gene_name."\ttotal"}>0.1) {$brain_tag{$gene_name}=1;}
		if ($tissue{$gene_name."\ttestis"}/$tissue{$gene_name."\ttotal"}>0.1) {$testis_tag{$gene_name}=1;}


		if ($tissue{$key}/$tissue{$gene_name."\ttotal"}>0.5) 
		{
			
			print "$key\t$tissue{$key}\t",$tissue{$key}/$tissue{$gene_name."\ttotal"},"\n";
		}
}

my %total_tag_2;
my %tumor_tag;
foreach my $key (keys %health) {
	my $gene_name=(split /\t/,$key)[0];
		if ((split /\t/,$key)[1]=~/total|real/) {next;}
		if ($health{$gene_name."\ttotal"}==0) {next;}
		if ($health{$gene_name."\treal"}<10) {next;}
				$total_tag_2{$gene_name}=1;
		if ($health{$gene_name."\ttumor"}/$health{$gene_name."\ttotal"}>0.1) {$tumor_tag{$gene_name}=1;}

}

foreach my $key (keys %tumor_tag) {
	print Tumor "$key\t",$health{$key."\ttumor"},"\n";
}

foreach my $key (keys %brain_tag) {
	print Brain "$key\t",$tissue{$key."\tbrain"},"\n";
}

foreach my $key (keys %testis_tag) {
	print Testis "$key\t",$tissue{$key."\ttestis"},"\n";
}

foreach my $key (keys %total_tag) {
	print Total "$key\t",$tissue{$key."\ttotal"},"\n";
}
