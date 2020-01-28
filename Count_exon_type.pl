#!/usr/bin/perl -w

use strict;
open IN, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open OUT, ">$ARGV[1]"||die "can not open $ARGV[1]\n";

#AL041611,2_3	NM_002861	+	7440	7601	162	major	95.0819672131148	58	61

#NM_000646,1_3   NM_000028       +       7640    7782    143     low     8.69565217391304        2       23
my %count;
my %count_low;
my $total;
my $total_low;
my %exon_len;
my %exon_len_low;
my $total_exon_len;

while (<IN>) {#统计每种exon的参数
	$total++;
	chomp;
	my @infor=split;
	$total_exon_len+=$infor[5];
	if ($infor[6] eq 'low') {#统计low中每种exon的类型
		$total_low++;
		$count{$infor[6]}++;
		$exon_len{$infor[6]}+=$infor[5];
		if ($infor[7]==100) 
			{$count_low{"constitutive"}++;$exon_len_low{"constitutive"}+=$infor[5];}
		elsif ($infor[7]>=66.6 && $infor[7]<100)
			{$count_low{"major"}++;$exon_len_low{"major"}+=$infor[5];}
		elsif ($infor[7]>=33.3 && $infor[7]<66.6)
			{$count_low{"middle"}++;$exon_len_low{"middle"}+=$infor[5];}
		elsif ($infor[7]>=0 && $infor[7]<33.3)
			{$count_low{"minor"}++;$exon_len_low{"minor"}+=$infor[5];}
	}
	elsif ($infor[6] eq 'major') {$count{$infor[6]}++;$exon_len{$infor[6]}+=$infor[5];}
	elsif ($infor[6] eq 'constitutive') {$count{$infor[6]}++;$exon_len{$infor[6]}+=$infor[5];}
	elsif ($infor[6] eq 'middle') {$count{$infor[6]}++;$exon_len{$infor[6]}+=$infor[5];}
	elsif ($infor[6] eq 'minor') {$count{$infor[6]}++;$exon_len{$infor[6]}+=$infor[5];}
	elsif ($infor[6] eq 'wrong') {$count{$infor[6]}++;$exon_len{$infor[6]}+=$infor[5];}
	else {print "wrong!!!!!!!!!!"}
}
close IN;
open IN, "$ARGV[0]"||die "can not open $ARGV[0]\n";

my %gene_type; #统计as的gene数目和比例
my %gene_number;
my %exon_number;
my %as_exon_number;

while (<IN>) {
chomp;
my @infor=split;

if (!exists $exon_number{$infor[1]}) 
	{$exon_number{$infor[1]}=1;}
else {$exon_number{$infor[1]}++;}

if((!exists $as_exon_number{$infor[1]}) && ($infor[-1] != $infor[-2]))
	{$as_exon_number{$infor[1]}=1;}
		
elsif ((exists $as_exon_number{$infor[1]}) && ($infor[-1] != $infor[-2])) 
	{$as_exon_number{$infor[1]}++;}



$gene_number{$infor[1]}=1;
if ($infor[-1]==$infor[-2]) {next;}
else {$gene_type{$infor[1]}=1;}
}

close IN;

print "total gene number:\t".scalar (keys %gene_number)."\n"; 
print "AS gene number:\t".scalar (keys %gene_type)."\t".(scalar (keys %gene_type))/(scalar (keys %gene_number))."\n";

#print scalar keys %exon_number,"<<<<<<<<<<<";
#my $debug;
my $total_as_gene_exon_number;
my $total_as_gene_as_exon_number;

foreach my $key (keys %exon_number) {
	
	if (!exists $as_exon_number{$key}) {$as_exon_number{$key}=0;next;}
	print OUT "$key\t$exon_number{$key}\t$as_exon_number{$key}\t".$as_exon_number{$key}/$exon_number{$key}."\n";
$total_as_gene_exon_number+=$exon_number{$key};$total_as_gene_as_exon_number+=$as_exon_number{$key};
}
print "total_as_gene_exon_number:\t$total_as_gene_exon_number\ttotal_as_gene_as_exon_number:$total_as_gene_as_exon_number\t".$total_as_gene_as_exon_number/$total_as_gene_exon_number."\n";



open IN, "$ARGV[0]"||die "can not open $ARGV[0]\n";  #除去low，统计as的gene数目和比例
my %gene_type_remove_low;
my %gene_number_remove_low;
my %exon_number_remove_low;
my %as_exon_number_remove_low;

while (<IN>) {
chomp;
my @infor=split;
if($infor[6] ne 'low'){
	
if (!exists $exon_number_remove_low{$infor[1]}) 
	{$exon_number_remove_low{$infor[1]}=1;}
else {$exon_number_remove_low{$infor[1]}++;}

if((!exists $as_exon_number_remove_low{$infor[1]}) && ($infor[-1]!=$infor[-2]))
	{$as_exon_number_remove_low{$infor[1]}=1;}
		
elsif ((exists $as_exon_number_remove_low{$infor[1]}) && ($infor[-1]!=$infor[-2])) 
	{$as_exon_number_remove_low{$infor[1]}++;}

$gene_number_remove_low{$infor[1]}=1;
if ($infor[-1]==$infor[-2]) {next;}
else {$gene_type_remove_low{$infor[1]}=1;}
}
}
close IN;

print "total gene number remove low:\t".scalar (keys %gene_number_remove_low)."\n"; 
print "AS gene number remove low:\t".scalar (keys %gene_type_remove_low)."\t".(scalar (keys %gene_type_remove_low))/(scalar (keys %gene_number_remove_low))."\n";

#print OUT ">>>>>>>>>>>>>>>>>>>>>>\n";

foreach my $key (keys %exon_number_remove_low) {
		if (!exists $as_exon_number_remove_low{$key}) {$as_exon_number_remove_low{$key}=0}
	#print OUT "$key\t$exon_number_remove_low{$key}\t$as_exon_number_remove_low{$key}\t".$as_exon_number_remove_low{$key}/$exon_number_remove_low{$key}."\n";
}






print "\ntotal:\t$total\taverage length:",$total_exon_len/$total,"\n";
foreach my $key (keys %count) {
	print "$key:\t$count{$key}\t".$count{$key}/$total,"\t",$exon_len{$key}/$count{$key};
	print "\n";

}
#if(undef $total_low){}else{print "\ntotal_low:\t$total_low\taverage length:",$exon_len{"low"}/$total_low,"\n";}

foreach my $key (sort keys %count_low) {
	print "$key:\t$count_low{$key}\t".$count_low{$key}/$total_low."\t",$exon_len_low{$key}/$count_low{$key},"\n";

}

#print "\nall\n";
#
#foreach my $key (sort keys %count_low) {
#	print "$key:\t".$count_low{$key}+$."\t".$count_low{$key}/$total_low."\n";
#
#}
