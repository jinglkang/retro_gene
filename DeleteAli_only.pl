#!/usr/bin/perl -w

open List, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Extra, ">$ARGV[1]"||die "!";
use strict;

#NM_001037501	chr1	-	2923	143503691	143503956	21	exon_1	266		175		2784	3		268		266		3		268		3'UTR and partial CDs	129
#NM_183372		chr1	-	5561	143502196	143503956	25	exon_1	1761	1279	3075	21		1781	266		1516	1781	3'UTR
#NM_001037501	chr1	-	2923	143504587	143504695	21	exon_2	109		175		2784	269		377		109		269		377		CDs	>>>>>>>>>>>>>>>>>109
#NM_183372		chr1	-	5561	143504587	143504695	25	exon_2	109		1279	3075	1782	1890	109		1782	1890	3'UTR
#NM_001037501	chr1	-	2923	143505410	143505520	21	exon_3	111		175		2784	378		488		111		378		488		CDs	>>>>>>>>>>>>>>>>>111
#NM_183372		chr1	-	5561	143505410	143505578	25	exon_3	169		1279	3075	1891	2059	111		1891	2001	3'UTR

#GSTENT00000617001       1       -       132     12864701        12864780        2       exon_1  80      0       79      74   6	79
#GSTENT00022846001       1       -       1674    12864707        12864826        12      exon_11 120     1250    1369    74   1250     1323

my %overlap_size=();
my %overlap_len=();
my %hash=();
my %tag=();
my %len=();

while (my $line1=<List>) {
	chomp $line1;
	my @infor1=split /\s+/,$line1;
	my $name1=$infor1[0];
	my $strand1=$infor1[2];
	my $line2=<List>;
	chomp $line2;
	my @infor2=split /\s+/,$line2;
	my $name2=$infor2[0];
	my $strand2=$infor2[2];

	$len{"$name1\t$name2"}->[0]=$infor1[3];
	$len{"$name1\t$name2"}->[1]=$infor2[3];

	
	if ($strand1 eq $strand2) {
		$tag{"$name1\t$name2"}++;
	
	if (!exists $hash{"$name1\t$name2"}) {$hash{"$name1\t$name2"}="$line1\n$line2\n";}
	else {$hash{"$name1\t$name2"}.="$line1\n$line2\n";}

	if (!exists $overlap_size{"$name1\t$name2"}) {
		$overlap_size{"$name1\t$name2"}->[0]=$infor1[11]/$infor1[3];
		$overlap_size{"$name1\t$name2"}->[1]=$infor2[11]/$infor2[3];
		$overlap_len{"$name1\t$name2"}->[0]=$infor1[11];
		$overlap_len{"$name1\t$name2"}->[1]=$infor2[11];
		}
	else {
		$overlap_size{"$name1\t$name2"}->[0]+=$infor1[11]/$infor1[3];
		$overlap_size{"$name1\t$name2"}->[1]+=$infor2[11]/$infor2[3];
		$overlap_len{"$name1\t$name2"}->[0]+=$infor1[11];
		$overlap_len{"$name1\t$name2"}->[1]+=$infor2[11];
		}
	}
	else {	
		if (!exists $hash{"$name1\t$name2"}) {$hash{"$name1\t$name2"}="$line1\n$line2\n";}
		else {$hash{"$name1\t$name2"}.="$line1\n$line2\n";}
	}
}
close List;


foreach my $key (keys %hash) {#去冗余,若2个基因方向相同且有60%的序列或有5个以上的exon有overlap,应该属于同一基因的不同剪切形式
	my @infor=split /\t/, $key;
	if(!exists $overlap_size{$key}){}
	else {
	if ($overlap_size{$key}->[0]>0.6 or $overlap_size{$key}->[1]>0.6  ) 
	{
		if ($len{$key}->[0]<$len{$key}->[1]){print Extra "$infor[0]\t$infor[1]\t$len{$key}->[0]\n";}
		else{print Extra "$infor[1]\t$infor[0]\t$len{$key}->[1]\n";}
	}
	else {}
	}
}
