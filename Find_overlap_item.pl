#!/usr/bin/perl -w

use strict;

open File1, "$ARGV[0]"||die ;
open File2, "$ARGV[1]"||die ;





my %start;
my %end;
my %chr;

while (<File1>) {
	chomp;
	my @infor=split;
	$start{$infor[0]}=$infor[3]+600;
	$end{$infor[0]}=$infor[4]-600;
	$chr{$infor[0]}=$infor[1];
}
close File1;

while (<File2>) {
	chomp;
	my @infor=split;
	my $tmp_start=$infor[3];
	my $tmp_end=$infor[4];
	my $tmp_chr=$infor[1];
	
	foreach my $key (keys %start) {#repeat µÄÎ»ÖÃ
		if ($tmp_chr ne $chr{$key}) {next;}
		if ($tmp_start>$end{$key} or $tmp_end < $start{$key}){next;}
		else{
			if ($tmp_start<=$start{$key} && $tmp_end>=$end{$key}) 
					{
						if (($start{$key}-$tmp_start+1)+($tmp_end-$end{$key}+1)>100) {print "$infor[0]\t$tmp_start\t$tmp_end\t$key\n";last;}
					}
			elsif ($tmp_start<=$start{$key} && $tmp_end>=$start{$key} && $tmp_end <=$end{$key})
					{
						if((($tmp_end-$start{$key}+1)/($end{$key}-$start{$key}+1)>0.3) && (($start{$key}-$tmp_start+1)>100)){print "$infor[0]\t$tmp_start\t$tmp_end\t$key\n";last;}
					}
			elsif($tmp_start<=$end{$key} && $tmp_start>=$start{$key} && $tmp_end >=$end{$key})
					{
						if ((($end{$key}-$tmp_start+1)/($end{$key}-$start{$key}+1)>0.3) && (($tmp_end-$end{$key}+1)>100)) {print "$infor[0]\t$tmp_start\t$tmp_end\t$key\n";last;}
					}
			elsif($tmp_start>$start{$key} && $tmp_end<$end{$key}){last;}
			else {print "$infor[0]\t$tmp_start\t$tmp_end\t$key\t$start{$key}\t$end{$key}\tWrong!!!!!!!!";exit;}
			}
		

	}
}
#15_random_2760605_2760721       15_random       +       2760005 2761321 88      220     SINE_TE SINE    V

