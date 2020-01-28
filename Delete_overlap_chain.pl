#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";

#chain 93751 chr1 229974691 + 59105866 59107369 chr19 63811651 + 11637556 11638904 108633
#chain 55214 chr1 229974691 + 111302664 111303314 chr1 247249719 - 103198447 103199097 191804
my %start;
my %end;
my %score;
my %uniq;
my %line;
my $id;
while (<IN>) {
	chomp;
	my @infor=split;
	$id=$infor[-1];
	$start{$id}=$infor[5];
	$end{$id}=$infor[6];
	$score{$id}=$infor[1];
	$line{$id}=$_;
}
close IN;

open IN,"$ARGV[0]" || die"$!";
while (<IN>) {
	chomp;
	my @infor=split;
	my $start=$infor[5];
	my $end=$infor[6];
	my $score=$infor[1];
	$id=$infor[-1];
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