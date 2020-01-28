#!/usr/local/bin/perl -w
#use strict;

## Set containing 31 members  /gb=BC067218 /gi=45501306 /len=1344
#>gnl|UG|Hs#S19185843 Homo sapiens N-acetyltransferase 2 (arylamine N-acetyltransferase), mRNA
#(cDNA clone MGC:71963 IMAGE:4722596), complete cds /cds=p(105,977) /gb=BC067218 /gi=45501306 /ug=Hs.2 /len=1344
#GGGGACTTCCCTTGCAGACTTTGGAAGGGAGAGCACTTTATTACAGACCTTGGAAGCAAG
#AGGATTGCATTCAGCCTAGTTCCTGGTTGCTGGCCAAAGGGATCATGGACATTGAAGCAT
#ATTTTGAAAGAATTGGCTATAAGAACTCTAGGAACAAATTGGACTTGGAAACATTAACTG
#ACATTCTTGAGCACCAGATCCGGGCTGTTCCCTTTGAGAACCTTAACATGCATTGTGGGC
#AAGCCATGGAGTTGGGCTTAGAGGCTATTTTTGATCACATTGTAAGAAGAAACCGGGGTG
#GGTGGTGTCTCCAGGTCAATCAACTTCTGTACTGGGCTCTGACCACAATCGGTTTTCAGA
#CCACAATGTTAGGAGGGTATTTTTATATCCCTCCAGTTAACAAATACAGCACTGGCATGG
#TTCACCTTCTCCTGCAGGTGACCATTGACGGCAGGAATTACATTGTCGATGCTGGGTCTG
#GAAGCTCCTCCCAGATGTGGCAGCCTCTAGAATTAATTTCTGGGAAGGATCAGCCTCAGG
#tgccttgcattttctgcttgacagaagagagaggaaTCTGGTACCTGGACCAAATCAGGA

#输出4个文件，EST的list（包含UniGeneID），Refseq的list（包含UniGene的ID），EST的序列文件，RefSeq的序列文件
open IN, "$ARGV[0]"||die "!";
open EST_list, ">$ARGV[1]"||die "!";
open REF_list, ">$ARGV[2]"||die "!";
open EST_seq, ">$ARGV[3]"||die "!";
open REF_seq, ">$ARGV[4]"||die "!";

my %hash_est_list=();
my %hash_ref_list=();
my %hash_est_seq=();
my %hash_ref_seq=();
my %hash_est_ugid=();
my %hash_est_start=();
my %hash_est_end=();
my %hash_strand=();
my $tag=0;
my $tag1=0;

#print $ARGV[0];
my $start;my $end;my $est_name;my $ugid;my $strand;
while (my $line=<IN>) {

	if ($line=~/^\#/) {next;}
	elsif ($line=~/^>/) {
		#print ">>>>>>>>>>>>>>>";
		$tag=1;
		if ($tag==1 and $tag1==1) {
			   $tag=0;
				if ($est_name=~/^NM/||$est_name=~/^XM/) {print REF_list $hash_est_list{$est_name},"\t$hash_strand{$est_name}\t$hash_est_ugid{$est_name}\t$hash_est_start{$est_name}\t$hash_est_end{$est_name}\t\n";
									  #>NM_007376 "NM_007376",4674,"","",50,4537,""
									   print REF_seq ">$est_name \"$est_name\",,,,$hash_est_start{$est_name},$hash_est_end{$est_name},\"\"\n$hash_est_seq{$est_name}";}
				else {print EST_list $hash_est_list{$est_name},"\t$hash_strand{$est_name}\t$hash_est_ugid{$est_name}\t$hash_est_start{$est_name}\t$hash_est_end{$est_name}\t\n";
					  print EST_seq ">$est_name\n$hash_est_seq{$est_name}";}
		}
		
		if($line=~/^>.*\/cds=(\w)\((\d+),(\d+)\)\s*\/gb=(\w+).*\/ug=(.*) \/len/s ||$line=~/^>.*\/cds=m\((\d+),(\d+)\)\s*\/gb=(\w+).*\/ug=(.*) \/len/s){
		$strand=$1;
				if ($strand eq 'p') {$strand='+';}
				elsif($strand eq 'm'){$strand='-';}
		$start=$2;
		$end=$3;
		$est_name=$4;
		$ugid=$5;
		$hash_est_seq{$est_name}="";
		$hash_est_list{$est_name}=$est_name;
		$hash_est_ugid{$est_name}=$ugid;
		$hash_est_start{$est_name}=$start;
		$hash_est_end{$est_name}=$end;
		$hash_strand{$est_name}=$strand;
				$tag1=1;
#print "$est_name\t$strand\t$start\t$end\n";
		next;
		}
		#>gnl|UG|Hs#S16819285 Homo sapiens mRNA; cDNA DKFZp686B08142 (from clone DKFZp686B08142) /gb=BX647469 /gi=34366626 /ug=Hs.4 /len=3836
		elsif ($line=~/^>.*\/gb=(\w+).*\/ug=(.*) \/len/s){
		$est_name=$1;
		#print $est_name,"\n";
		$ugid=$2;
		$hash_est_seq{$est_name}="";
		$hash_est_list{$est_name}=$est_name;
		$hash_est_ugid{$est_name}=$ugid;
		$hash_est_start{$est_name}="Noinfor";
		$hash_est_end{$est_name}="Noinfor";
		$hash_strand{$est_name}="Noinfor";
		$tag1=1;

		next;
		}
	
	}
    elsif($line=~/^[agctu]/i) {
		$hash_est_seq{$est_name}.=$line;
		}
}
close IN;

		$tag=1;
		if ($tag==1 and $tag1==1) {
			   $tag=0;
				if ($est_name=~/^NM/||$est_name=~/^XM/) {print REF_list $hash_est_list{$est_name},"\t$hash_strand{$est_name}\t$hash_est_ugid{$est_name}\t$hash_est_start{$est_name}\t$hash_est_end{$est_name}\t\n";
									   print REF_seq ">$est_name\n$hash_est_seq{$est_name}";}
				else {print EST_list $hash_est_list{$est_name},"\t$hash_strand{$est_name}\t$hash_est_ugid{$est_name}\t$hash_est_start{$est_name}\t$hash_est_end{$est_name}\t\n";
					  print EST_seq ">$est_name\n$hash_est_seq{$est_name}";}
		}



close EST_list;
close REF_list;
close EST_seq;
close REF_seq;
exit