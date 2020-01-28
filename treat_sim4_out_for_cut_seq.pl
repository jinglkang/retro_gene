#!/usr/bin/perl -w

open IN, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open OUT, ">$ARGV[1]"||die "can not open $ARGV[1]\n";
use strict;
#sim4.chr5.out.AA021827,1        sim4.chr5.out.NM_011716 +       5289    5340    52      15      65
#sim4.chr5.out.AA021827,2        sim4.chr5.out.NM_011716 +       11909   12155   247     66      314

while (my $line=<IN>) {
	chomp $line;
	my @infor=split /\s+/, $line;
	#print "$infor[0]\t $infor[1]\n";
	my $name1=(split /\./,$infor[0])[-1];
	my $name2=(split /\./,$infor[1])[-1];
	print OUT "$name1\t$name2\t$infor[2]\t$infor[3]\t$infor[4]\t$infor[5]\t$infor[6]\t$infor[7]\n";
}
close IN;
close OUT;
exit