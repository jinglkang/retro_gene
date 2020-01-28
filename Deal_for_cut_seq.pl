#!/usr/bin/perl -w

if (@ARGV<2) {
	print  "programm file_in file_out \n";
	exit;
}
open List,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";

#NM_207635       +       chrX    154824264       132530519       132530922
##NM_021483       -       chr3    199505740       181002321       181173741
#my %chr_size;
#while (<Chr>) {
#	chomp;
#	my @infor=split;
#	$chr_size{$infor[0]}=$infor[1];
#}
#close Chr;

while (<List>) {
	chomp;
	my @infor=split;
	my $start=$infor[4]-500000;
	my $end=$infor[5]+500000; #(fly ”√25000)
	if ($start<=1) {$start=1;}
	if ($end>=$infor[3]) {$end=$infor[3];}
	print OUT "$infor[0]\t$infor[2]\t$infor[1]\t$start\t$end\n";
}
exit