#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";

#Hs.247729       350.810126582278        -0.00973494017915456

my %old_num;
my %new_num;

while (<IN>) {
	chomp;
	my @infor=split;

#	if ($infor[5]>=0 && $infor[5]<=200) {$infor[5]=200;}
#	elsif($infor[5]>200 && $infor[5]<=400) {$infor[5]=400;}
#	elsif($infor[5]>400 && $infor[5]<=800) {$infor[5]=800;}
#	elsif($infor[5]>800 && $infor[5]<=1600) {$infor[5]=1600;}
#	elsif($infor[5]>1600) {$infor[5]=2000;}

if($infor[5]>0 && $infor[5]<=0.1) {$infor[5]=0.1;}
elsif($infor[5]>0.1 && $infor[5]<=0.15) {$infor[5]=0.15;}
elsif($infor[5]>0.15 && $infor[5]<=0.2) {$infor[5]=0.2;}
elsif($infor[5]>0.2 && $infor[5]<=0.25) {$infor[5]=0.25;}
elsif($infor[5]>0.25 && $infor[5]<=0.3) {$infor[5]=0.3;}
elsif($infor[5]>0.3 && $infor[5]<=0.35) {$infor[5]=0.35;}
elsif($infor[5]>0.35 && $infor[5]<=0.4) {$infor[5]=0.4;}
elsif($infor[5]>0.4 && $infor[5]<=0.45) {$infor[5]=0.45;}
elsif($infor[5]>0.45 && $infor[5]<=0.5) {$infor[5]=0.5;}
elsif($infor[5]>0.5) {$infor[5]=0.55;}
else {print "Wrong!\n";exit}
#Hs.315167	0	8	0	Hs.315167	0.249692412	305.9493671	1405.5	419.9375	48

if ($infor[1]==0) {
	$old_num{$infor[5]}++;
}	
else{$new_num{$infor[5]}++;}
}
close IN;

foreach my $key (sort keys %old_num) {
	print "$key\t$old_num{$key}\t$new_num{$key}\n";
}

