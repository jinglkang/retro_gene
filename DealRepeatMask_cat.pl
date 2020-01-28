#!/usr/bin/perl -w

use strict;
open IN, "$ARGV[0]"||die '!';
open OUT,">$ARGV[1]"||die '!';

my %start;
my %end;
my $name;
my %class;
my %family;
my %repeat;
my %chr;
my %strand;
my %q_start;
my %q_end;

while (<IN>) {
	chomp;
	if (!/^\d+/) {
		next;
	}
	my @infor=split;
	$name="$infor[4]_$infor[5]_$infor[6]";
	$start{$name}=$infor[5];
	$end{$name}=$infor[6];
	$chr{$name}=$infor[4];
	if (/(\w+)\#(\w+)\/(\w+)/) {
	#	print "$1\t$2\t$3\n";
		$class{$name}=$2;
		$family{$name}=$3;
		$repeat{$name}=$1;
	}
	elsif(/([^\#|\s+]+)\#(\w+)/)
	{
		#print "$1\t$2\n";
		$class{$name}=$2;
		$repeat{$name}=$1;
		$family{$name}=$2;
	}

	if ($infor[-4]=~/\(/) {$q_start{$name}=$infor[-2];$q_end{$name}=$infor[-3];$strand{$name}="-";}
	if ($infor[-2]=~/\(/) {$q_start{$name}=$infor[-4];$q_end{$name}=$infor[-3];$strand{$name}="+";}

}

foreach my $key (keys %class) {
	my $new_start;my $new_end;
	if ($start{$key}-600<=0) {$new_start=1}else{$new_start=$start{$key}-600;}
	$new_end=$end{$key}+600;
	print OUT "$key\t$chr{$key}\t$strand{$key}\t",$new_start,"\t",$new_end,"\t$q_start{$key}\t$q_end{$key}\t$repeat{$key}\t$class{$key}\t$family{$key}\n";
}


#												起始和终止位置					class/family					query起始终止	ID
#312	 23.07	0.00	8.08	scaffold_11265	84	       182		(2149)	C	SINE_FR1d#SINE/Mermaid	(22)	280		190		5
#555 1.56 0.00 0.00 scaffold_589 35549 35612 (36380) (CCCTAA)n#Simple_repeat 2 65 (115) 0

