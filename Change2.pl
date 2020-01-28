#!/usr/bin/perl
#author luzhk
#BGI 
#input format:exon_00004683	AB005298	chr1	-	31869877	31869975	99	1	2
#outpur format:exon_00004683	AB005298	chr1	-	31869877	31869975	99	type (coverage/100.0)	1
use strict;
if (@ARGV<2) {
	print "usage:\t Change2.pl ExonPos.2.xls ExonPos.result.xls";
	exit;
}
my $arg = shift;
open IN,"$arg";
$arg = shift;
open OUT,">$arg";
my $line;
while (defined ($line = <IN>)) {
	my @splitLine = split /\t/,$line;
	my $type;
	if ($splitLine[7]==0) {print ">>>>>>>>>>>>>>>>>>$_\n";}
	my $coverage = 10000*$splitLine[6]/$splitLine[7];
	
	if ($coverage == 10000) {$type = "constitutive"}
	elsif ($coverage >= 6700) {$type = "major"}
	elsif ($coverage > 3300) {$type = "middle"}
	else {$type = "minor"};
	if($splitLine[6] < 5) {$type = "low";}
	if($coverage > 10000) {$type = "wrong";}
	$coverage = $coverage/100;
	print OUT "$splitLine[0]\t$splitLine[1]\t$splitLine[2]\t$splitLine[3]\t$splitLine[4]\t$splitLine[5]\t$type\t$coverage\t$splitLine[6]\t$splitLine[7]";

}
print "Hello, World...\n";

#exon_000001	NM_000153	-	200	300	100	constitute	100	4	6
