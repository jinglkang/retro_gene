#!/usr/bin/perl -w

use strict;
open IN, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open OUT, ">$ARGV[1]"||die "can not open $ARGV[1]\n";

#>NM_177390 "NM_177390",,,,235,2769,""
my $name;
my %start;
my %end;
my %seq;
while (my $line=<IN>) {
	if ($line=~/^>/) {
		chomp $line;
	my @infor=split /,/,$line;
	$name=(split /\s+/,$line)[0];
	$name=~s/>//;
	$start{$name}=$infor[-3];
	$end{$name}=$infor[-2];
	}
	else{
		#chomp $line;
		$line=~s/\s+//g;
		#print $line."<<<<<<<";
		#chomp $line;
		
		$seq{$name}.=$line;
		} 
}

foreach my $key (keys %seq) {
	if($start{$key} eq "Noinfor" or $end{$key} eq "Noinfor"){print "$key\n";next;}
	print OUT ">$key\n";
	#print "$key\n";
	#print "$seq{$key}\n";
	
	my $tmp=substr($seq{$key},$start{$key}-1,$end{$key}-$start{$key}+1);
	print OUT "$tmp\n";
}
exit

