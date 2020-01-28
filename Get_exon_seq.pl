#!/usr/bin/perl -w

open List, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Seq, "$ARGV[1]"||die "can not open $ARGV[0]\n";

open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";

my %seq;
my %format;
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

while (my $list_line=<List>) {
#AY071523,1      NM_135093       +       5538088 5538683 596     1       1
#BT015211,2      NM_079469       +       21012889        21013147        259     2       2

	chomp $list_line;
	my @infor=split /\s+/,$list_line;
	my $name=$infor[0];
		print OUT ">$infor[0]\t$infor[1]\n";
		print OUT $seq{$name};
}