#!/usr/bin/perl -w
use strict;
open REF, "$ARGV[0]"||die "can not open $ARGV[0]\n";
#open List, ">$ARGV[1]"||die "!";
open OUT,">$ARGV[1]"||die "!";
#open OUT, ">$ARGV[1]"||die "can not open $ARGV[2]\n";
#5221	0	0	0	0	0	8	6313	-	NM_164351	5224	0	5221	chr2L	22407834	9838	21372	9	1506,109,443,643,106,1192,779,136,307,	3,1509,1618,2061,2704,2810,4002,4781,4917,	9838,11409,11778,12285,13519,13682,14932,19879,21065,	Hs.356624	91	3834
#0                                                     10                             14                 16      17                          size                         qstart                                    tstart



#找出有overlap的exon对


my %ref_chr=();
my %ref_strand=();
my %ref_size=();
my %start=();
my %end=();
my %ref_qstart=();
my %ref_qend=();
my %ref_tstart=();
my %ref_tend=();
my %ref_block=();
my %ref_name=();
my %ref_line=();
my %hash_over=();
my %uniq;
my %ref_cds_start=();
my %ref_cds_end=();
my %ref_len=();
#my %qstart_in_genome=();
#my %qend_in_genome=();

while (my $line=<REF>) {
	chomp $line;
	my @infor=split /\s+/, $line;
	my $name=$infor[9];
	$start{$name}=$infor[15];
	$end{$name}=$infor[16];
	$ref_chr{$name}=$infor[13];
	$ref_strand{$name}=$infor[8];
	$ref_block{$name}=$infor[17];
	$ref_line{$name}=$line;
	$ref_name{$name}=$name;
	#$ref_cds_start{$name}=$infor[22];
	#$ref_cds_end{$name}=$infor[23];
	$ref_len{$name}=$infor[10];
	
		
	my @tmp_size=split /\,/, $infor[18];
	my @tmp_qstart=split /\,/, $infor[19];
	my @tmp_tstart=split /\,/, $infor[20];
	#$qstart_in_genome{$name}=$tmp_tstart[0]-$tmp_qstart[0];
	#$qend_in_genome{$name}=$qstart_in_genome{$name}+$ref_len{$name}-1;


	for (my $i=0;$i<=$ref_block{$name}-1;$i++) {
		$ref_size{$name}->[$i]=$tmp_size[$i];
		
		$ref_tstart{$name}->[$i]=$tmp_tstart[$i];
		$ref_tend{$name}->[$i]=$tmp_tstart[$i]+$ref_size{$name}->[$i]-1;
		
		$ref_qstart{$name}->[$i]=$tmp_qstart[$i];
		$ref_qend{$name}->[$i]=$tmp_qstart[$i]+$ref_size{$name}->[$i]-1;

	}

}

close REF;

open REF, "$ARGV[0]"||die "can not open $ARGV[0]\n";


while (my $line=<REF>) {
	chomp $line;
	my @infor=split /\s+/, $line;
	my $name=$infor[9];
	my $start=$infor[15];
	my $end=$infor[16];
	my $chr=$infor[13];
	
	foreach my $key (keys %ref_line) {
		if ($chr ne $ref_chr{$key}) {next;} #不在同一染色体上的跳出
		if ($name eq $key) {next;}			#自己和自己不比
		else {
			if ($start > $end{$key} || $end < $start{$key}) {next;}		#无overlap的跳过
			else {

				if ($name lt $key) {$uniq{$name,"\t",$key}->[0]=$name;$uniq{$name,"\t",$key}->[1]=$key;}
				if ($key lt $name) {$uniq{$key,"\t",$name}->[0]=$key;$uniq{$key,"\t",$name}->[1]=$name;}
				}									
		}
	}

}
close REF;

open List,">findoverlap.list"||die"!";#输出有overlap的gene对，包括intron的
foreach my $key (keys %uniq) {print List "$uniq{$key}->[0]\t$start{$uniq{$key}->[0]}\t$end{$uniq{$key}->[0]}\t$uniq{$key}->[1]\t$start{$uniq{$key}->[1]}\t$end{$uniq{$key}->[1]}\n";}
close List;


foreach my $key (keys %uniq) {#找出在exon上有overlap的
	for (my $i=0;$i<=$ref_block{$uniq{$key}->[0]}-1 ;$i++) {
		for (my $j=0; $j<=$ref_block{$uniq{$key}->[1]}-1;$j++) {
			if ($ref_tstart{$uniq{$key}->[0]}->[$i] > $ref_tend{$uniq{$key}->[1]}->[$j] || $ref_tend{$uniq{$key}->[0]}->[$i] < $ref_tstart{$uniq{$key}->[1]}->[$j]) {next;}#若exon上无overlap，跳过
			else {	
					print OUT "$uniq{$key}->[0]\t$ref_chr{$uniq{$key}->[0]}\t$ref_strand{$uniq{$key}->[0]}\t$ref_len{$uniq{$key}->[0]}\t$ref_tstart{$uniq{$key}->[0]}->[$i]\t$ref_tend{$uniq{$key}->[0]}->[$i]\t$ref_block{$uniq{$key}->[0]}\texon_",$i+1,"\t$ref_size{$uniq{$key}->[0]}->[$i]\t";
					print OUT "$ref_qstart{$uniq{$key}->[0]}->[$i]\t$ref_qend{$uniq{$key}->[0]}->[$i]\n";
					print OUT "$uniq{$key}->[1]\t$ref_chr{$uniq{$key}->[1]}\t$ref_strand{$uniq{$key}->[1]}\t$ref_len{$uniq{$key}->[1]}\t$ref_tstart{$uniq{$key}->[1]}->[$j]\t$ref_tend{$uniq{$key}->[1]}->[$j]\t$ref_block{$uniq{$key}->[1]}\texon_",$j+1,"\t$ref_size{$uniq{$key}->[1]}->[$j]\t";
					print OUT "$ref_qstart{$uniq{$key}->[1]}->[$j]\t$ref_qend{$uniq{$key}->[1]}->[$j]\n";
			}
		#\t$ref_block{$uniq{$key}->[0]}\texon_",$i+1,"  #\t$ref_block{$uniq{$key}->[1]}\texon_",$j+1,
		}
	}

}




close OUT;

exit

