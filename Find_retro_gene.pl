#!/usr/bin/perl -w

use strict;
open Solar, "$ARGV[0]"||die '!';
open Tab, "$ARGV[1]"||die '!';
open Struc, "$ARGV[2]"||die '!';
open OUT, ">$ARGV[3]"||die '!';


#gene_16 306     1       306     +       gene_16 306     1       306     1       306     1,306;  1,306;  +306;
#gene_25 441     1       441     +       gene_25 441     1       441     1       441     1,441;  1,441;  +441;
#gene_25 441     1       441     +       gene_29 513     73      513     1       439     1,441;  73,513; +439;

#GSTENP00007700001_Un_random_87000001-117000000_17855502_17856653        1877
#GSTENP00019920001_Un_random_145000001-175000000_18410084_18410908       1832

#250     0       0       0       0       0       0       0       +       AY374475        250     1       250     AY374475_10_8560829_8562487   10000000        1001    2659    6       37,43,24,39,53,51,      1,39,83,107,147,200,    1001,1471,1727,1990,2184,2507,        1112,1603,1799,2107,2344,2659,
my %tab;
while (<Tab>) {
	chomp;
	my @infor=split;
	$tab{"gene_$infor[1]"}=$infor[0];
}
close Tab;

my %exon_num;
my %block_start;
my %block_end;
my %block_num;

while (<Struc>) {
	chomp;
	my @infor=split;
	$exon_num{$infor[13]}=$infor[17];
	my @tmp_start=split /,/,$infor[20];
	my @tmp_end=split /,/,$infor[21];
	$block_num{$infor[13]}=@tmp_start;
	for (my $i=0;$i<@tmp_start ;$i++) {
		my $size=$tmp_end[$i]-$tmp_start[$i];
		if ($i==0) {$block_start{$infor[13]}->[$i]=1;}
		else
		{$block_start{$infor[13]}->[$i]=$block_end{$infor[13]}->[$i-1]+1;}
		
		$block_end{$infor[13]}->[$i]=$block_start{$infor[13]}->[$i]+$size;
		#print "$i\t",$block_start{$infor[13]}->[$i],"\t",$block_end{$infor[13]}->[$i],"\t$size\n";
	}
}
close Struc;

my %align_start;
my %align_end;
my %char;

while (<Solar>) {
	chomp;
	my %align_exon_num=();
	my $overlap_len;
	my @infor=split;
	my $rough;
	
	my @tmp_2 = split(/[\,\;]/,$infor[11]);
	unshift(@tmp_2,"1");
	@tmp_2 = &cat(@tmp_2);
	for(my $i=0;$i<$#tmp_2;$i+=2)
	{
		$rough += $tmp_2[$i+1] - $tmp_2[$i] + 1;	#去除每个片段overlap的比到的实际长度
	}
	
	if ($infor[0] eq $infor[5]) {next;}
	if ($exon_num{$tab{$infor[0]}}!=1){next;}
	if ($exon_num{$tab{$infor[5]}}==1) {if($rough/$infor[1]>0.6){$char{$tab{$infor[0]}}=1};next;}
	my @tmp = split/[\,\;]/,$infor[12];
	unshift(@tmp,"1");
	@tmp = &cat(@tmp);
	my $count=0;
	for (my $i=0;$i<@tmp-1 ;$i+=2) {#query的每一个blcok和database的gene结构作比较
		$align_start{$tab{$infor[5]}}->[$count]=$tmp[$i];
		$align_end{$tab{$infor[5]}}->[$count]=$tmp[$i+1];
		
		for (my $j=0;$j<$block_num{$tab{$infor[5]}} ;$j++) {#一个exon一个exon的比
			if (!($align_start{$tab{$infor[5]}}->[$count]>$block_end{$tab{$infor[5]}}->[$j] or $align_end{$tab{$infor[5]}}->[$count]<$block_start{$tab{$infor[5]}}->[$j])) 
			{#若和其中一个exon有overlap，计算overlap的长度
				
				if ($align_start{$tab{$infor[5]}}->[$count]>=$block_start{$tab{$infor[5]}}->[$j] and $align_end{$tab{$infor[5]}}->[$count]<=$block_end{$tab{$infor[5]}}->[$j])
				{$overlap_len=$align_end{$tab{$infor[5]}}->[$count]-$align_start{$tab{$infor[5]}}->[$count]+1;}#比对的区域完全落入一个exon的情况
				
				elsif($align_start{$tab{$infor[5]}}->[$count]<=$block_end{$tab{$infor[5]}}->[$j] and $align_end{$tab{$infor[5]}}->[$count]>=$block_end{$tab{$infor[5]}}->[$j])
				{$overlap_len=$block_end{$tab{$infor[5]}}->[$j]-$align_start{$tab{$infor[5]}}->[$count]+1;}
				
				elsif($align_start{$tab{$infor[5]}}->[$count]<=$block_start{$tab{$infor[5]}}->[$j] and $align_end{$tab{$infor[5]}}->[$count]>=$block_start{$tab{$infor[5]}}->[$j])
				{$overlap_len=$align_end{$tab{$infor[5]}}->[$count]-$block_start{$tab{$infor[5]}}->[$j]+1;}
				
				elsif($align_start{$tab{$infor[5]}}->[$count]<=$block_start{$tab{$infor[5]}}->[$j] and $align_end{$tab{$infor[5]}}->[$count]>=$block_end{$tab{$infor[5]}}->[$j])
				{$overlap_len=$block_end{$tab{$infor[5]}}->[$j]-$block_start{$tab{$infor[5]}}->[$j]+1;}
				
				else {print "Wrong!!!!!!!!!!!!!!!!!!!!!!\n";die '!';}
				if ($overlap_len>=20) {#overlap的长度超过20bp，认为比到了一个exon
					$align_exon_num{"$block_start{$tab{$infor[5]}}->[$j]\t$block_end{$tab{$infor[5]}}->[$j]"}=1;#防止一个exon分2段比到同一个exon误判的情况
					print "$tab{$infor[0]}\t$tab{$infor[5]}\t",$align_start{$tab{$infor[5]}}->[$count],"\t",$align_end{$tab{$infor[5]}}->[$count],"\t",$block_start{$tab{$infor[5]}}->[$j],"\t",$block_end{$tab{$infor[5]}}->[$j],"\n";
				}
			}
		}

		$count++;
	
	}
	
	if ((keys %align_exon_num)>1) {#若比到>=2个exon，则输出
		if (!exists $char{$tab{$infor[0]}}){$char{$tab{$infor[0]}}=0;}
		print OUT "$tab{$infor[0]}_$infor[0]\t$infor[1]\t$infor[2]\t$infor[3]\t$infor[4]\t$tab{$infor[5]}_$infor[5]\t";
		for (my $i=6;$i<=13;$i++){print OUT "$infor[$i]\t";}
		print OUT "$char{$tab{$infor[0]}}\n";
	}
	#last;


}

sub cat
		#function:quit redundance
		#input:($para,@array), para is the merge length 
		#output:(@array), 
		#for example (0,1,3,4,7,5,8)->(1,3,4,8) (1,1,3,4,7,5,8)->(1,8)
		{
			my($merge,@input) = @_;
			my $i = 0;
			my @output = ();
			my %hash = ();
			my $each = 0;
			my $begin = "";
			my $end = 0;
			my $Qb = 0; 
			my $Qe = 0; 
			my $temp = 0; 


			for ($i=0;$i<@input;$i+=2) 
			{
				$Qb = $input[$i];
				$Qe = $input[$i+1];

				if($Qb > $Qe) { $temp = $Qb; $Qb = $Qe; $Qe = $temp; }
				if(defined($hash{$Qb}))	{ if($hash{$Qb} < $Qe) { $hash{$Qb} = $Qe; } }
				else { $hash{$Qb} = $Qe; }
				$Qb = 0; 
			}

			foreach $each (sort {$a <=> $b} keys %hash) 
			{
				if($begin eq "")
				{
					$begin = $each;
					$end = $hash{$each};
				}
				else
				{
					if($hash{$each} > $end) 
					{
						if($each > $end + $merge) 
						{ 
							push(@output,$begin);
							push(@output,$end);
							$begin = $each; 
							$end = $hash{$each};
						}
						else { $end = $hash{$each}; }
					}
				}
			}
			push(@output,$begin);
			push(@output,$end);

			%hash = ();

			return(@output);
		}