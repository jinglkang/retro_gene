#!/usr/bin/perl -w

use strict;

open BLAT, "$ARGV[0]"||die '!';
open IN,   "$ARGV[1]"||die '!';
open OUT, ">$ARGV[2]"||die '!';

my %gene_start;
my %gene_end;
my %chr;
my %exon_num;
my %exon_len;
my %exon_start;
my %exon_end;
my %intron_start;
my %intron_end;

my $name;
while (<BLAT>) {
	chomp;
	my @infor=split;
	$name=$infor[9];
	$chr{$name}=$infor[13];
	$gene_start{$name}=$infor[15];
	$gene_end{$name}=$infor[16];
	$exon_num{$name}=$infor[17];
	
	my @tmp=split /\,/,$infor[18];
	for (my $i=0;$i<@tmp;$i++) {
		$exon_len{$name}->[$i]=$tmp[$i];
	}

	@tmp=split /\,/,$infor[20];
	for (my $j=0;$j<@tmp;$j++) {
		$exon_start{$name}->[$j]=$tmp[$j];
		$exon_end{$name}->[$j]=$exon_start{$name}->[$j]+$exon_len{$name}->[$j]-1;
	}

	for (my $k=0;$k<@tmp-1 ;$k++) {
		$intron_start{$name}->[$k]=$exon_end{$name}->[$k]+1;
		$intron_end{$name}->[$k]=$exon_start{$name}->[$k+1]-1;
	}

}
close BLAT;

print "starte comparing!";
my $process;

while (<IN>) {
	chomp;
	my @infor=split;
	my $tmp_start=$infor[3]+600;
	my $tmp_end=$infor[4]-600;
	my $tmp_chr=$infor[1];
	$process++;
	print "$process\n";
	foreach my $key (keys %gene_start) {
		my $tag=0;
		if ($tmp_chr ne $chr{$key}) {next;}
		if ($tmp_start>$gene_end{$key} or $tmp_end <$gene_start{$key}) {next;}

		for (my $i=0;$i<$exon_num{$key} ;$i++) {#检测是否在exon里
			if (!($tmp_start>$exon_end{$key}->[$i] or $tmp_end < $exon_start{$key}->[$i])) {print OUT "$infor[0]\t$key\texon$i\n";$tag=1;last;}
		}

		for (my $j=0;$j<$exon_num{$key}-1 ;$j++) {#检测是否在intron里
			if ($tag==1) {last;}
			if ($tmp_start>=$intron_start{$key}->[$j] && $tmp_end <=$intron_end{$key}->[$j]) {
				print OUT "$infor[0]\t$key\tintron$j\t",$intron_end{$key}->[$j]-$intron_start{$key}->[$j]+1,"\n";				
			}
		}

	}
}
close IN;



#foreach my $key (keys %gene_start) {
#	print "$key\t$chr{$key}\t$gene_start{$key}\t$gene_end{$key}\n";
#
#	for (my $i=0;$i<$exon_num{$key} ;$i++) {
#		print "$exon_start{$key}->[$i]\t$exon_end{$key}->[$i]\n";
#	}
#	print "----------------------------\n";
#	for (my $j=0;$j<$exon_num{$key}-1 ;$j++) {
#		print "$intron_start{$key}->[$j]\t$intron_end{$key}->[$j]\n";
#	}
#	last;
#}

#1218    0       0       0       0       0       11      3021    +       NEWSINFRUT00000127010   1218    0       1218    scaffold_350  229219  221268  225507  12      75,51,97,76,103,148,139,64,135,128,100,102,     0,75,126,223,299,402,550,689,753,888,1016,1116,       221268,221531,221670,221852,222020,222211,222440,222650,223035,224878,225149,225405,
#scaffold_1_6605398_6605468      scaffold_1      +       6604798 6606068
