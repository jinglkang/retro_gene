#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";

#net chr1 229974691
# fill 77636 78340 chr1 + 77634 77475 id 2037 score 1101845 ali 16360 qDup 65606 type top tN 56455 qN 0 tR 16802 qR 38340 tTrf 640 qTrf 2721
#  gap 78679 5072 chr1 + 78732 4885 tN 5072 qN 0 tR 0 qR 2025 tTrf 0 qTrf 510
#  gap 256293 1789 chr1 + 109375 0 tN 10 qN 0 tR 542 qR 0 tTrf 97 qTrf 0
#   fill 256293 1789 chr1 + 255696 380047 id 2037 score 119075 ali 1768 qOver 0 qFar 146321 qDup 81486 type syn tN 10 qN 100000 tR 542 qR 152293 tTrf 97 qTrf 16847
#    gap 256770 1 chr1 + 256176 0 tN 0 qN 0 tR 0 qR 0 tTrf 0 qTrf 0
my $parent_id;
my $child_id;
my $gap_name;
my $tag=0;
while (<IN>) {
	chomp;
	if (/^\#/) {next}
	if (/^net/) {
		my $chr=(split /\s+/,$_)[1];
		
		if ($tag==1) {close OUT;close OUT2;}
		$tag=1;
		open OUT, ">$chr.gap"||die '!';
		open OUT2, ">$chr.child_chain"||die '!';
	}
	if (/^\sfill.*id\s(\d+)\s.*/) {
		$parent_id=$1;
	}
	if (/^\s\sgap/) {
		my @infor=split;
		my $gap_end=$infor[1]+$infor[2]-1;
		$gap_name="$infor[1]_$gap_end";
		if($infor[2]>=100){print OUT "$infor[1]\t$gap_end\t$infor[2]\t$parent_id\t$infor[8]\t$infor[12]\n";}
	}
	if (/^\s\s\sfill/) {
#   fill 256293 1789 chr1 + 255696 380047 id 2037 score 119075 ali 1768 qOver 0 qFar 146321 qDup 81486 type syn tN 10 qN 100000 tR 542 qR 152293 tTrf 97 qTrf 16847
#	0		1	  2    3  4   5      6     7   8   9      10    11  12    13  14  15    16   17   18    19   20
#	fill 131079 4482 chr16 - 88757655 1720 id 6119 score 68272 ali 914 qDup 1720 type nonSyn
		#print ">>>>>>>>>>>>>>>>>>>>";
		my @infor=split;
		my $fill_end=$infor[1]+$infor[2]-3;
			my $qFar;
			my $qDup;
			my $type;
			my $N_len;

		if (/nonSyn/) {
			$qFar="NA";
			$qDup=$infor[14];
			$type=$infor[16];
			$N_len=$infor[18];
		}
		else{
			$qFar=$infor[16];
			$qDup=$infor[18];
			$type=$infor[20];
			$N_len=$infor[22];
		}
		print OUT2 "$infor[1]\t$fill_end\t$infor[2]\t$parent_id\t$N_len\t$gap_name\t$qFar\t$qDup\t$type\n";
	}
}