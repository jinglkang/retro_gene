#!/usr/bin/perl -w

use strict;
open IN, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Chr, "$ARGV[1]"||die "can not open $ARGV[1]\n";

open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";

#NM_146017       -       chr10_1-20000000        18479809        18454368        18479809
#NM_027398       -       chr10_1-20000000        18784835        18550229        18566838
#NM_031169       +       chr10_1-20000000        18914065        18907571        18914065
#NM_010696       +       chr10_19000001-39000000 67503   21034   67503
#NM_023907       -       chr10_19000001-39000000 190901  186982  190901
#NM_033374       -       chr10_19000001-39000000 661357  208548  295052
#NM_027411       -       chr10_19000001-39000000 710920  685717  710920
#NM_145962       +       chr10_19000001-39000000 1699788 1680413 1699788
#                        gi|56177874|ref|NC_006468.1|NC_006468_1-20000000
#gi|56177874|ref|NC_006468.1|NC_006468   229565298
my %chr_size;
while (<Chr>) {
	chomp;
	my @infor=split;
	$chr_size{$infor[0]}=$infor[1];
}
close Chr;

#my %hash_name;
#my %hash_strand;
#my %chr_length;
#my 
#chr6_hla_hap1_1-20000000
while (<IN>) {
	chomp;
	my $start;my $end;
	my @infor=split;

	my $chr=$infor[2];
	if ($chr=~/-/) {
		my @tmp=split /_/,$chr;
		my @tmp2=split /-/,$tmp[-1];
		$start=$infor[4]+$tmp2[0]-1;
		$end=$infor[5]+$tmp2[0]-1;
		#$chr=$tmp[0];
		pop (@tmp);
		$chr=join "_", @tmp;
		print $chr,"\n";
		#print "$chr\t$chr_size{$chr}\t$start\t$end\n";
	}
	else {$start=$infor[4];$end=$infor[5];}
if(!exists $chr_size{$chr}){next;}
print OUT "$infor[0]\t$infor[1]\t$chr\t$chr_size{$chr}\t$start\t$end\n";
}

