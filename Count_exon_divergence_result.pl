#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
#open OUT,">$ARGV[1]" || die"$!";

#CB139301,2      BQ127421,2      100     100     87      87      unchange        0
#CT002444,1      BY180871,1      95.3125 97.8260869565217        69      69      up      2.51358695652171
#BX453720,3      CX231372,1      100     100     129     129     unchange        0

my %count;
my %count_removed_low;
while (<IN>) {
	chomp;
	my @infor=split;
	$count{$infor[-1]}++;
	if ($infor[2] eq "low" && $infor[3] eq "low") {next;}
	$count_removed_low{$infor[-1]}++;
}
foreach my $key (sort keys %count) {
if(!exists $count_removed_low{$key}){$count_removed_low{$key}=0;}
print "$key\t$count{$key}\t$count_removed_low{$key}\n";

}