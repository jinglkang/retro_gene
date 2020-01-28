#!/usr/bin/perl -w

open OUT, ">$ARGV[3]"||die "!";

#CB161860        Noinfor Hs.2    Noinfor Noinfor
#AJ581145        +       Hs.2    68      510
#AJ581144        +       Hs.2    39      481
#>
#AAAAAAAAAAAA

#my %hash_start=();
#my %hash_end=();
#my %hash_ugid=();
#
#while (<Infor>) {#读入编码位置信息
#my @tmp=split;
#$hash_ugid{$tmp[0]}=$tmp[2];
#$hash_start{$tmp[0]}=$tmp[3];
#$hash_start{$tmp[0]}=$tmp[4];
#}
#close Infor;
#
#my $name;
#my %hash_seq=();
#while (<Seq>) {#读入序列信息
#	if (/^>(\w+)\n$/) {
#		$name=$1;
#	}
#	else {
#		$hash{$name}.=$_
#	}
#}

#585	1524	6	37	1	2	7	7	13373	-	BC063470	1642	0	1575	chr1	245522847	4268	19209	9	50,374,110,41,159,198,456,154,26,	67,122,496,608,649,808,1006,1462,1616,	4268,4318,5658,5769,6469,6720,7468,14600,19183,	NM_182905
my $count=0;
my $seq='';
my $tag=0;
my $tag2=0;
use strict;

open List,"$ARGV[0]"||die "!";

while (my $list_line=<List>) {
	my @tmp=split(/\t/,$list_line);

	open Infor, "$ARGV[1]"||die "!";
		
	while (my $infor_line=<Infor>) {
		my @infor=split /\t/, $infor_line;
		if ($tmp[10] ne $infor[0]) {next;}
		else {
		
		open Seq, "$ARGV[2]"||die "!";
		
		while (my $seq_line=<Seq>) {
		if ($seq_line=~/^>(\w+)/) {
			
			my $seq_name=$1;
			if ($tag==1) {print OUT $seq;$tag=0;$tag2=0;$seq='';last;}
			
			if ($seq_name ne $infor[0]) {next;}else{$tag2=1;print OUT ">$infor[0]\t$infor[2]\t$infor[3]\t$infor[4]";next;}
			}
		elsif ($seq_line=~/^[agctu]/i and $tag2==1) {$seq.=$seq_line;$tag=1}
		
		}
		if ($tag==1 and $tag2==1) {print OUT $seq;$tag=0;$tag2=0;$seq='';}
		close Seq;
		last;
		}
	}
		close  Infor;
}

if ($tag==1) {print OUT $seq;}
close List;
exit
