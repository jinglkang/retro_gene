#!/usr/bin/perl -w

use strict;
open Exon, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Ortholog, "$ARGV[1]"||die "can not open $ARGV[1]\n";
open TMP, ">debug.tmp";

#open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";
#BB613557,3_13   NM_001001883    +       294676  294861  186     4
#AK129325,12_14  NM_001001883    +       307850  307984  135     2
#AK129325,13_15  NM_001001883    +       311425  311527  103     2
#AK129325,14_16  NM_001001883    +       313685  313781  97      2

#NM_011441	chr5	+	14943946	15325459
#NM_025300	chr5	+	14911231	15241406
#NM_008866	chr5	-	14816298	14932631
#NM_021374	chr5	+	14672138	14882196
#NM_133826	chr5	-	14055395	14738090
#NM_011011	chr5	-	13365398	14577979

my %hash_ref;
my %hash_chr;
while (<Ortholog>) {
	my @infor=split;
	$hash_ref{$infor[0]}=$infor[0];
	$hash_chr{$infor[0]}=$infor[1];
}

my $count_exon;
my $count_gene;
#my $count;
my %chr_count;
my %chr_gene_count;
my %tmp;
while (<Exon>) {
	my @infor=split;
	if (exists $hash_ref{$infor[1]}) {
		$chr_count{$hash_chr{$infor[1]}}++;
		if ($hash_chr{$infor[1]} eq "chr11_random") {print TMP $infor[0]."\n";}
		#$count++;
	if (!exists $tmp{$infor[1]}) {$tmp{$infor[1]}=1;$chr_gene_count{$hash_chr{$infor[1]}}++;}
	
	
	}

}
foreach my $key (sort keys %chr_count) {
	print "$key\t$chr_count{$key}\t$chr_gene_count{$key}\n";
	$count_exon+=$chr_count{$key};
	$count_gene+=$chr_gene_count{$key}
}
print "$count_exon\t$count_gene\n";