#!/usr/bin/perl -w

use strict;
open IN,"$ARGV[0]" || die"$!";
open List,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";

#BY378295        NM_201364       2
#AK158934        NM_009447       3

#>AK097416,2     NM_152616       +
#AAAAAAAA
my %ref;
while (<List>) {
	chomp;
	my @infor=split;
	$ref{$infor[0]}=$infor[1];
}

while (<IN>) {
	chomp;
	if (/^>/) {
		my @infor=split;
		my $name=(split /,/, $infor[0])[0];
		$name=~s/>//;
		if (!exists $ref{$name}) {print OUT $_,"\n";}
		else{
			#print ">>>>>>>>>>>>>>>>>>\n";
			print OUT "$infor[0]\t$ref{$name}\t";
			for (my $i=2;$i<@infor ;$i++) {
				print OUT $infor[$i],"\t";
			}
			print OUT "\n";
		}
	}
	else {print OUT $_,"\n";}
}