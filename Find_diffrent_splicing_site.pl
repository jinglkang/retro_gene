#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open List,"$ARGV[0]" || die"$!";
open Human,"$ARGV[1]" || die"$!";
open Mouse,"$ARGV[2]" || die"$!";


#BP370723,1      BI652496,2      major   constitutive    123     123
#CD617061,5      BQ770433,1      major   constitutive    96      96

#BG483229,4      AG      GT      AC      GT      +

my %human_left;
my %human_right;
my %mouse_left;
my %mouse_right;

while (<Human>) {
	chomp;
	my @infor=split;
	$human_left{$infor[0]}=uc($infor[1]);
	$human_right{$infor[0]}=uc($infor[2]);
}
close Human;

while (<Mouse>) {
	chomp;
	my @infor=split;
	$mouse_left{$infor[0]}=uc($infor[1]);
	$mouse_right{$infor[0]}=uc($infor[2]);
}
close Mouse;

my %hash;
while (<List>) {
	chomp;
	my @infor=split;
	#print "$infor[0]\t$human_left{$infor[0]}\t$mouse_left{$infor[0]}\t$human_right{$infor[0]}\t$mouse_right{$infor[0]}\n";
	if (!exists $human_left{$infor[0]} or !exists $mouse_left{$infor[1]}) {next;}
		my $human_tmp1=substr($human_left{$infor[0]},0,1);
		my $human_tmp2=substr($human_left{$infor[0]},1,1);
		my $human_tmp3=substr($human_right{$infor[0]},0,1);
		my $human_tmp4=substr($human_right{$infor[0]},1,1);
		
		my $mouse_tmp1=substr($mouse_left{$infor[1]},0,1);
		my $mouse_tmp2=substr($mouse_left{$infor[1]},1,1);
		my $mouse_tmp3=substr($mouse_right{$infor[1]},0,1);
		my $mouse_tmp4=substr($mouse_right{$infor[1]},1,1);

		if ($human_tmp1 ne $mouse_tmp1) {$hash{$infor[0]}++;}
		if ($human_tmp2 ne $mouse_tmp2) {$hash{$infor[0]}++;}
		if ($human_tmp3 ne $mouse_tmp3) {$hash{$infor[0]}++;}
		if ($human_tmp4 ne $mouse_tmp4) {$hash{$infor[0]}++;}

		print "$_\t$hash{$infor[0]}\n";
	#last;
}
close List;