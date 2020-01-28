#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Rel,"$ARGV[0]" || die"$!";
open GO,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";

#UniProt	O00116	ADAS_HUMAN		GO:0008609	PMID:9553082	IDA		F	Alkyldihydroxyacetonephosphate synthase, peroxisomal precursor	IPI00010349	protein	taxon:9606	20060224	MGI

#SP	O00116	IPI00010349		Q53S12;Q53SG6;Q53SN7;	ENSP00000264167;	REVIEWED:NP_003650;			AAT11152;CAA70591;	327,AGPS;	8540,AGPS;	UPI00001254E8	Hs.591631;	CCDS2275.1;	GI:4501993;	

my %hash;
while (<Rel>) {
	if (/^\#/) {next;}
	chomp;
	my @infor=split /\t/,$_;
	if (!defined $infor[13] or $infor[13] eq '') {next;}
	chop $infor[13];
	if (!($infor[13]=~/;/)) {
		$hash{$infor[13]}.="$infor[1]\t"; #得到ugid与ensemble号的关系
	}
}
close Rel;
my %go;
while (<GO>) {
	if(/^!/ or /^\#/){next;}
	chomp;
	my @infor=split;
	my $tmp;
	if (/(GO:\d+)/) {
		$tmp=$1;
		
		$tmp=~s/GO://g;
	}
	$go{$infor[1]}.="$tmp\t"; #得到ensemble与GO号的关系
}
close GO;
#print keys %hash;

foreach my $key (keys %hash) {
	my @tmp=split /\t/,$hash{$key};
	my $tag=0;

	foreach my $item (@tmp) {
		if (!exists $go{$item}) {next;}
		$tag=1;
	}

if ($tag==0) {next;}
print OUT "$key\t";
	foreach my $item (@tmp) {
		if (!exists $go{$item}) {next;}
		print OUT "$go{$item}\t"; #打出一个ugid对应所有GO号
	}
	print OUT "\n";
}