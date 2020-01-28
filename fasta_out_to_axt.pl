#!/usr/local/bin/perl

my $Version =  "V.3.1";
my $Author  =  "Hongkun Zheng";
my $Date    =  "2003-10-9";
my $Update  =  "2003-10-10 21:33";
my $Function=  "Convert fasta to axt format!";
my $Contact =  "zhenghk\@genomics.org.cn";
my $modify  =  "";



#-------------------------------------------------------------------

#-------------------------------------------------------------------
$|=1;
use strict;
use Getopt::Long;
use Data::Dumper;
use Bio::SearchIO;
use Bio::Root::Root;

my %opts;

GetOptions(\%opts,"id:s","o:s","help");


if(!defined($opts{id}) || !defined($opts{o}) || defined($opts{help}) ){
	
	Usage();
	
}

my $input_dir   =    defined $opts{id} ? $opts{id} : "";
my $output  =    defined $opts{o} ? $opts{o} : "";


Head();

my @files = `ls $input_dir`;
chomp @files;

my $lost = "LostExon.list2";

open(O,">$output")||die"error created [$output]\n";
open(L,">$lost")||die"error created [$lost]\n";

my $total = scalar @files;

for (my $i=0;$i<$total;$i++){
	
	
	printf("Number: %d; Complete: %.3f\%; FileName: $files[$i]          \r",$i,$i/$total*100);
	
	my $filename = $files[$i];
	
	#print $filename,"\n";
	
	
	my $search=Bio::SearchIO->new(-format=>'fasta', -file=>"$input_dir/$filename");
	while (my $res=$search->next_result) {
		#print "yes!\n";
		while (my $hit=$res->next_hit) {
			#print $res->query_name,"\t";
#			$res->query_length,"\n";
			while (my $hsp=$hit->next_hsp) {

				if ($hsp->num_identical/$res->query_length>=0.8){
					
					my $query_string = $hsp->query_string;
					my $hit_string = $hsp->hit_string;
					
					if ($query_string eq ''){
						last;
					}
					
					my $gaps = $hsp->gaps('query');
					
					
					my $cut_start = 30;
					
					if ($hsp->strand('query') == 1){
						if ($hsp->start('hit') <=30){
							if ($hsp->start('query')<=30){
								if($hsp->start('query') > $hsp->start('hit')){
									$cut_start = $hsp->start('query')-1;
								}
								else {
									$cut_start = $hsp->start('hit')-1;
								}
							}
							else {
								$cut_start = 30;
							}
						}
						else {
							$cut_start = 30;
						}
					}
					
					if ($hsp->strand('query') == -1){
						if ($hsp->start('hit') <=30){
							
							if ($res->query_length - $hsp->end('query') <=30){
								
								if($res->query_length - $hsp->end('query') > $hsp->start('hit')){
									
									$cut_start = $res->query_length - $hsp->end('query');
								}
								else {
									$cut_start = $hsp->start('hit')-1;
								}
							}
							else {
								$cut_start = 30;
							}
						}
						else {
							$cut_start = 30;
						}
					}
						
					
					
					my $match_length = abs($hsp->start('query')-$hsp->end('query')) + 1 + $gaps;
					
					#print $match_length,"\t";
					#print $cut_start,"\t";
					#print length $query_string,"\t";
					#print length $hit_string,"\n";
					
					#print $query_string,"==\n";
					
					$query_string = substr($query_string,$cut_start,$match_length);					
					$hit_string   = substr($hit_string,$cut_start,$match_length);
					
					
					if ($hsp->strand('query') == -1){
						$query_string =~tr/atgcATGC/tacgTACG/;
						$query_string = reverse $query_string;
						$hit_string =~tr/atgcATGC/tacgTACG/;
						$hit_string = reverse $hit_string;
					}
					
					print O $res->query_name, " ",
						$hsp->start('query'), "-",
						$hsp->end('query'), " ",
						$hit->name, " ",
						$hsp->start('hit'), "-",
						$hsp->end('hit'), " ",
						$hsp->strand('query'), " ",
						$hsp->strand('hit'), " ",
						$res->query_length, " ",
						$hsp->num_identical, "\n",
						$query_string, "\n",
						$hit_string, "\n\n";
				}
				else {
					print L $res->query_name, " ",
						$hsp->start('query'), "-",
						$hsp->end('query'), " ",
						$hit->name, " ",
						$hsp->start('hit'), "-",
						$hsp->end('hit'), " ",
						$hsp->strand('query'), " ",
						$hsp->strand('hit'), " ",
						$res->query_length, " ",
						$hsp->num_identical, "\n",
						#$query_string, "\n",
						#$hit_string, "\n\n";
				}
				last;
			}
			last;
			
		}
	}
	
}

close O;

sub Head {
	print <<"HEAD";
	
$0 Version $Version ($Date) - 

	$Function
	
	Update : $Update
	Author : $Author
	Contact: $Contact

--------------------------------------------------------------------------------
Input file to search  :   $input_dir
Output file written   :   $output
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
	
		$Function

	Usage: $0 <options>

		-id            Input Directory contain blast result

		-o             Output axt file
		
		-h or -help    show help , have a choice

    Usage

	exit(0);
};		

