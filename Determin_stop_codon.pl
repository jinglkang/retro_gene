#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open List,"$ARGV[0]" || die"$!";
open Bla,"$ARGV[1]" || die"$!";

#open OUT,">$ARGV[2]" || die"$!";
#BC094738,8	1	116928
my %hash;
while (<List>) {
	chomp;
	my @infor=split;
	$hash{$infor[0]}.="$infor[1]\t$infor[2]\n";
}

my %stop_pos;

while (<Bla>) {
	my $name;
	
	if (/^Query=/) {
		$name=(split /\s+/,$_)[-1];
		#print ">>>>>$name\n";

		if (!exists $hash{$name}) {next;}
		else 
		{
		
		my $q_start;
		my $s_start;
	
	while (<Bla>) {
		if (/^Query:/) {
			
		$q_start=(split /\s+/,$_)[1];
	
		$_=<Bla>; $_=<Bla>;
		$s_start=(split /\s+/,$_)[1];
#		print ">$name\t$q_start\t$s_start\n";
		my @tmp=split /\n/,$hash{$name};
			foreach my $item (@tmp) {
				#my $tmp_out=(split /\t/,$item)[1];
				#	print $tmp_out,"<<<\n";
				if ($q_start== (split /\t/,$item)[0] and $s_start==(split /\t/,$item)[1]) {
						my $s_seq.=(split /\s+/,$_)[2];
						#print ">>>>>>>>>>>>>$_\n";
						while (<Bla>) {
							if(/^Sbjct:/){$s_seq.=(split /\s+/,$_)[2];}
							if(/^\sFrame/){last;}
							if (/^  Database:/) {last;}
						}
						if($s_seq=~/\*/){
							my $len=length $s_seq;
							for (my $i=0; $i<=$len-1;$i++) {
								my $base=substr($s_seq,$i,1);
								if($base eq '*'){$stop_pos{$name}.=$q_start+$i."\t";}
							}
							#print "$name\t$stop_pos{$name}\n";
							print ">$name\t$stop_pos{$name}\n$s_seq\n";
							}
						last;
				
				}
	
			}

		}
		else{
		if (/^Matrix:/) {last;}
		}
	}
		}
	}
}

