#!/usr/bin/perl
#author luzhk
#BGI 
use strict;
if (@ARGV <2) {
	print "usage:\tfasta_to_axt_luzhk.pl input output\n";
	exit;
}
my $name = shift;
open IN,$name;
$name = shift;
open OUT,">$name";
#  3>>>CN531367,4_6 - 65 nt
#>>NM_145584                                               (401518 nt)
# initn: 325 init1: 325 opt: 325  Z-score: 431.9  bits: 93.8 E(): 1.5e-21
#banded Smith-Waterman score: 325;  100.000% identity (100.000% similar) in 65 nt overlap (1-65:372700-372764)
#
#                                             10        20        30
#CN5313                               AGTGATGAAGTCCTCACTGTCATCAAAGCC
#                                     ::::::::::::::::::::::::::::::
#NM_145 CTACATTAAACATGTGTGGTTCTCTTGCAGAGTGATGAAGTCCTCACTGTCATCAAAGCC
#  372670    372680    372690    372700    372710    372720         
#
#               40        50        60                              
#CN5313 AAAGCCCAGTGGCCAGCCTGGCAGCCTGTCAATGT                         
#       :::::::::::::::::::::::::::::::::::                         
#NM_145 AAAGCCCAGTGGCCAGCCTGGCAGCCTGTCAATGTGTAAGTACCAAACAGACACTTGTCT
#  372730    372740    372750    372760    372770    372780         
#
#NM_145 TCCCTGCCACCCTAGCCTTGTCCTAGAAGCCACCTAGCTCAGGGTCACTTAATATTGGTT
#  372790    372800    372810    372820    372830    372840         
my $query;
my $querylength;
my $lib;
my $liblength;
my $queryFlag = 0;
my $bits;
my $score;
my $eValue;
my $queryStart;
my $queryEnd;
my $libStart;
my $libEnd;
my $indenty;
my $overlaplength;
my $match=0;
my $inFlag=0;
my($line1,$line2,$line3,$line4);
my (@querySeq,@libSeq,@flag);
while (my $line = <IN>) {
	if ($line =~ m/^  \d+\>\>\>(.+) - (\d+) nt/) {
		if ($inFlag == 1) {
			@querySeq = split //,$line1;
			@flag = split //,$line2;
			@libSeq = split //,$line3;
#			print OUT "$line1\n";
#			print OUT "$line2\n";
#			print OUT "$line3\n";
#			print OUT "@querySeq\n";
#			print OUT "@flag\n";
#			print OUT "@libSeq\n";
			my $char = pop @flag;
			while ($char eq " ") {
				#print "ce:$char:\n";
				$char =pop @querySeq;
				$char =pop @libSeq;
				$char = pop @flag;
			}
			$char = shift @flag;
			while ($char eq " ") {
				#print "cs:$char:\n";
				$char =shift @querySeq;
				$char =shift @libSeq;
				$char = shift @flag;
			}
			print OUT "$query\t$lib\t$score\t$indenty\t$eValue\t$queryStart\t$queryEnd\t$libStart\t$libEnd\t$overlaplength\n";
			$" = '';
			print OUT "@querySeq\n";
			print OUT "@libSeq\n";
			$line1 = $line2 = $line3 = "";
			$inFlag = 0;
		}
		$query  = $1;
		$querylength = $2;
		$queryFlag = 1;
		#print "query:$1\tlength:$2\n";
		next;
	}
	if ($line =~ m/^\>\>(.+?) +\((\d+) nt\)/ && $queryFlag == 1) {
		if ($inFlag == 1) {
			@querySeq = split //,$line1;
			@flag = split //,$line2;
			@libSeq = split //,$line3;$" = '';
#			print OUT "$line1\n";
#			print OUT "$line2\n";
#			print OUT "$line3\n";
#			print OUT "@querySeq\n";
#			print OUT "@flag\n";
#			print OUT "@libSeq\n";
			my $char = pop @flag;
			while ($char eq " ") {
				#print "ce:$char:\n";
				$char =pop @querySeq;
				$char =pop @libSeq;
				$char = pop @flag;
			}
			$char = shift @flag;
			while ($char eq " ") {
				#print "cs:$char:\n";
				$char =shift @querySeq;
				$char =shift @libSeq;
				$char = shift @flag;
			}
			print OUT "$query\t$lib\t$score\t$indenty\t$eValue\t$queryStart\t$queryEnd\t$libStart\t$libEnd\t$overlaplength\n";
			
			print OUT "@querySeq\n";
			print OUT "@libSeq\n";
			$line1 = $line2 = $line3 = "";
			$inFlag = 0;
		}
		$lib = $1;
		$liblength = $2;
		#print "lib:$1\tlength:$2\n";
		$line = <IN>;
		#print $line;
		if ($line =~ m/bits: (.+) E\(\): (.+)\n/) {
			$bits = $1;
			$eValue = $2;
			#print "Bits:$1\tevalue:$2\n";
		}else {
			print "read bits error!\n";
		}
		$line = <IN>;
		#print $line;
		if ($line =~ m/score\: (.+)\; *(\S+)\% identity .+ in (.+) nt overlap \((\d+)-(\d+):(\d+)-(\d+)\)/) {
			$score = $1;
			$indenty = $2;
			$overlaplength = $3;
			$queryStart = $4;
			$queryEnd = $5;
			$libStart = $6;
			$libEnd = $7;
			#print "score:$1\tindenty:$2\toverlap:$overlaplength\tqueryS:$queryStart\tqueryE:$queryEnd\tlibS:$libStart\tlibE:$libEnd\n";
		}else {
			print "read indenty error!\n";
		}
		$match = 1;
		
		next;
	}
	if ($line =~ m/^[ \d]+\d+[ \d]+\n/ && $match == 1 && $queryFlag == 1) {
		#print "match:$line";
		$line = <IN>;
		if ($line =~ /^\n/) {
			next;
		}
		#print $line;
		chomp $line;
		
		$line1 .= substr $line,7;
		$line = <IN>;
		if ($line =~ /^\n/) {
			next;
		}
		#print $line;
		chomp $line;
		$line2 .= substr $line,7;
		$line = <IN>;
		if ($line =~ /^\n/) {
			next;
		}
		#print $line;
		chomp $line;
		$line3 .= substr $line,7;
		$inFlag = 1;
		$line = <IN>;
	}
	
}
if ($inFlag == 1) {
			@querySeq = split //,$line1;
			@flag = split //,$line2;
			@libSeq = split //,$line3;
			$" = '';
#			print OUT "$line1\n";
#			print OUT "$line2\n";
#			print OUT "$line3\n";
#			print OUT "@querySeq\n";
#			print OUT "@flag\n";
#			print OUT "@libSeq\n";
			my $char = pop @flag;
			while ($char eq " ") {
				#print "ce:$char:\n";
				$char =pop @querySeq;
				$char =pop @libSeq;
				$char = pop @flag;
			}
			$char = shift @flag;
			while ($char eq " ") {
				#print "cs:$char:\n";
				$char =shift @querySeq;
				$char =shift @libSeq;
				$char = shift @flag;
			}
			print OUT "$query\t$lib\t$score\t$indenty\t$eValue\t$queryStart\t$queryEnd\t$libStart\t$libEnd\t$overlaplength\n";
			
			print OUT "@querySeq\n";
			print OUT "@libSeq\n";
			$line1 = $line2 = $line3 = "";
			$inFlag = 0;
		}