#!/usr/bin/perl -w

use strict;

open Seq1,"$ARGV[0]"||die "!";
open Seq2,"$ARGV[1]"||die '!';
open OUT,">$ARGV[2]"||die '!';


#若seq2的序列替换seq1的同名序列，即seq2的序列优先


my %seq;
my %format;
my $name;
while (my $seq_line=<Seq1>) {
	chomp $seq_line;
	if ($seq_line=~/^>([^\s+]+)/) {
	 $name=$1;
	 if (!exists $format{$name}) { $format{$name}=$seq_line;}
	 else {$seq{$name}='';}
	}
	else {$seq{$name}.=$seq_line;}
}
close Seq1;

my %seq2;
my %format2;
while (my $seq_line2=<Seq2>) {
	chomp $seq_line2;
	if ($seq_line2=~/^>([^\s+]+)/) {
	 $name=$1;
	 if (!exists $format2{$name}) { $format2{$name}=$seq_line2;}
	 else {$seq2{$name}='';}
	}
	else {$seq2{$name}.=$seq_line2;}
}
close Seq2;

my $count;
foreach my $key (keys %seq) {
	if (exists $seq2{$key}) {
		$count++;
		print OUT "$format{$key}\n$seq2{$key}\n";
	}
	else
	{
		print OUT "$format{$key}\n$seq{$key}\n";
	}
}

print "$count sequences changed!\n";