#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";


open Homo,"$ARGV[2]" || die"$!";

open OUT,">$ARGV[3]" || die"$!";

#Hs.469728       8030    6203    9770    8082    8415    5636    17758   9302    7676    8211    8448    6426    7940    76446048     6984    4860    5661    6927    7363    6721    34763   7060    6371    5841    5791
my %homo;
while (<Homo>) {
	chomp;
#NM_000302       NM_011122       Hs.75093        Mm.37371
#NM_003038       NM_018861       Hs.323878       Mm.6379
	my @infor=split;

	$homo{$infor[2]}=$infor[3];
}

my %r;
my %num;
my $count;
while (my $line=<IN>) {
	chomp $line;
	my @infor=split /\s+/,$line;
	my $name=$infor[0];
	$count++;
	print "$count\n";

	open IN_2,"$ARGV[1]" || die"$!";
	while (my $line_2=<IN_2>) {
		chomp $line_2;
		my @infor_2=split /\s+/,$line_2;
		
		if (!exists $homo{$infor[0]}) {next;}
		if ("$infor_2[0]" eq "$homo{$infor[0]}") {

			my $total;
			for (my $i=1;$i<@infor ;$i++) {
				$total+=abs($infor[$i]-$infor_2[$i]);
			}
			$r{"$infor[0]\t$infor_2[0]"}+=$total/(scalar @infor-1);
			$num{"$infor[0]\t$infor_2[0]"}++;

		}

	}
	close IN_2;
}

foreach my $key (keys %r) {
	print OUT "$key\t",$r{$key}/$num{$key},"\n";
}