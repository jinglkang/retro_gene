#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";
open OUT,">$ARGV[1]" || die"!";

#>>>     BU839750,5
#BU730985,3      NM_000014       -       9112599 9112705 107
#>>>     N51581,1
#N51581,1        NM_000014       -       9112603 9112629 27


my %exon_line;
my %exon_ref;
#my %exon_ref1;
my %exon_start;
#my %exon_start1;
my %exon_end;
#my %exon_end1;
my %exon_left;
my %exon_right;
my %exon_group;
my $name;
my $tag=0;

while (<IN>) {
	chomp;
	my @infor=split;
	if (/^>>>/) 
	{	$name=$infor[1];
		#print OUT "$_\n";
		$tag=0;
	}
	else
	{	if ($tag==1) {next;}
		#print OUT "$_\n";
		$exon_ref{$name}=$infor[1];
		$exon_start{$name}=$infor[3];
		$exon_end{$name}=$infor[4];
		$exon_left{$name}=$infor[3];
		$exon_right{$name}=$infor[4];
		$exon_line{$name}="$name\t$infor[1]\t$infor[2]\t$infor[3]\t$infor[4]\t$infor[5]";
		$tag=1;
	}
}
close IN;

#exit;


 sub by_chr_and_start {
	$exon_ref{$a} cmp $exon_ref{$b}
	or 
	$exon_start{$a} <=> $exon_start{$b}  
    }

  sub by_chr_and_end {
	$exon_ref{$a} cmp $exon_ref{$b}
	or 
	$exon_end{$a} <=> $exon_end{$b}
    }

my @keys_sort_by_start= sort by_chr_and_start keys %exon_start; #得到按ref和start排序的exon的key
my @keys_sort_by_end= sort by_chr_and_end keys %exon_end;#得到按chr和end排序的est的key









my $ref;
my $start;
my $end;
my $count;
foreach my $item (@keys_sort_by_start) {
		$name=$item;
		if (!exists $exon_ref{$item}) {next;}
		$exon_group{$item}.="$item\t";
		$ref=$exon_ref{$item};
		$start=$exon_start{$item};
		$end=$exon_end{$item};
		#print "1\t$item\n";
		$count++;
		print "$count\n";
		delete $exon_ref{$item}; delete $exon_start{$item}; delete $exon_end{$item}; #删掉自己
		foreach my $key (@keys_sort_by_start) {
			if (!exists $exon_ref{$key}) {next;}
			if ($exon_ref{$key} eq $ref) {
				#print "2\t$item\t$key\t$exon_left{$item}\t$exon_right{$item}\t$exon_start{$key}\t$exon_end{$key}\n";
				if ($exon_left{$item}>$exon_end{$key} or $exon_right{$item}< $exon_start{$key}) {next;}
				
				$exon_group{$item}.="$key\t"; #将有overlap的exon合并
				if ($exon_start{$key}<$start) {$exon_left{$item}=$exon_start{$key};} #取得这组exon的最左边和最右边
				if ($exon_end{$key}>$end) {$exon_right{$item}=$exon_end{$key};}
				#print "----------$exon_left{$item}\t$exon_right{$item}\n";
				delete $exon_ref{$key}; delete $exon_start{$key}; delete $exon_end{$key}; #删掉与自己有overlap的exon
			}
		}
}

foreach my $key (keys %exon_group) {
	print OUT ">>>\t$key\n";
	my @tmp=split /\t/,$exon_group{$key};
	foreach my $item (@tmp) {
		print OUT "$exon_line{$item}\n";
	}
}
