#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";

#0 chr1_random 1318 2772 chr1 110611445 110612901 + 134307
#cacagtggctcatgcccgtaatcccagcactttgggaggccaaggtgggaggatcccttgagcccaggagttcgagaccagcctgggcaacatagtgggaccccatctcaactaaaaataaaaataaaaaaaa-tagcctgccatggtaacacgttatcccaactactggagagactgaggcaggaggatcgcttgagtctggaaggtcaaggattgcagtgacccatgattgtgtcactgcactccctctcaaagtgctgggattataggcttaagccaccatgctcagccAGAAATTTTAGCTTGAATAAAATGGACCCTATTCTGACAAGGTAGAGAAGATAAGAGGTCTTATTAGTGTTTATATTCTCCATAACCTATAGCATAGTGCTATTTGCATATGCATTTTCAATGAATAGGACTCAACATTGTTAGAAGCAAATATACCACCATTATATTTCTGGAAAAAAGAAGGTGGAAGGAGAGAAAGAAAGAGGCACCGAAACACAAGACATCTGGTACATCTTATCACTTGCATACTTATAAACGCATTGACTGTATATTTGTTTCTTAATGTAACATCAAAGTTTACACTACAACCTTAATAGCTGGTAGCCTAAGGTATCACCTTTCCTTCTATACTCAGCCACACTGGTTAAGATTAGATCTTCCTGTCTTTCACTCTAGTTGCTGCAATAGCAGTCAATTGTTCAAAGAGGACAAGGCTTGCTTAGATGAAGGACTGTCCTCAGATTGCAAGGTACTGCCtcaatcattcaccaaatattaactgaatgccagttctgggtcaggaactaggttaggcatcatttggaaatgcagGTTCTTACATGACAGAATGATTCATGGTGCCTTGTGACTTAAACGCCTATAGGCTAAGGTGGACCTCTTTTAATGTGATTCTTAAATGTTATCTCTAAAAAGGAGAATAGGAGTTTTTGGTTTTCCCCAAATAGGAGAAAGGAGTCTGAGTACAAGCCCAAGCTAGGAAACTTTGCCTCAAGGAATTCAGGGGAAGTTTGTGGAGCTAAGAGAACGTGTTTTAGAAGCTCCACTCCCATTACTAGAACACGCACATACATACACACATCAAAAAGCTTTGTGCTTCAGAGCCAGTAGCACCTAACCAAGATATGGAATTAACCTAAGTGAGGC-TTAGGAGAACAAAGCACCCACCACTGCTG-TTCTTCTTTAAACAGATTCAAGggccaggcaccgcggctcacgcctgtaatcccaacactttgggaagctgagaggggcggatcacctgaggtcaggagtttgagaccagcctggccaatatggagaaaccctgtctctactgaaaaatgcaaaaattagcagggcgtggtggcgcacgtttgaacccaagaggcagaggttggagtgagctgagatcgcgccactgcactccaatctgggcaacagagG
#cacagtggctcatgcccgtaatcccagcactttgggaggccaaggtgggaggatcccttgagcccaggagttcgagaccagactgggcaacatagtgggaccccatctcaactaaaaataaaaataaaaaaaaatagcctgccatggtaacacgttatcccaactactggagagactgaggcaggaggatcgcttgagtctggaaggtcaaggattgcagtgacccatgattgtgtcactgcactccctctcaaagtgctgggattataggcttaagccaccatgctcagccAGAAATTTTAGCTTGACTAAAATGGACCCTATTCTGACAAGGTAGAGAAGATAAGAGGTCTTATTAGTGTTTATATTCTCCATAACCTATATCATAGTGCTATTTGCATATGCATTTTCAATGAATAGGACTCAACATTGTTAGAAGCAAATATACCACCATTATATTTCTGGAAAAAAGAAGGTGGAAGGAGAGAAAGAAAGAGGCACTGAAACACAAGACATCTGGTACATCTTATCACTTGCATACTTATAAACGCATTGACTGTATATTTGTTTCTTAATGTAACATCAAAGTTTACACTACAACCTTAATAGCTGGTAGCCTAAGGTATCACCTTTCCTTCTATACTCAGCCACACTGGTTAAGATTAGATCTTCCTGTCTTTCACTCTAGTTGCTGCAATAGCAGTCAATTGTTCAAAGAGGACAAGGCTTGCTTAGATGAAGGACTGTCCTCAGATTCCAAGGTACTGCCtcaatcattcaccaaatattaactgaatgccagttctgggtcaggaactaggttaggcatcatttggaaatgcagGTTCTTACATGACAGAATGATTCATGGTGCCTTGTGACTTAAACGCCTATAGGCTAAGGTGGACCTCTTTTAATGTGATTCTTAAATGTTATCTCTAAAAAGGAGAATAGGAGTTTTTGGTTTTCCCCAAATAGGAGAAAGGAGTCTGAGTACCAGCCCAAGCTAGGAAACTTTGCCTCAAGGAATTCAGGGGAAGTTTGTGGAGCTAAGAGAACGTGTTTTAGAAGCTCCACTCCCATTACTAGAACACGCACATACATACACACATCAAAAAGCTTTGTGCTTCAGAGCCAGTAGCACCTAACCAAGATATGGAATTAACCTAAGTGAGGCTTTAGGAGAACAAAGCA-CCACCACTGCTGCTTCTCCTTTAAACAGATTCAAGggccaggcatggcggctcacgcctgtaatcccaacactttgggaagctgagaggggcagatcacctgaggtcaggagttcgagaccagcctggccaatatggagaaaccctgtctctactgaaaaatgcaaaaattagcagggcgtggtggcgcacgtttgaacccaagaggcagaggttggagtgagccgagatcgcgccactgcactccaatctgggcaacagagG
#
#1 chr1_random 2968 4121 chr1 110633867 110635021 + 105325
#AACAAAGGTGTTTGCTAACAACCGACTGAACATCACTCTGGGATGCTCTGGTACAAGGATCCCCTTCTTATGCTGACCTAATAATTATTTTCCACATAATGGTATAAGGAGCATCAGAGAAATGAAATAAGAAATGGTCAGCATTAGTGAGGAAACAAAATATGGAAAAGGATTTGGATGTTTAAAAAATAAAACAGTGTCTggcggctcatgcctgtaatcctagcactttgggaggctgaggcaggaggatcacttaagcctaggagtttgagaccagtctggccaacatggtgaaacttgtctttactgaaaatacaaaaattagttgggtgtggccaggcacggtggctcacgcctgtaattccagcactttgggaggccgagtggggtggatcacctgaggtcaggagttcaacaccagcctggctaacatggtgaaacccgtttctactaaaaatacaaaaaattagccgggcatggtggcacacacctgtaatcccagctacttgggaggctgaggcaggagaattgcttaaacctgggaggtggaggttgcagtgagccgagatcacgccactgcactccagcctgggtgacagagcaaggctccatctcag-gaaaaaaaaaaaaaaaaattagctgggcatggtggcatgcacctatagtcccagctattcaggatgctgaggtgggaggatcacttgacaccaagagttaaaggttgcagtgagctatgatcatgccactgtactccagccccagtgacagaagagtgagaccctgtctctaagaaaataaataaaaattaagaaaaTAATTTTTCTTAAAAAAGATACACTGACGCTGAagctgggcacggtggttcatgcttgtaatcccagcactttgggaggctgagacggcggatcatgaggtcaagagatcaagaccatcctggccaacatgatgaaaccctgtctctactaacaataccaaaattagctaggcgtcgtggcatgtgcctgtagtcccagctactcaggaggctgaagcaggagagtcgcttgagcccaggaggcagaggctgcagtgagccaagattgcgccattacactccagactgacaacagtgagactctgtctcaaaaagaaaatatatatatatatatata
#AACAAAGGTCTTTGCTAACAACTGACTGAACATCACTCTGGGATGCTCTGGTACAAGGATCCCCTTCTTATGCTGACCTAATAAGTAAAAACCACATAATGGTATAAGGAGCATCAGAGAAATGAAATAAGAAATGGTCAGCATTAGTGAGGAAACGAAATATGGAAAAGGATTTGGATGTTTAAAAAATAAAACAGTGTCTggcggctcatgcctgtaatcctagcactttgggaggatgaggcaggaggatcacttgagcctaggagtttgagaccagtctggccaacatggtgaaacttgtctttactgaaaatacaaaaattagttgggtgtggccaggcaccgtggctcacacctgtaattccagcactttgggaggccgagtggggtggatcacctgaggtcaggagttcaacaccagcctggctaacatggtgaaacccgtttctactaaaaatacaaaaaattagccgggcatggtggcacacacctgtaatcccagctacttgggaggctgaggcaggagaattgcttaaacctgggaggtggaggttgcagtgagccgagatcacaccactgcactccagcctgggtgacagagcaaggctccatctcagaaaaaaaaaaaaaaaaaaattagctgggcatggtggcatgcacctatagtctcagctattcaggaggctgaggtgggaggatcacttgacactaagagttaaaggttgcagtgagctatgatcatgccactgtactccagccccagtgatagaagagtgagaccctgtctctaagaaaataaataaaaattaagaaaaTAATTTTTCTTAAAAAAGATACACTGACCCTGAagctgggcacggtggttcatgcttgtaatcccagcactttgggaggctgagacggcggatcacaaggtcaagagatcaagaccatcctggccaacatgatgaaaccctgtctctactaacaataccaaaattagctaagcgtggtggcatgtgcctatagtcccagctactcaggaggctgaagcaggagagtcgcttgagcccaggaggcagaggctgcagtgagccaagattgcgccattacactccagactgacaacagtgagactctgtctcaaaaagaaaatatatatatatatatata

my %hash;
my $name;
while (<IN>) {
	chomp;
	if (/^\#/) {next;}
	if (/^\d/) {
		$name=$_;
		next;
	}
	else{
	$hash{$name}->[0]=$_;
	#print "$hash{$name}->[0]\n";
	$_=<IN>;
	$hash{$name}->[1]=$_;
	#print "<<<<<<<<<<<$hash{$name}->[1]\n";
	$_=<IN>;
	next;
	}
}
close IN;
my %len;
my $number=1;
my %gap_start;
my %gap_end;
my %gap_len;
my %gap_number;
#my $tag=0;
my $start_tag=0;
my $end_tag=0;

foreach my $key (keys %hash) {
	#print "$key\t$pos\n";
	for (my $j=0;$j<=1 ;$j++) {
	#0 chr1_random 1318 2772 chr1 110611445 110612901 + 134307
	my $absolute_start=(split /\s+/, $key)[$j*3+2];
	#print ">>>$hash{$key}->[$j]\n";
	$len{$key}=length ($hash{$key}->[$j]);#得到序列的长度
	my $pos; #初始化位置

	for(my $i=1;$i<=$len{$key};$i++)
	{
		my $tmp=substr($hash{$key}->[$j],$i-1,1);#一位一位的取序列
		$pos++;
		
		if ($tmp eq '-') {
			if($start_tag==0){
				$gap_start{$number}=$pos;$start_tag=1;
				$end_tag=1;
				}
		}
		else{
			if($end_tag==1){
			$gap_end{$number}=$pos-1;
			$gap_len{$number}=$gap_end{$number}-$gap_start{$number}+1;
			$end_tag=1;
			$number++;
			$start_tag=0;$end_tag=0;
			}
		}
		#print "$pos\t$start_tag\n";
	}

	if ($start_tag==1) {$gap_end{$number}=$pos;$gap_len{$number}=$gap_end{$number}-$gap_start{$number}+1;$number++;}
	
	$gap_number{$key}=$number-1;
	print "gap_number:$key\t$gap_number{$key}\n";
	for (my $i=1;$i<=$gap_number{$key} ;$i++) {
		print OUT "$key\t$j\t$i\t$gap_start{$i}\t$gap_end{$i}\t$gap_len{$i}\t",$absolute_start+$gap_start{$i}-1,"\t",$absolute_start+$gap_end{$i}-1,"\n";
	}
	$number=1;
	$start_tag=0;
	$end_tag=0;
	}
}

