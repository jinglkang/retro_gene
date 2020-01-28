#!/usr/bin/perl -w

use strict;
#updata 2006-12-23 ,此程序用来处理tblastn比全基因组的结果，$ref_len的计算有变，有原来的直接用$infor[3]变为真正比到genome的长度

#GSTENP00000073001       163     31      155     +       15_random       3125405 596403  597122  2       78      31,114;99,155;	596403,596747;596967,597122;    +55;+33;
#GSTENP00000363001       279     2       276     +       15_random       3125405 1494539 1498044 3       139     2,50;108,222;222,276; 1494539,1494685;1495957,1496316;1497880,1498044;        +25;+70;+45; 

open Solar, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open OUT,">$ARGV[1]"||die "!";

#找出有overlap的locus对


my %ref_chr=();
my %ref_strand=();
my %start=();
my %end=();
my %ref_block=();
my %ref_name=();
my %ref_line=();
my %ref_identity=();
my %uniq;
my %ref_len=();
my %block_start;
my %block_end;
my %block_size;

while (my $line=<Solar>) {
	my $size0;
	my $rough;
	my $exact;
	my $over;
	my $match_total;

	chomp $line;
	my @infor=split /\s+/, $line;
	my $name="$infor[0]_$infor[5]_$infor[7]_$infor[8]";#用一个唯一确定的ID表示一个hit
	$start{$name}=$infor[7];
	$end{$name}=$infor[8];
	$ref_chr{$name}=$infor[5];
	$ref_strand{$name}=$infor[4];
	$ref_line{$name}=$line;
	$ref_name{$name}=$name;
	#$ref_len{$name}=$infor[1];
	
	
	$exact = $infor[10];#精确比对的长度，已除去overlap的了
	chop($infor[12]);
	my @tmp=split /[\,\;]/,$infor[12];#将比对到的基因组上的起始和终止位置放入@tmp	

	for(my $i=0;$i<$#tmp;$i+=2)
	{
		$size0 += $tmp[$i+1] - $tmp[$i] + 1;	#$size0是各个片断的总长，含有overlap的
	}
	#print "@tmp\n";
	unshift(@tmp,"1");
	@tmp = &cat(@tmp); #去overlap后各个genome上的block的起始和终止位置
	$ref_block{$name}=@tmp/2;#去overlap后的block的数目

	my $count=0;

	for(my $i=0;$i<@tmp-1;$i+=2)
	{
		$rough += $tmp[$i+1] - $tmp[$i] + 1;	#去除每个片段overlap的比到的实际长度
		$block_start{$name}->[$count]=$tmp[$i];
		$block_end{$name}->[$count]=$tmp[$i+1];
		$block_size{$name}->[$count]=$block_end{$name}->[$count]-$block_start{$name}->[$count]+1;
		#print "$block_start{$name}->[$count]\t$block_end{$name}->[$count]\t$block_size{$name}->[$count]\t$count\t$rough<<<\n";
		$count++;
	}
	$ref_len{$name}=$rough;
	$ref_identity{$name}=$exact/$ref_len{$name};
	#exit;

}
close Solar;




open Solar, "$ARGV[0]"||die "can not open $ARGV[0]\n";


while (my $line=<Solar>) {
	chomp $line;
	my @infor=split /\s+/, $line;
	my $name="$infor[0]_$infor[5]_$infor[7]_$infor[8]";
	my $new_start=$infor[7];
	my $new_end=$infor[8];
	my $chr=$infor[5];
	
	foreach my $key (keys %ref_line) {
		if ($chr ne $ref_chr{$key}) {next;} #不在同一染色体上的跳出
		if ($name eq $key) {next;}			#自己和自己不比
		else {
			if ($new_start > $end{$key} || $new_end < $start{$key}) {next;}		#无overlap的跳过
			else {

				if ($name lt $key) {$uniq{"$name\t$key"}->[0]=$name;$uniq{"$name\t$key"}->[1]=$key;}
				if ($key lt $name) {$uniq{"$key\t$name"}->[0]=$key;$uniq{"$key\t$name"}->[1]=$name;}
				
				}									
		}
	}

}
close Solar;

foreach my $key (keys %uniq) {#找出在exon上有overlap的
	for (my $i=0;$i<=$ref_block{$uniq{$key}->[0]}-1 ;$i++) {
		for (my $j=0; $j<=$ref_block{$uniq{$key}->[1]}-1;$j++) {
			if ($block_start{$uniq{$key}->[0]}->[$i] > $block_end{$uniq{$key}->[1]}->[$j] || $block_end{$uniq{$key}->[0]}->[$i] < $block_start{$uniq{$key}->[1]}->[$j]) {next;}#若exon上无overlap，跳过
			else {	
					print OUT "$uniq{$key}->[0]\t$ref_chr{$uniq{$key}->[0]}\t$ref_strand{$uniq{$key}->[0]}\t$ref_len{$uniq{$key}->[0]}\t$block_start{$uniq{$key}->[0]}->[$i]\t$block_end{$uniq{$key}->[0]}->[$i]\t$ref_block{$uniq{$key}->[0]}\texon_",$i+1,"\t$block_size{$uniq{$key}->[0]}->[$i]\t";
					print OUT "$block_start{$uniq{$key}->[0]}->[$i]\t$block_end{$uniq{$key}->[0]}->[$i]\n";
					print OUT "$uniq{$key}->[1]\t$ref_chr{$uniq{$key}->[1]}\t$ref_strand{$uniq{$key}->[1]}\t$ref_len{$uniq{$key}->[1]}\t$block_start{$uniq{$key}->[1]}->[$j]\t$block_end{$uniq{$key}->[1]}->[$j]\t$ref_block{$uniq{$key}->[1]}\texon_",$j+1,"\t$block_size{$uniq{$key}->[1]}->[$j]\t";
					print OUT "$block_start{$uniq{$key}->[1]}->[$j]\t$block_end{$uniq{$key}->[1]}->[$j]\n";
			}
		}
	}

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



exit

