#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open Exon_pos,"$ARGV[0]" || die"$!";
open Gap_list,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";

#AK093902,14     chr2    +       179072654       179072741
#BI752303,1      chr13   +       40732629        40733051
#BX501044,2      chr3    +       57807964        57808000

#945456  945620  165     1       165     100     100
#1943648 1944010 363     1       363     100     100

my %exon_start;
my %exon_end;
my %exon_len;
while (<Exon_pos>) {
	chomp;
	my @infor=split;
	$exon_start{$infor[0]}=$infor[3];
	$exon_end{$infor[0]}=$infor[4];
	$exon_len{$infor[0]}=$exon_end{$infor[0]}-$exon_start{$infor[0]}+1;
}

while (<Gap_list>) {
	chomp;
	
	my @infor=split;
	my $gap_start=$infor[0];
	my $gap_end=$infor[1];
	foreach my $key (keys %exon_start) {
		#print ">>>>>>\n";
		if ($exon_start{$key}>=$gap_start && $exon_end{$key}<=$gap_end) {
			print OUT "$key\t$exon_start{$key}\t$exon_end{$key}\t$exon_len{$key}\t$gap_start","_","$gap_end\n";
		}
	}
}