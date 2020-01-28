#!/usr/bin/perl -w
use Getopt::Long;
use strict;
my $Function='get sequences from list';

my %opts;

GetOptions(\%opts,"l:s","s:s","o:s","help");


if(!defined($opts{l}) || !defined($opts{s}) || !defined($opts{o}) || defined($opts{help}) ){
	
	Usage();
	
}

open List, "$opts{l}"||die "can not open $opts{l}\n";
open Seq, "$opts{s}"||die "can not open $opts{s}\n";

open OUT, ">$opts{o}"||die "can not open $opts{o}\n";

my %seq;
my %format;
my $name;
while (my $seq_line=<Seq>) {
	#my $name;
	#chomp $seq_line;
	if ($seq_line=~/^>([^\s+]+)/) {
	 $name=$1;
	 if (!exists $format{$name}) { $format{$name}=$seq_line;}
	 else {$seq{$name}='';}
	}
	else {$seq{$name}.=$seq_line;}
}

my $count=0;
while (my $list_line=<List>) {
	chomp $list_line;
	my $name=(split /\s+/,$list_line)[0];
	if (exists $seq{$name}) {
		print OUT ">gene_$count\n".$seq{$name};
		print "$name\t$count\n";
		$count++;
	}
}

sub Usage {
    print << "    Usage";
    
	$Function

	Usage: $0 <options>

		-l            list wanted sequences

		-s            sequence file
		
		-o            output file
		
		-h or -help   Show Help , have a choice

    Usage
	exit;

}