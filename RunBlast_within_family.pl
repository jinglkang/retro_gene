#!/usr/bin/perl -w

use strict;

open List,  "$ARGV[0]"||die '!';
open Seq,   "$ARGV[1]"||die '!';
open OUT,  ">$ARGV[2]"||die '!';
open Tab,  ">$ARGV[3]"||die '!';

#GSTENP00029997001_Un_random_58000001-88000000_23287003_23287767 1       GSTENP00029997001_7_7152154_7153829     2       GSTENP00030067001_16_3473500_3474568  2

#>GSTENP00017288001_4_1633046_1638065
#caggcgggggcctcgtccatgtgggcgtcat
my $process=0;
my %seq;
my $name;
while (<Seq>) {
	chomp;
	if (/^>/) {
		my @infor=split;
		$name=$infor[0];
		$name=~s/>//;
	}
	else {$seq{$name}.=$_;}
}
close Seq;



my %exon_num;
my $count;
my $total;
my %tab;
my $index=0;

while (<List>) {
	chomp;
	my @infor=split;
	my $query_num;
	my $database_num;
	$process++;
	print "$process\n";
	for (my $i=0;$i<@infor-1 ;$i+=2) {
		$exon_num{$infor[$i]}=$infor[$i+1];
		$database_num++;
		print "$ARGV[0]\n";
		open D, ">>database.$ARGV[0].seq"||die '!';
				print D ">gene_$index\n$seq{$infor[$i]}\n";
		close D;
		$tab{$infor[$i]}=$index;
		print Tab "$infor[$i]\t$index\n";
		$index++;

		if ($exon_num{$infor[$i]}==1) {
			$count++;
			$query_num++;
			open Q, ">>query.$ARGV[0].seq"||die '!';
				print Q ">gene_$tab{$infor[$i]}\n$seq{$infor[$i]}\n";
			close Q;
		}
	}
	$total+=$query_num*$database_num;
	system ("formatdb -i database.$ARGV[0].seq -p F");
	system ("blastall -p blastn -e 1e-8 -i query.$ARGV[0].seq -d database.$ARGV[0].seq -o tmp.$ARGV[0].bla");
	
	open TMP, "tmp.$ARGV[0].bla";
		my @data=<TMP>;
	close TMP;
	print OUT @data;
	system ("rm query.$ARGV[0].seq tmp.$ARGV[0].bla database.$ARGV[0].seq* formatdb.log");
	#last;
}
close List;
close OUT;

print "$count\t$total\n";
#foreach my $key (keys %tab)
#{print Tab "$key\t$tab{$key}\n";}
#print "work done\n";
close Tab;
exit;