#!/usr/bin/perl -w

use strict;

open IN, "$ARGV[0]"||die '!';
open AA, ">$ARGV[1]"||die '!';
open DNA, ">$ARGV[2]"||die '!';

my $name;
my %seq;
my %dna;
while (<IN>) {
	chomp;
	my @infor=split;
	if (/^\$VAR2 = /) {
		$name=$infor[2];
		$name=~s/\'//g;
		chop $name;
	}
	if (/^\$VAR8 =/) {
		$seq{$name}=$infor[2];
		$seq{$name}=~s/\'//g;
		$seq{$name}=~s/-//g;
		chop $seq{$name};
	}
	
	if (/^\$VAR9 =/)
	{
		$dna{$name}=$infor[2];
		$dna{$name}=~s/\'//g;
		$dna{$name}=~s/-//g;
		chop $dna{$name};
	}
}
close IN;

#my %frameshift;
my %stop;
my %rest_seq;
my %rest_dna;

foreach my $key (keys %seq) {
	#print "$key\n";
	my $len=length($seq{$key});
	my $tmp_seq;
	my $tmp_dna;
	for (my $i=0;$i<$len;$i++) {
		my $tmp=substr($seq{$key},$i,1);
		#print $i*3,"\n";
		my $tmp2=substr($dna{$key},$i*3,3);
		$tmp_seq.=$tmp;
		#if ($tmp2 eq ''){print "$key\n";exit;}
		$tmp_dna.=$tmp2;
		if ($tmp eq "!") {$stop{$key}=$i;chop $tmp_seq;$rest_seq{$key}=$tmp_seq;chop $tmp_dna;chop $tmp_dna;chop $tmp_dna;$rest_dna{$key}=$tmp_dna;last;}
		if ($tmp eq "X") {$stop{$key}=$i;chop $tmp_seq;$rest_seq{$key}=$tmp_seq;chop $tmp_dna;chop $tmp_dna;chop $tmp_dna;$rest_dna{$key}=$tmp_dna;last;}
	}

}

foreach my $key (keys %stop) { 
	print AA ">$key\t$stop{$key}\n$rest_seq{$key}\n";
	print DNA ">$key\t",$stop{$key}*3,"\n$rest_dna{$key}\n";
}
close AA;
close DNA;

#$VAR1 = 'NEWSINFRUP00000127076';
#$VAR2 = 'NEWSINFRUP00000127076_scaffold_387_169695_170783';
#$VAR3 = '411.68';
#$VAR4 = 0;
#$VAR5 = 0;
#$VAR6 = '100';
#$VAR7 = 'AVERVTTCESPFNVHHLRCEKGVISVQAALYGRADTDTCSEGRPVGQLTNTTCSQPGTEDLVKTRCDGKKECEINIRDVATPDPCVGTFKYLDTNYTCLPAIHVVACEGSLAHLFCA
#EGQVISVYGADYGRRDETTCSYRRLSFQTRNTLCSGPTNKVAELCNGKNRCTFRVGSSLFGDPCRNTYKYLELAYVCE';
#$VAR8 = 'AVERVTTCESPFNVHHLRCEKGVISVQAALYGRADTDTCSEGRPVGQLTNTTCSQPGTEDLVKTRCDGKKECEINIRDVATPDPCVGTFKYLDTNYTCLPAIHVVACEGSLAHLFCA
#EGQVISVYGADYGRRDETTCSYRRLSFQTRNTLCSGPTNKVAELCNGKNRCTFRVGSSLFGDPCRNTYKYLELAYVCE';
#$VAR9 = 'gctgtcgaaagagtgaccacctgtgaaagcccatttaacgtccatcacctgagatgtgagaagggagtgatcagcgtgcaagctgccctgtacggccgcgcagacacggacacctgc
#agcgagggcaggcctgtaggccaattgaccaacacaacctgctcgcaaccaggcacggaggatcttgtcaagacgagatgtgatggcaaaaaagaatgtgagatcaacataagagacgtggctacc
#cctgatccctgtgtgggcacctttaagtacctggacaccaactacacctgtctaccagcaattcacgttgttgcctgtgagggctcgctggcccatttgttctgcgctgaaggacaggtcatttct
#gtgtacggtgctgattacggccgtcgggacgagaccacgtgctcttacaggcgcctcagctttcagacgaggaacaccctctgctcaggccccactaacaaagttgcagagctgtgtaatggaaag
#aacaggtgcacgttcagagttggaagctcactgtttggagacccctgtaggaacacctataagtacctggagctggcttacgtctgtgaa';
#$VAR10 = '1';
#$VAR11 = '195';
#$VAR12 = 6;
#$VAR13 = '589';
#$VAR14 = '2089';
#$VAR15 = '';
#$VAR16 = '';
#$VAR17 = '99.49';
#$VAR18 = [
#           '19,44,36,14,43,34,',
#           '1,21,66,103,118,162,',
#           '589,1002,1460,1648,1765,1987,',
#           '646,1137,1569,1692,1897,2089,'
#         ];
#//
