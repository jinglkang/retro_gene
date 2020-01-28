#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Rel,"$ARGV[0]" || die"$!";
open GO,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";

#MGI:1915600	0610009K11Rik	O	Gene	RIKEN cDNA 0610009K11 gene	syntenic	4	AI853862 AK002416 AK044088 AK076419 AK083295 AK153956 AK170149 AK206971 AK217471 AV000801 AW124453 BB856128 BC019516 BY062056	103413	NM_026689 XM_981564 XM_981643 XM_990262

#MGI	MGI:1196377	Tnfaip3		GO:0006915	MGI:MGI:1354194	IEA		P	tumor necrosis factor, alpha-induced protein 3	A20|Tnfip3|zinc finger protein A20	gene	taxon:10090	20060528	UniProt
#UniProt	O00116	ADAS_HUMAN		GO:0008609	PMID:9553082	IDA		F	Alkyldihydroxyacetonephosphate synthase, peroxisomal precursor	IPI00010349	protein	taxon:9606	20060224	MGI

#SP	O00116	IPI00010349		Q53S12;Q53SG6;Q53SN7;	ENSP00000264167;	REVIEWED:NP_003650;			AAT11152;CAA70591;	327,AGPS;	8540,AGPS;	UPI00001254E8	Hs.591631;	CCDS2275.1;	GI:4501993;	


my %hash;
while (<Rel>) {
	chomp;
	my @infor=split /\t/,$_;
	if (!defined $infor[9]) {next;}
	
	my @tmp=split /\s+/,$infor[9];
	foreach my $item (@tmp) {
		$hash{$item}=$infor[0]; #得到NM与MGI号的关系
	}
}
close Rel;
my %go;
while (<GO>) {
	if(/^!/ or /^\#/){next;}
	chomp;
	my @infor=split;
	$infor[3]=~s/GO://g;
	$go{$infor[1]}.="$infor[3]\t"; #得到MGI号与GO号的对应关系
}
close GO;

foreach my $key (keys %hash) {
	if (!exists $go{$hash{$key}}) {next;}
	print OUT "$key\t$go{$hash{$key}}\n";
}