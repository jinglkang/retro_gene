#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Align,"$ARGV[0]" || die "!";
open Exon,"$ARGV[1]" || die "!";

open OUT,">$ARGV[2]" || die "!";
open OUT2, ">$ARGV[3]"||die '!';

#1 chr1 1250 1311 chr9_random 4665777 4665838 + 5767
#aaggtgtagtggcagcac-gcccacctgctggcagctggggacactgccgggccctcttgctc
#aaagtgtagtggcagc-acgcccgcctgctggcagctggggacactgccgggccctcttgctc


#BM714439,3      chr1    -       2526813 2526938 NM_003820       904
#DA448757,3      chr1    +       17296168        17296229        NM_013358       3700

my %human_seq;
my %human_start;
my %human_end;
my %chimp_seq;
my %chimp_start;
my %chimp_end;

while (<Align>) {
	chomp;
	my $name;
	if (/^\d/) {
		my @infor=split;
		$name=$infor[0];
		#print "$name\n";
		$human_start{$name}=$infor[2];
		$human_end{$name}=$infor[3];
		$chimp_start{$name}=$infor[5];
		$chimp_end{$name}=$infor[6];
		$human_seq{$name}=<Align>;
		$chimp_seq{$name}=<Align>;
	}
}
close Align;

my %human_exon_left;
my %human_exon_right;
my %chimp_exon_left;
my %chimp_exon_right;
#CD623214,2      chr1    -       30883580        30883656        NM_006762       5486
my $tag=0;
while (<Exon>) {
	chomp;
	my @infor=split;
	if ($infor[2] eq '+') {
		my $left_pos=$infor[3]-$human_start{$infor[-1]}-2;
		my $right_pos=$infor[4]-$human_start{$infor[-1]};

		if (!($infor[3]-$human_start{$infor[-1]}>=2 && $human_end{$infor[-1]}-$infor[4]>=2)) {
			
			next;
			}


		my $left_count=0; my $i=0;
		while ($tag==0) {
			if (($i-$left_count-1)==$left_pos) {last;}
			my $tmp=substr ($human_seq{$infor[-1]},$i,1);  $i++;
			if ($tmp eq '-') {$left_count++;}
		}
		my $right_count=0; my $j=0;
		while ($tag==0) {
			if (($j-$right_count+2-1)==$right_pos) {last;}
			my $tmp=substr ($human_seq{$infor[-1]},$j,1);  $j++;
			if ($tmp eq '-') {$right_count++;}
		}
		
		my $gap_tag=0;
		if ($right_count==$left_count) {$gap_tag=1;}

		my $tmp_seq=$human_seq{$infor[-1]};

		$tmp_seq=~s/\-//g;
		
		$human_exon_left{$infor[0]}=uc(substr ($tmp_seq,$left_pos,2));
		$human_exon_right{$infor[0]}=uc(substr ($tmp_seq,$right_pos+1,2));
		$chimp_exon_left{$infor[0]}=uc(substr($chimp_seq{$infor[-1]},$left_pos+$left_count,2));
		$chimp_exon_right{$infor[0]}=uc(substr($chimp_seq{$infor[-1]},$right_pos+1+$right_count,2));
		if (($human_exon_left{$infor[0]} eq 'AG' or $human_exon_left{$infor[0]} eq 'ag') and ($human_exon_right{$infor[0]} eq 'GT' or $human_exon_right{$infor[0]} eq 'gt') and (($chimp_exon_left{$infor[0]} ne 'ag' and $chimp_exon_left{$infor[0]} ne 'AG') or ($chimp_exon_right{$infor[0]} ne 'GT' and $chimp_exon_right{$infor[0]} ne 'gt'))) {
		
		print OUT "$infor[0]\t$human_exon_left{$infor[0]}\t$human_exon_right{$infor[0]}\t$chimp_exon_left{$infor[0]}\t$chimp_exon_right{$infor[0]}\t+\t$gap_tag\n";

		}
		else
		{
		print OUT2 "$infor[0]\t$human_exon_left{$infor[0]}\t$human_exon_right{$infor[0]}\t$chimp_exon_left{$infor[0]}\t$chimp_exon_right{$infor[0]}\t+\t$gap_tag\n";
		}
	}
	else{
		my $left_pos=$infor[3]-$human_start{$infor[-1]}-2;
		my $right_pos=$infor[4]-$human_start{$infor[-1]};

		if (!($infor[3]-$human_start{$infor[-1]}>=2 && $human_end{$infor[-1]}-$infor[4]>=2)) {
			
			next;
			}


		my $left_count=0; my $i=0;
		while ($tag==0) {
			if (($i-$left_count-1)==$left_pos) {last;}
			my $tmp=substr ($human_seq{$infor[-1]},$i,1);  $i++;
			if ($tmp eq '-') {$left_count++;}
		}
		my $right_count=0; my $j=0;
		while ($tag==0) {
			if (($j-$right_count+2-1)==$right_pos) {last;}
			my $tmp=substr ($human_seq{$infor[-1]},$j,1);  $j++;
			if ($tmp eq '-') {$right_count++;}
		}

			my $gap_tag=0;
		if ($right_count==$left_count) {$gap_tag=1;}

		my $tmp_seq=$human_seq{$infor[-1]};

		$tmp_seq=~s/\-//g;
		
		$human_exon_left{$infor[0]}=substr ($tmp_seq,$left_pos,2);
		$human_exon_right{$infor[0]}=substr ($tmp_seq,$right_pos+1,2);
		$chimp_exon_left{$infor[0]}=substr($chimp_seq{$infor[-1]},$left_pos+$left_count,2);
		$chimp_exon_right{$infor[0]}=substr($chimp_seq{$infor[-1]},$right_pos+1+$right_count,2);

		
		$human_exon_left{$infor[0]}=~tr/ATCGatcg/TAGCtagc/;my $tmp_human_exon_left=uc(reverse $human_exon_left{$infor[0]});
		$human_exon_right{$infor[0]}=~tr/ATCGatcg/TAGCtagc/;my $tmp_human_exon_right=uc(reverse $human_exon_right{$infor[0]});
		$chimp_exon_left{$infor[0]}=~tr/ATCGatcg/TAGCtagc/;my $tmp_chimp_exon_left=uc(reverse $chimp_exon_left{$infor[0]});
		$chimp_exon_right{$infor[0]}=~tr/ATCGatcg/TAGCtagc/;my $tmp_chimp_exon_right=uc(reverse $chimp_exon_right{$infor[0]});
		
		if(($tmp_human_exon_right eq 'ag' or $tmp_human_exon_right eq 'AG') and ($tmp_human_exon_left eq 'GT' or $tmp_human_exon_left eq 'gt') and (($tmp_chimp_exon_right ne 'ag' and $tmp_chimp_exon_right ne 'AG')or ($tmp_chimp_exon_left ne 'GT' and $tmp_chimp_exon_left ne 'gt')))
		{
		print OUT "$infor[0]\t$tmp_human_exon_right\t$tmp_human_exon_left\t$tmp_chimp_exon_right\t$tmp_chimp_exon_left\t-\t$gap_tag\n";
		}
		else
		{
		print OUT2 "$infor[0]\t$tmp_human_exon_right\t$tmp_human_exon_left\t$tmp_chimp_exon_right\t$tmp_chimp_exon_left\t-\t$gap_tag\n";
		}

	}
}