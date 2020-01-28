#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Seq,"$ARGV[0]" || die"$!";
open List,"$ARGV[1]" || die"$!";
open OUT,">$ARGV[2]" || die"$!";

#>BC082015,3     NM_001011933
#AGATGCTGTTCAGTTAAATGTGATTGCTA

#BQ194853        Noinfor Rn.1    Noinfor Noinfor
#BU758764        Noinfor Rn.1    Noinfor Noinfor

my %est_ugid;
while (<List>) {
	chomp;
	my @infor=split;
	$est_ugid{$infor[0]}=$infor[2];
}
close List;

while (<Seq>) {
	chomp;
	if (/>/) {
		my @infor=split;
		my $tmp=$infor[1];
		$tmp=~s/>//;
		print OUT "$infor[0]\t$est_ugid{$tmp}\n";
	}
	else{print OUT $_,"\n";}

}