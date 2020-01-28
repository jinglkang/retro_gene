#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Few, "$ARGV[0]" || die"$!";
open Much, "$ARGV[1]" || die"$!";

#>BC000349,4     9
#IPLIHRAL*LAQRPVSLLANPWTSPTRLKISGAGNGKVSLKGQPGDIYHQTWARYFV

my %pos;
while (<Much>) {
	chomp;
	if (/^>/) {
		my @infor=split;
		my $name=$infor[0];
		$name=~s/>//;
		#print $name,"\t",scalar @infor,"<<<<<<<<<<<<\n";
		for (my $i=1;$i<=@infor-1 ;$i++) {
			$pos{$name}.="$infor[$i]\t";
			#print ">>>>>>>>>$pos{$name}\n";
		}
		
	}
}

my %tag;
while (<Few>) {
	chomp;
	if (/^>/) {
		my @infor=split;
		my $name=$infor[0];
		$name=~s/>//;
		#print ">>>>>>>>>",scalar @infor,"\n";
		for (my $i=1;$i<=@infor-1 ;$i++) {
			my @tmp=split /\t/,$pos{$name};
			foreach my $item (@tmp) {
				if ($item == $infor[$i]) {
					$tag{$name}=1;
					last;
				}
			}
		}
	}
}

foreach my $key (keys %tag) {
	print "$key\n";
}