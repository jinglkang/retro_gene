#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die "!";



my @tissue_name;
my %measure;
my %expression;

my %num;

while (<IN>) {
	chomp;
	my %probe;
	my $tag=0;

	my $highist=0;
	if (/^Dataset/) {
		my @infor=split /\t/,$_;
		for (my $i=0; $i<@infor;$i++) {
			$tissue_name[$i]=lc($infor[$i]);
			$tissue_name[$i]=~s/\s+//;
		}
		#last;
	}
	else{
		my @infor=split;
		for (my $i=1;$i<@infor;$i++) {
			#if ($infor[$i]<100) {$infor[$i]=100;}
			if ($infor[$i]>200) {$tag=1;}
			$probe{$tissue_name[$i]}+=$infor[$i];
		}
		
		if ($tag!=1) {next;}
		foreach my $key (keys %probe) {if ($probe{$key}>$highist) {$highist=$probe{$key};}}


		my $tmp; my $tmp_exp;
		foreach my $key (keys %probe) {

		$tmp+=1-log($probe{$key})/log($highist);
		$tmp_exp+=$probe{$key};
			#$tmp+=1-$probe{$key}/$highist;
			#$tmp+=1-sqrt($probe{$key})/sqrt($highist);
		}
		$measure{$infor[0]}+=$tmp/((scalar @infor)-2);
		$expression{$infor[0]}+=$tmp_exp/((scalar @infor)-1);
		#print scalar @infor-1,"\n";exit;
		$num{$infor[0]}++;
	}
}

foreach my $key (keys %measure) {
	print "$key\t",$measure{$key}/$num{$key},"\t",$expression{$key}/$num{$key},"\n";
}


