#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
#open OUT,">$ARGV[1]" || die"$!";

my $name;
my %tissue;
my %total_est;
my %tmp;
my %tissue_number;
my $tag=0;
my %specific;
while (<IN>) {
	chomp;
	my @infor=split;
	if (/^>/) {
		if($tag==1){
			$tissue_number{$name}=scalar (keys %tmp);
			foreach my $key (keys %tmp) {
				if ($tmp{$key}/$total_est{$name}*100>50) {$specific{$name}=1;}
			}
		}
		%tmp=();
		$name=$infor[0];
		$name=~s/>//;
		$tag=1;
		
	}
	else
	{
		if (!/^\w+/){next;} 
		$total_est{$name}++;
		$tissue{"$name\t$infor[0]"}++;
		$tmp{$infor[0]}++;
	}
}

if($tag==1){$tissue_number{$name}=scalar (keys %tmp);
			foreach my $key (keys %tmp) {
				if ($tmp{$key}/$total_est{$name}*100>50) {$specific{$name}=1;}
			}
}


foreach my $exon_name (keys %total_est) {
	if (!exists $specific{$exon_name}) { $specific{$exon_name}=0;}
	print "$exon_name\t$tissue_number{$exon_name}\t$total_est{$exon_name}\t", $tissue_number{$exon_name}/$total_est{$exon_name}*100,"\t$specific{$exon_name}\n";

}
