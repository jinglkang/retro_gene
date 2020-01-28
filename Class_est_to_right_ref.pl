#!/usr/bin/perl -w

use strict;
open Est, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Ref, "$ARGV[1]"||die "can not open $ARGV[1]\n";
open Overlap_list, "$ARGV[2]"||die "can not open $ARGV[2]\n";


open OUT, ">$ARGV[3]"||die "can not open $ARGV[3]\n";
print "running $ARGV[1]......\n";
#910	2465	0	91	0	0	0	7	23178	+	NM_003758	2558	0	2556	chr15	100338915	42616557	42642291	8	170,104,55,92,115,162,74,1784,	0,170,274,329,421,536,698,772,	42616557,42616813,42630365,42630920,42634042,42636978,42639738,42640507,	H.2	3	456
my %ref_block;
my %ref_block_start;
my %ref_block_end;
while (<Ref>) {
	chomp;
	my @infor=split;
	my $name=$infor[10];
	$ref_block{$name}=$infor[18];
	my @start_infor=split /,/ , $infor[21];
	my @size_infor=split /,/ , $infor[19];
	for (my $i=1;$i<=$ref_block{$name} ;$i++) {
		$ref_block_start{$name}->[$i]=$start_infor[$i-1];
		$ref_block_end{$name}->[$i]=$start_infor[$i-1]+$size_infor[$i-1]-1;
		#print "$ref_block_start{$name}->[$i]\t$ref_block_end{$name}->[$i]\n";
	}
}

close Ref;

my %est_block;
my %est_block_start;
my %est_block_end;
while (<Est>) {
	chomp;
	my @infor=split;
	my $name=$infor[10];
	$est_block{$name}=$infor[18];
	my @start_infor=split /,/ , $infor[21];
	my @size_infor=split /,/ , $infor[19];
	for (my $i=1;$i<=$est_block{$name} ;$i++) {
		$est_block_start{$name}->[$i]=$start_infor[$i-1];
		$est_block_end{$name}->[$i]=$start_infor[$i-1]+$size_infor[$i-1]-1;
		#print "est:$est_block_start{$name}->[$i]\t$est_block_end{$name}->[$i]\n";
	}
}

close Est;

#BT010257	NM_135733	NM_165017		2
#BT023147	NM_135931	NM_078855		2
#AY089699	NM_134764	NM_164419	NM_001032045	NM_078729	NM_058077	NM_175946	NM_134748	NM_164415	NM_164418	NM_058060	NM_134752	NM_164413	NM_134759	NM_134765	NM_164427	NM_164430	NM_134755	NM_080009	NM_134746	NM_134750	NM_134760	NM_164417	NM_175947	NM_134758	NM_164420	NM_134747	NM_001032046	NM_134754	NM_134763	NM_134751	NM_057650	NM_080531	NM_164422	NM_134761		34
#AF468650	NM_078864	NM_165195	NM_135968		3
#AY060247	NM_135056	NM_135057	NM_164619		3
my %score;
my %number;
my %over_name;
while (<Overlap_list>) {
	chomp;
	my @infor=split;
	$number{$infor[0]}=$infor[-1]; #与此est有重叠的ref数目

	for (my $i=1;$i<=$infor[-1] ;$i++) {#对每个重叠的ref进行循环
		$over_name{$infor[0]}->[$i]=$infor[$i];
		for (my $j=1;$j<=$est_block{$infor[0]} ;$j++) {#对每个est的exon进行循环
			for (my $k=1;$k<=$ref_block{$infor[$i]};$k++) {#对每个重叠的ref的exon进行循环
				
				if($j==1 and $est_block_end{$infor[0]}->[$j]==$ref_block_end{$infor[$i]}->[$k]){$score{$infor[0]}->[$i]++;}
				elsif($j==$est_block{$infor[0]} and $est_block_start{$infor[0]}->[$j]==$ref_block_start{$infor[$i]}->[$k]){$score{$infor[0]}->[$i]++;}

				elsif ($j>1 and $j<$est_block{$infor[0]})
					{if($est_block_start{$infor[0]}->[$j]==$ref_block_start{$infor[$i]}->[$k] and $est_block_end{$infor[0]}->[$j]==$ref_block_end{$infor[$i]}->[$k]) {
					$score{$infor[0]}->[$i]++;
					}
				}
			}
		}
	}
}


#foreach my $key (keys %score) {
#		print "$key\t";
#		for (my $i=1;$i<=$number{$key} ;$i++) {
#		if (!defined $score{$key}->[$i]) {$score{$key}->[$i]=0;}
#		print "$over_name{$key}->[$i]\t$score{$key}->[$i]\t";
#		}
#		print "\n";
#}

foreach my $key (keys %score) {#将和est最多重合的ref做为它的ref
	my $best;
	my $tmp=0;
	#print "++++++++++++++++$key\t$number{$key}\n";
	for (my $i=1;$i<=$number{$key} ;$i++) {
		if (!defined $score{$key}->[$i]) {$score{$key}->[$i]=0;}
				#print "$over_name{$key}->[$i]\t$score{$key}->[$i]<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n";

		if ($score{$key}->[$i]>$tmp) {$tmp=$score{$key}->[$i];$best=$over_name{$key}->[$i]}
	}
	print OUT "$key\t$best\t$tmp\n";
}