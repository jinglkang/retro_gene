#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Seq1,"$ARGV[0]" || die"!";

open Seq2,"$ARGV[1]" || die"!";
open List,"$ARGV[2]" || die"!";

my %format;
my $name;
my %seq;
while (my $seq_line=<Seq1>) {
	chomp $seq_line;
	if ($seq_line=~/^>([^\s+]+)/) {
	$name=$1;
	
	#print $name,"\n";
	#exit;
	 if (!exists $format{$name}) { $format{$name}=$seq_line;}
	 else {$seq{$name}='';}
	}
	else {$seq{$name}.=$seq_line;}
}


while (my $seq_line=<Seq2>) {
	chomp $seq_line;
	if ($seq_line=~/^>([^\s+]+)/) {
	$name=$1;
	 if (!exists $format{$name}) { $format{$name}=$seq_line;}
	 else {$seq{$name}='';}
	}
	else {$seq{$name}.=$seq_line;}
}

#CD607143,3      138     1       138     +       BI851616,2      138     1       
my $seq1;
my $seq2;
while (<List>) {
	chomp;
	my @infor=split;
	#print "$infor[0]\t$infor[5]\n";
	#print "$seq{$infor[0]}\n$seq{$infor[5]}\n";
	$seq1.=$seq{$infor[0]};
	$seq2.=$seq{$infor[5]};
}

print ">seq1\n$seq1\n>seq2\n$seq2\n";