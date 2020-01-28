#!/usr/bin/perl -w

open IN, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open OUT, ">$ARGV[1]"||die "can not open $ARGV[1]\n";
use strict;
#sim4.chr2L.out.BI363779,1       sim4.chr2L.out.NM_135056        +       8032    8135    104
#sim4.chr2L.out.BQ103369,1       sim4.chr2L.out.NM_136115        +       5586    5598    13
#sim4.chr1.out.CB552055.est,     sim4.chr1.out.U73730.gc +       5050    11848
while (my $line=<IN>) {
	chomp $line;
	my @infor=split /\s+/, $line;
	#print "$infor[0]\t $infor[1]\n";
	my $name1=(split /\./,$infor[0])[-2];
	$name1=~s/est//;
	my $name2=(split /\./,$infor[1])[-2];
	$name2=~s/gc//;
	print OUT "$name1\t$name2\t$infor[2]\t$infor[3]\t$infor[4]\n";

}
close IN;
close OUT;
exit