#!/usr/bin/perl -w

use strict;

open IN,     "$ARGV[0]"||die '!';
open Family, "$ARGV[1]"||die '!';
open OUT1,  ">$ARGV[2]"||die '!';
open OUT2,  ">$ARGV[3]"||die '!';

#GSTENP00001573001_Un_random_58000001-88000000_14351219_14351782	564	4	564	+	GSTENP00008713001_Un_random_29000001-59000000_24112673_24119810	4620	4129	4617	2	483	4,405;470,564;	4129,4527;4523,4617;	+393;+95;	0	
#GSTENP00034950001_Un_random_87000001-117000000_27994026_27994386	357	1	357	+	GSTENP00034950001_Un_random_87000001-117000000_6009448_6040355	396	10	396	2	323	1,279;293,357;	10,279;333,396;	+263;+60;	1


#GSTENP00001573001_Un_random_58000001-88000000_14351219_14351782 1       GSTENP00008713001_Un_random_29000001-59000000_24112673_24119810       10
my %fam;
my %fam_id;
my $count;
while (<Family>) {
	chomp;
	$count++;
	my @infor=split;
	my $single_num;
	for (my $i=0;$i<@infor-1 ;$i+=2) {
		if ($infor[$i+1]==1) {$single_num++;}
	}

	for (my $i=0;$i<@infor-1 ;$i+=2) {
		$fam{$infor[$i]}=$single_num;
		#if ($infor[$i] eq "ENSDARP00000039663_15_43023666_43030265"){print ">>>>>>>>>>>>\n";}
		$fam_id{$infor[$i]}=$count;
	}
}
close Family;



while (<IN>) {
	chomp;
	my @infor=split;
	if ($infor[-1]==0) {
		print OUT1 "$_\n";
	}
	else {print OUT2 "$fam_id{$infor[0]}\n";}
}