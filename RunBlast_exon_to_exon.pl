#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Seq1,"$ARGV[0]" || die"$!";
open Seq2,"$ARGV[1]" || die"$!";
open List,"$ARGV[2]" || die"$!";
open OUT,">$ARGV[3]" || die"$!";


my %seq1;
my %format1;
my $name;
while (<Seq1>) {
	chomp;
	if (/^>([^\s+]+)/) {
	 $name=$1;
	 if (!exists $format1{$name}) { $format1{$name}=$_;}
	 else {$seq1{$name}='';}
	}
	else {$seq1{$name}.=$_;}
}
close Seq1;

my %seq2;
my %format2;
my %group;
while (<Seq2>) {
	chomp;
	if (/^>([^\s+]+)/) {
	 $name=$1;
	 my @infor=split;
	 $group{$infor[1]}.="$name\t";
	 if (!exists $format2{$name}) {$format2{$name}=$_;}
	 else {$seq2{$name}='';}
	}
	else {$seq2{$name}.=$_;}
}
close Seq2;

#NM_172754       NM_001009538    Mm.24056        Rn.17914

#>BC057147,4     NM_033078
#TATTGTGCAACAAGGAAGTCCCAGTTTCCTCAAGAG

#>BC082015,3     Rn.162458
#AGATGCTGTTCAGTTAAATGTGATTGCTACACGACAG

my %homo;
while (<List>) {
	chomp;
	my @infor=split;
	$homo{$infor[0]}=$infor[-1];
}
close List;

foreach my $key (keys %seq1) {
	open Query, ">query.tmp"||die '!';
		print Query ">$key\n$seq1{$key}\n";
	close Query;
	my $tmp=(split /\s+/,$format1{$key})[1];
	if (!exists $homo{$tmp}) {next;}
	my $ugid=$homo{$tmp};
	#print ">>>>>>>>$key\t$tmp\t$ugid\n";
	open Database, ">database.tmp"||die '!';
	if (!exists $group{$ugid}) {next;}
	my @data=split /\t/, $group{$ugid};
		foreach my $item (@data) {
			print Database ">$item\n$seq2{$item}\n";
		}
	close Database;
	
	system ("formatdb -i database.tmp -p F");
	system ("blastall -p blastn -i query.tmp -d database.tmp -e 1e-6 -F F -q -1 -W 7 -G 3 -E 1 -o tmp.bla");

	open TMP, "tmp.bla";
		my @bla=<TMP>;
		print OUT @bla;
	close TMP;
	#last;
}