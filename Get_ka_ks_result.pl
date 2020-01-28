#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open List,"$ARGV[1]" || die"$!";

#Name	Length of i-fold degenerate site(Li)	Transitional(Si) and Transversional(Vi) differences	Value of Ka	Value of Ks	Value of Ka/Ks	Value of P	Length of cluster	Number of snp	Number of Idel	Times of Idel	Flag	Standard error of Ka	Standard error of Ks
#DA864792,3_AK122255,7.out	L(0):33.50|L(2):8.50|L(4):12.00|	S(0):0.00|V(0):0.00|S(2):1.00|V(2):0.00|S(4):3.00|V(4):3.00|	0	0.706497813112504	0	[1]	54	7	0	0	1	0	0.335175558390884	0	0	11.5373296514266	0	7	0

#NM_001024400_NM_001024400_scaffold_656_44975_45352.out

my $name;
my $L0;
my $L2;
my $L4;
my %num_of_ka;
my %num_of_ks;
my %ka;
my %ks;
my %ka_ks;
my %p;
my %q;
my $a0;my $a2;my $a4;
my $b0;my $b2;my $b4;
my $A0;my $A2;my $A4;
my %s;my %v;
my $B0;my $B2;my $B4;

while (<IN>) {
	chomp;
	if (/some error in this line/) {next;}
	if (/^Name/) {next;}
	my @infor=split;
	my @tmp=split /\.out/, $infor[0];

	$name=$tmp[0];
	
	#$name="$tmp_2[0]\t$tmp_2[1]";
	#print "$tmp_2[0]\t$tmp_2[1]\n";exit;
	if ($infor[1]=~/.*:(.+)\|.*:(.+)\|.*:(.+)\|/) {$L0=$1;$L2=$2;$L4=$3;}
	if ($infor[2]=~/.*:(.+)\|.*:(.+)\|.*:(.+)\|.*:(.+)\|.*:(.+)\|.*:(.+)\|/) {$s{0}=$1;$v{0}=$2,$s{2}=$3;$v{2}=$4;$s{4}=$5,$v{4}=$6;}
	
#	$p{0}=$s{0}/$L0; $q{0}=$v{0}/$L0;
#	$p{2}=$s{2}/$L2; $q{2}=$v{2}/$L2;
#	$p{4}=$s{4}/$L4; $q{4}=$v{4}/$L4;
#
#	$a0=1/(1-2*$p{0}-$q{0});
#	$a2=1/(1-2*$p{2}-$q{2});
#	$a4=1/(1-2*$p{4}-$q{4});
#
#	$b0=1/(1-2*$q{0});
#	$b2=1/(1-2*$q{2});
#	$b4=1/(1-2*$q{4});
#
#
#
#	if ($a0<=0 or $a2<=0 or $a4<=0 or $b0<=0 or $b2<=0 or $b4<=0) {next;}
#
#	$A0=1/2*log($a0)-1/4*log($b0);
#	$A2=1/2*log($a2)-1/4*log($b2);
#	$A4=1/2*log($a4)-1/4*log($b4);
#
#	$B0=1/2*log($b0);
#	$B2=1/2*log($b2);
#	$B4=1/2*log($b4);

	#print "$s{0}\t$v{0}\t$s{2}\t$v{2}\t$s{4}\t$v{4}\n";
#	if (($L0+$L2+$L4)<150) {next;}
if ($infor[5]==-1) {next;}
	$num_of_ka{$name}=2/3*$L2+$L0;
	$num_of_ks{$name}=1/3*$L2+$L4;
	$ks{$name}=$infor[4];
	$ka{$name}=$infor[3];
	$ka_ks{$name}=$infor[5];
}
close IN;

while (<List>) {
	chomp;
	my @infor=split;
	if (exists $num_of_ka{"$infor[0]_$infor[1]"}) {
		print "$_\t",$num_of_ka{"$infor[0]_$infor[1]"},"\t",$num_of_ks{"$infor[0]_$infor[1]"},"\t",$ka{"$infor[0]_$infor[1]"},"\t",$ks{"$infor[0]_$infor[1]"},"\t",$ka_ks{"$infor[0]_$infor[1]"},"\n";	}
}