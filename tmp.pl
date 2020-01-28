#!/usr/bin/perl -w

#按染色体分割文件
use strict;
#gi|56177899|ref|NC_006479.1|NC_006479
#while (<>){
#	chomp;
#	my @infor=split;
#	my $chr=(split /\|/,$infor[1])[-1];
#	if($chr=~/random/){$chr="all_random";}
#	print "$chr\n";
#	open TMP, ">>$chr"||die '!';
#	print TMP $_,"\n";
#	close TMP;
#}
#
#12176 chr1 114625439 114627445 chr1 146301301 146303310 + 166281        1       3       711     711     1       146302011       146302011

#while (<>){
#	chomp;
#	my @infor=split;
#	my $chr=$infor[1];
#	if($chr=~/random/){$chr="all_random";}
#	print "$chr\n";
#	open TMP, ">>$chr"||die '!';
#	print TMP $_,"\n";
#	close TMP;
#}


#open List,"$ARGV[0]"||die '!';
#open IN,"$ARGV[1]"||die '!';
#my %ref_of_chr;
#my %strand_of_ref;
#while (<List>) {
##	NM_000198       chr1    +       119664566       119706162
#chomp;my @infor=split;
#	$ref_of_chr{$infor[0]}=$infor[1];
#	$strand_of_ref{$infor[0]}=$infor[2];
#}
#close List;
#
#while (<IN>) {
#	chomp;
#	my @infor=split;
#	my $ref=$infor[1];
#	my $chr=$ref_of_chr{$ref};
#	if (!exists $ref_of_chr{$ref}) {next;}
##	BC060638,19     NM_001004164    +       87997311        87997409        99      major   90      9       10
#	my $strand;
#	if (($infor[2] eq '+') && ($strand_of_ref{$ref} eq '+')) {$strand="+";}
#	elsif(($infor[2] eq '+') && ($strand_of_ref{$ref} eq '-')){$strand="-";}
#	elsif(($infor[2] eq '-') && ($strand_of_ref{$ref} eq '+')){$strand="-";}
#	elsif(($infor[2] eq '-') && ($strand_of_ref{$ref} eq '-')){$strand="+";}
#	else{print "Wrong!>>>>>>>>>>>>>>>>>>>>>";}
#
#
#
#
#	if($chr=~/random/){$chr="all_random";}
#	#print "$chr\n";
#	open TMP, ">>$chr"||die '!';
#	print TMP "$infor[0]\t$chr\t$strand\t$infor[3]\t$infor[4]\n";
#	close TMP;
#}
#




#open List, "$ARGV[0]"||die "can not open $ARGV[0]\n";
#open Chr, "$ARGV[1]"||die "can not open $ARGV[1]\n";
#
#open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";
#
#my %hash;
#while (<Chr>) {
#	my @infor=split;
#	$hash{$infor[0]}=$infor[1];
#}
#while (<List>) {
#	chomp;
#	if (exists $hash{$_}) {
#	print OUT "$_\t$hash{$_}\n";}
#}
#

#
#my %hash;
#while (<List>) {
#	chomp;
#	my @infor=split;
#	$hash{$infor[0]}=$infor[0];
#}
#
#>>>     BC057147,4      10      10
#BC057147,4      BC057147,       NM_033078       129617811       129645938
#BC057147,4      AK170499,       NM_033078       129633643       129647169

#my $name;
#my $tag=0;
#while (<Exon>) {
#		if (/^>>>/) {
#		chomp;
#		my @infor=split;
#		$name=(split /,/ , $infor[1])[0];
#		if (exists $hash{$name}) {$tag=1;print $_,"\n";}
#		else {$tag=0;}
#	}
#	else {
#	if ($tag==1) {print $_;}
#	}
#}
#



#open Chr, "$ARGV[2]"||die "can not open $ARGV[2]\n";
#
#open List, "$ARGV[0]"||die "can not open $ARGV[0]\n";
#open Exon, "$ARGV[1]"||die "can not open $ARGV[1]\n";
#
##>BC057147,4     NM_033078
##TATTGTGCAACAAGGAAGTCCCAGTTTCCTCAAGAG
##>BG972433,1     NM_007812
##ATCAGCCAACGTTATGGTCCTGTATTCACCATCTACCTGGGACCTCGCCGAATTGTGGTGCTGTGCGGACAGGAGGCAGTCAAGGAAGCTCTGGTGGACCAAGCTGAGGAATTCAGCGGGCGGG
##GCGAGCAGGCTACCTTCGACTGGCTTTTCAAAGGCTATG
##
##NM_001001130    chrUn
##NM_001001144    chr8
##NM_001001152    chr2
#my %chr;
#while (<List>) {
#	chomp;
#	my @infor=split;
#	$chr{$infor[0]}=$infor[1];
#}
#
#while (<Exon>) {
#	chomp;
#	if (/^>/) {
#		my @infor=split;
#		
#		if(exists $chr{$infor[1]}){
#			open OUT, ">>$chr{$infor[1]}"||die "can not open\n";
#			print OUT "$_\n";
#		}
#		else{<Exon>;}
#	}
#	else {print OUT "$_\n";close OUT;}
#
#}
##
##

#>gi|56177874|ref|NC_006468.1|NC_006468 Pan troglodytes chromosome 1, whole genome shotgun sequence
#>gi|56200054|ref|NC_006477.1|NC_006477 Pan troglodytes chromosome 10, whole genome shotgun sequence
#my %hash;
#while (<>) {
#	chomp;
#	my @infor=split;
#	my $name=(split /\|/,$infor[0])[-1];
#	my $chr="chr".$infor[4];
#	$chr=~s/,//;
#	$hash{$name}=$chr;
#}
#
#foreach my $key (keys %hash) {
#	print "$key\t$hash{$key}\n";
#}

#NM_004421       chr1
#NM_032348       chr1


open IN, "$ARGV[0]"||die '!';
open List,"$ARGV[1]"||die '!';

my $name;
my %hash;
my %ref;
while (<IN>) {
	chomp;
	my @infor=split;
	if (/^>>>/) {
		$name=$infor[1];
	}
	else{
		$hash{$name}.="$_";
		$ref{$name}=$infor[1];
	}
}
close IN;

my %chr;
while (<List>) {
	chomp;
	my @infor=split;
	$chr{$infor[0]}=$infor[1];
}

open IN, "$ARGV[0]"||die '!';
while (<IN>) {
	chomp;
	if (/^>>>/) {
		my @infor=split;
			if (!exists $chr{$ref{$infor[1]}}) {print ">>>>>>>>>>>>$ref{$infor[1]}\n";$_=<IN>; next;}
			open OUT, ">>$chr{$ref{$infor[1]}}"||die "can not open\n";  
			print OUT "$_\n";
	}
	else {print OUT "$_\n";close OUT;}  
	}

