#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
#open OUT,">$ARGV[1]" || die"$!";

#>BC106072,5     1
#
#>AY562396,3     1
#
#>DB192483,3     3
#brain   18325
#ovary   18527
#uterus  18523

#subthalamic nerve_tissue brain

#testis
my $name;
my %total_est;
my %brain_est;
my %testis_est;
my %liver_est;
my %kidney_est;
my %pancreas_est;

while (<IN>) {
	chomp;
	my @infor=split;
	if (/^>/) {
		$name=$infor[0];
		$name=~s/>//;
	}
	else
	{
		$total_est{$name}++;
		if (/subthalamic|nerve_tissue|brain/) {$brain_est{$name}++;}
		if (/testis/) {$testis_est{$name}++;}
		if (/liver/) {$liver_est{$name}++;}
		if (/kidney/) {$kidney_est{$name}++;} 
		if (/pancreas/) {$pancreas_est{$name}++;}

	}
}

foreach my $key (keys %total_est) {
	if (!exists $brain_est{$key}) {$brain_est{$key}=0;}
	if (!exists $testis_est{$key}) {$testis_est{$key}=0;}
	if (!exists $liver_est{$key}) {$liver_est{$key}=0;}
	if (!exists $kidney_est{$key}) {$kidney_est{$key}=0;}
	if (!exists $pancreas_est{$key}) {$pancreas_est{$key}=0;}
	#print "$key\t$brain_est{$key}\t$total_est{$key}\t",$brain_est{$key}/$total_est{$key}*100,"\n";
	print "$key\t$testis_est{$key}\t$total_est{$key}\t",$testis_est{$key}/$total_est{$key}*100,"\n";
	#print "$key\t$liver_est{$key}\t$total_est{$key}\t",$liver_est{$key}/$total_est{$key}*100,"\n";
	#print "$key\t$kidney_est{$key}\t$total_est{$key}\t",$kidney_est{$key}/$total_est{$key}*100,"\n";
	#print "$key\t$kidney_est{$key}\t$total_est{$key}\t",$kidney_est{$key}/$total_est{$key}*100,"\n";
}