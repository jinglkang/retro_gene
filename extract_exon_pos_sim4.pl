#!/usr/local/bin/perl

my $Version =  "V.2.0";
my $Author  =  "Hongkun Zheng";
my $Date    =  "2003-12-4";
my $Update  =  "2003-12-12 14:12";
my $Function=  "Extract exons from sim4 output!";
my $Contact =  "zhenghk\@genomics.org.cn";
my $modify  =  "";

#-------------------------------------------------------------------

#-------------------------------------------------------------------

use strict;
use Getopt::Long;
use Data::Dumper;


my %opts;

GetOptions(\%opts,"i:s","e:s","p:s","help");


if(!defined($opts{i}) || defined($opts{help}) ){
	
	Usage();
	
}

my $input   =    defined $opts{i} ? $opts{i} : "";
my $position=    defined $opts{p} ? $opts{p} : "Sequence_cover_region.tab";
my $output  =    defined $opts{e} ? $opts{e} : "Exon_posi.tab";


Head();

###### Sim4 format ################
#seq1 = Seq/UniGene_split/BY392828.fa, 384 bp
#seq2 = Genomic_cluster/Mouse_genomic_cluster_split/NM_133837_GC.fa (NM_133837_GC), 50928 bp
#
#(complement)
#1-216  (374-589)   97% <-
#217-353  (1258-1395)   99% <-
#354-384  (3972-4002)   100%
###### Sim4 format ################


open(O,">$output")||die"output error [$output]\n";
open(P,">$position")||die"sequence position output error [$position]\n";


my $seq1_name = '';
my $seq2_name = '';
my $seq2_len = '';
my $strand = '+';
my %sub_posi;

open(I,"$input")||die"sim4 result open error [$input]\n";
while(<I>){
	chomp;
	if(/^seq1 \= /){
		
		if($seq1_name ne ''){
			
		
			my @SubjectPos_sort = sort {$a<=>$b} keys %sub_posi;
	
			#foreach (@SubjectPos_sort){
			#	print $_,"\t",$sub_posi{$_},"\n";
			#}
			
			
			if(@SubjectPos_sort == 0){
				print "no match\n";
				#$nomatch++;
				next;
			}
			print P $seq1_name,"\t",$seq2_name,"\t",$strand,"\t",$SubjectPos_sort[0]+8,"\t",$sub_posi{$SubjectPos_sort[-1]}-8,"\n";
			
			
			for (my $i=1;$i<@SubjectPos_sort-1;$i++){
				
				my $len = $sub_posi{$SubjectPos_sort[$i]} - $SubjectPos_sort[$i] + 1;
									

				print O "$seq1_name\t$seq2_name\t$strand\t$SubjectPos_sort[$i]\t";
				print O "$sub_posi{$SubjectPos_sort[$i]}\t$len\n";	
					
			}
			
			#@SubjectPos_sort=();
			%sub_posi=();
			$strand = '+';
			
		}
		
		$seq1_name = (split(/\s+/,))[2];
		$seq1_name = (split(/\//,$seq1_name))[-1];
		$seq1_name =~s/.fa\,$//;
		#print $seq1_name,"\n";
	}
	
	if(/^seq2 \= /){
		$seq2_name = (split(/\s+/))[2];
		$seq2_len = (split(/\s+/))[4];
		$seq2_name = (split(/\//,$seq2_name))[-1];
		$seq2_name =~s/.fa$//;
		#print $seq2_name,"\t",$seq2_len,"\n";
	}
	
	if(/complement/){
		$strand = '-';
		#print $strand,"\n";
	}
	
	#1-216  (374-589)   97% <-
	if (/(\d+)\-(\d+)\s+\((\d+)\-(\d+)\)/){

# ignore the strand		
#		if($strand eq '+'){
#			$sub_posi{$3}=$4;
#		}
#		else {
#			$sub_posi{$seq2_len-$4+1}=$seq2_len-$3+1;
#		}
# ignore the strand

		$sub_posi{$3}=$4;

		
	}
}

close I;

#print $seq1_name,"\n";

if($seq1_name ne ''){
			
	#print $seq1_name,"=====\n";
		
	my @SubjectPos_sort = sort {$a<=>$b} keys %sub_posi;
	
	#foreach (@SubjectPos_sort){
	#	print $_,"\t",$sub_posi{$_},"\n";
	#}
	
	
	if(@SubjectPos_sort == 0){
		print "no match\n";
		#$nomatch++;
		next;
	}
				#print O ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>";

	print P $seq1_name,"\t",$seq2_name,"\t",$strand,"\t",$SubjectPos_sort[0]+8,"\t",$sub_posi{$SubjectPos_sort[-1]}-8,"\n";
	
	my $id=1;
	for (my $i=1;$i<@SubjectPos_sort-1;$i++){
		
		my $len = $sub_posi{$SubjectPos_sort[$i]} - $SubjectPos_sort[$i] + 1;
		print O "$seq1_name$id\t$seq2_name\t$strand\t$SubjectPos_sort[$i]\t";$id++;
		print O "$sub_posi{$SubjectPos_sort[$i]}\t$len\n";	
			
	}
	
	#@SubjectPos_sort=();
	%sub_posi=();
	$strand = '+';
}


	
close O;
close P;


sub Head {
	print <<"HEAD";
	
$0 Version $Version ($Date) - 

	$Function
	
	Update : $Update
	Author : $Author
	Contact: $Contact

--------------------------------------------------------------------------------
Input file to search  :   $input
Sequence cover region :   $position
Exon position file    :   $output
--------------------------------------------------------------------------------

HEAD
}



sub Usage #help subprogram
{
    print << "    Usage";
    
	Version: $Version
	Author : $Author
	Update : $Update
	
	Description :
	
		$Function!

	Usage: $0 <options>

		-i            Input sim4 result

		-e            Exon boundary position file, default "Exon_posi.tab"
		
		-p            Sequence position file, default "Sequence_cover_region.tab"
		
		-h or -help   show help , have a choice

    Usage

	exit(0);
};		

