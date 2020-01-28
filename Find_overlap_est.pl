#!/usr/bin/perl -w

use strict;
open Est, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Ref, "$ARGV[1]"||die "can not open $ARGV[1]\n";

open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";

#1293	432	3	0	0	1	1	2	6411	+	AL137623	624	0	436	chr9	138429268	92919800	92926646	4	30,132,266,7,	0,30,162,429,	92919800,92921307,92926373,92926639,	Hs.2	2	678
#910	2465	0	91	0	0	0	7	23178	+	NM_003758	2558	0	2556	chr15	100338915	42616557	42642291	8	170,104,55,92,115,162,74,1784,	0,170,274,329,421,536,698,772,	42616557,42616813,42630365,42630920,42634042,42636978,42639738,42640507,	H.2	3	456
#                                                       10                            14                                                                                                                                                                                         22  23   24    

#BX648497,       NM_153713       +       32      148306

my %ref_start;
my %ref_end;
my %ref_chr;
while (<Ref>) {
	chomp;
	my @infor=split;
	my $name=$infor[10];
	$ref_start{$name}=$infor[16];
	$ref_end{$name}=$infor[17];
	$ref_chr{$name}=$infor[14];
}


#my %est;
my $est_start;
my $est_end;
my $est_chr;
my %tag;
my %overlap_ref;
while (<Est>) {
	chomp;
	my @infor=split;
	my $name=$infor[10];
	$est_start=$infor[16];
	$est_end=$infor[17];
	$est_chr=$infor[14];
	foreach my $key (keys %ref_start) {
		if ($est_chr ne $ref_chr{$key}) {next;}
		if ($est_start > $ref_end{$key} or $est_end < $ref_start{$key}) {next;}
		else {$tag{$name}++; $overlap_ref{$name}.="$key\t";}
	}
}

foreach my $key (keys %tag) {
	if ($tag{$key}>1) {
	print OUT "$key\t$overlap_ref{$key}\t$tag{$key}\n";
	}
}

