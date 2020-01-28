#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die "$!";
open OUT,">$ARGV[1]" || die "$!";

#13546 chr1 130483151 130486644 chr1 149655805 149659313 + 318020        0       1       676     678     3       130483826    130483828
#13546 chr1 130483151 130486644 chr1 149655805 149659313 + 318020        0       2       1010    1031    22      130484160    130484181
#13546 chr1 130483151 130486644 chr1 149655805 149659313 + 318020        0       3       3004    3010    7       130486154    130486160
my %best_start;
my %best_end;

while (<IN>) {
	chomp;
	my @infor=split;
	if ($infor[9]==0) {
	my $name="$infor[0]"."\t$infor[1]";
	my $start=$infor[2];
	my $end=$infor[3];
	
	if (!exists $best_start{$name}) {
		$best_start{$name}=$start;
		$best_end{$name}=$end;
	}
	else{
		
		if ($start<$best_start{$name}){$best_start{$name}=$start;}
		if ($end>$best_end{$name}){$best_end{$name}=$end;}
	
	}
	}
}

my @keys_sort_by_start= sort by_chr_and_start keys %best_start;

foreach my $item (@keys_sort_by_start) {
	print OUT "$item\t$best_start{$item}\t$best_end{$item}\n";
}

  sub by_chr_and_start {
	$best_start{$a} <=> $best_start{$b}
	or 
	$best_end{$a} <=> $best_end{$b}  
    }
