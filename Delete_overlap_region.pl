#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";

#22680 chr1 229770044 229775197 chr1 246842150 246847294 + 469665
my %start;
my %end;
my %score;
my %uniq;
my %line;
my $id;
while (<IN>) {
	chomp;
	my @infor=split;
	$id=$infor[0];
	$start{$id}=$infor[2];
	$end{$id}=$infor[3];
	$score{$id}=$infor[-1];
	$line{$id}=$_;
}
close IN;

open IN,"$ARGV[0]" || die"$!";
while (<IN>) {
	chomp;
	my @infor=split;
	my $start=$infor[2];
	my $end=$infor[3];
	my $score=$infor[-1];
	$id=$infor[0];
	print ">>>\n";
	foreach my $key (keys %start) {
		if ($id==$key) {next;}

		if ($start>=$end{$key} or $end <=$start{$key}) {
			next;
		}
		else{
			if ($id lt $key) {$uniq{$id,"\t",$key}->[0]=$id;$uniq{$id,"\t",$key}->[1]=$key;}
			if ($key lt $id) {$uniq{$key,"\t",$id}->[0]=$key;$uniq{$key,"\t",$id}->[1]=$id;}
		}
	}
}

foreach my $key (keys %uniq) {
	if ($score{$uniq{$key}->[0]}>=$score{$uniq{$key}->[1]} ) {
		delete $start{$uniq{$key}->[1]};
	}
	else{
		delete $start{$uniq{$key}->[0]};
	}
}

foreach my $key (keys %start) {
	print OUT "$line{$key}\n";
}