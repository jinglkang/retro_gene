#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";
my $len=2000;
my $start;
my $end;
#BI857651,4      4074    1       1134    +       NM_005676       183963  84485   85601   2       992     1,832;954,1134; 84485,85314;85423,85601; 
while (<IN>) {
	chomp;
	my @infor=split;
	if ($infor[4] eq '+') {
		if ($infor[3]<($infor[1]-$len) && $infor[3]>$len && $infor[2]<$len) {if (($infor[3]-$len+1)/($infor[1]-2*$len)<0.5) {$infor[3]=$len-1;}else{print $infor[3]-$len+1,"\t",$infor[1]-2*$len,"\n",$_,"\t>>>>>1\n";next;}}
		if ($infor[2]<($infor[1]-$len) && $infor[2]>$len && $infor[3]>$len) {if (($infor[1]-$len-$infor[2]+1)/($infor[1]-2*$len)<0.5) {$infor[2]=$len+($infor[1]-2*$len)+1;}else{print $_,"\t>>>>>2\n";next;}}
		if ($infor[3]<=$len) {
			my $tmp=$infor[1]-$len-$infor[3];
			$start=$infor[8];
			$end=$start+$tmp+$len;
			print OUT "$infor[0]\t$infor[5]\t$start\t$end\n";
		}
		elsif($infor[2]>=$len+($infor[1]-2*$len)) {
			$start=$infor[7]-$infor[2];
			$end=$infor[7];
			print OUT "$infor[0]\t$infor[5]\t$start\t$end\n";
		}
		else {print "$_\n11111111111111111111111";}
	}
	else {
		if ($infor[3]<($infor[1]-$len) && $infor[3]>$len && $infor[2]<$len) {if (($infor[3]-$len+1)/($infor[1]-2*$len)<0.5) {$infor[3]=$len-1;}else{print $_,"\t>>>>>3\n";next;}}
		if ($infor[2]<($infor[1]-$len) && $infor[2]>$len && $infor[3]>$len) {if (($infor[1]-$len-$infor[2]+1)/($infor[1]-2*$len)<0.5) {$infor[2]=$len+($infor[1]-2*$len)+1;}else{print $_,"\t>>>>>4\n";next;}}
#		BG996817,1      4094    2048    4094    -       NM_015124       481800  364271  366337  3       1946    2048,3566;3623,3927;3902,4094;       366337,364825;364779,364475;364463,364271;      -1486;-296;-189;        >>>>>4

		if ($infor[3]<=$len) {
			$end=$infor[7];
			$start=$infor[7]-($infor[1]-$infor[3]);
			print OUT "$infor[0]\t$infor[5]\t$start\t$end\n";
		}
		elsif ($infor[2]>=$len+($infor[1]-2*$len))
		{
			$start=$infor[8];
			my $tmp=$infor[2]-($infor[1]-$len);
			$end=$start+$tmp+$len;
			print OUT "$infor[0]\t$infor[5]\t$start\t$end\n";
		}
		else {print "$_\n2222222222222222222222222";}
	
	
	}
}