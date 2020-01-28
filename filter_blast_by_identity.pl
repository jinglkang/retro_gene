#!/usr/bin/perl -w

use strict;
open IN,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";

#>NM_001014448
#          Length = 377521
#
# Score =  213 bits (134), Expect = 2e-57
# Identities = 137/140 (97%)
# Strand = Plus / Plus
#
#                                                                         
#Query: 1     gcatgtccgatttcaactacctgcacaccaactgctttgagatcacggtagagctgggct 60
#             |||||||||| |||||||||||||||||||||||||||||||||||||||||||||||||
#Sbjct: 84361 gcatgtccgacttcaactacctgcacaccaactgctttgagatcacggtagagctgggct 84420
#
#                                                                         
#Query: 61    gtgtgaagttcccccccgaggaggccctgtacatactctggcagcacaacaaggagtcac 120
#             |||||||||||||||||||||||||||||||||  |||||||||||||||||||||||||
#Sbjct: 84421 gtgtgaagttcccccccgaggaggccctgtacacgctctggcagcacaacaaggagtcac 84480
#
#                                 
#Query: 121   tcctgaatttcgtggagacg 140
#             ||||||||||||||||||||
#Sbjct: 84481 tcctgaatttcgtggagacg 84500
#
#
#
# Score = 31.7 bits (19), Expect = 0.012

my $tmp_score;
my $tmp_identity;
my $tmp_db;
my $num=0;
while (<IN>) {
	chomp;
	if(/^\sScore\s=/){
		$tmp_score=$_;
		#print $tmp_score,"\n";
		$_=<IN>;
		chomp;
		$tmp_identity=$_;
		#print $tmp_identity, "\n";
		if (/Identities.+?\((.+?)%\)/) {
			my $identity=$1;
			#print $identity,"\n";
				if ($identity<80) {
					while (<IN>) {
						if($_ eq "\n"){$num++;}else{$num=0;}
						if($num==3 or /^\s\sDatabase/){last;}
					}
				}
				else {print OUT $tmp_score,"\n";print OUT $tmp_identity,"\n";}
		}
	}
	else {print OUT $_,"\n";}	

	
}