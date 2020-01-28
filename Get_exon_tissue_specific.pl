#!/usr/bin/perl 

use strict;
use Getopt::Long;
open New_exon_list,"$ARGV[0]" || die"$!";
open Est_tissue,"$ARGV[1]" || die"$!";
open Exon_merge,"$ARGV[2]" || die"$!";


#BI219922,1      NM_133806       +       170143102       170143424       323     major   97.0588235294118        33      34

#DV065678        18147   male_genital    chr3    Mm.1
#DV063388        18147   male_genital    chr3    Mm.1
#CB589778        12733   mixed   chr3    Mm.1

#>>>     BC055756,1
#BC055337,1      NM_001001130    +       65245722        65245848        127
#BC055756,1      NM_001001130    +       65245722        65245848        127

my %est_tissue;
my %est_lid;
while (<Est_tissue>) {
	chomp;
	my @infor=split;
	$est_tissue{$infor[0]}=$infor[2];
	$est_lid{$infor[0]}=$infor[1];
}
close Est_tissue;

my $exon_name;
my %exon_merge;
while (<Exon_merge>) {
	chomp;
	my @infor=split;
	if (/^>>>/) {
		$exon_name=$infor[1];
	}
	else
	{
		my $tmp=(split /,/,$infor[0])[0];
		$exon_merge{$exon_name}.="$tmp\n";
	}
}


#BY324824,1      NM_026472       +       118184101       118184244       144     major   98.5714285714286        69      70
while (<New_exon_list>) {
	chomp;
	my @infor=split;
	my @list=split /\n/, $exon_merge{$infor[0]};
	print ">$infor[0]\t$infor[-2]\n";
	foreach my $key (@list) {
		print "$est_tissue{$key}\t$est_lid{$key}\n";
	}
}