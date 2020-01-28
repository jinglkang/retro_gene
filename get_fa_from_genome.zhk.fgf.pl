#!/usr/bin/perl

my $Version =  "V.1.0";
my $Author  =  "Hongkun Zheng";
my $Date    =  "2004-2-19";
my $Update  =  "2004-2-19 14:38";
my $Function=  "Cut sequence by Give position.";
my $Contact =  "zhenghk\@genomics.org.cn";
#my $modify  =  "2004-4-22 17:04, if minus, get the complement sequence.";
my $modify  =  "2004-4-22 17:04, if -, allow stop < start";

#-------------------------------------------------------------------

#-------------------------------------------------------------------

use strict;
use Getopt::Long;
use Data::Dumper;


my %opts;

GetOptions(\%opts,"p:s","s:s","o:s","help");


if(!defined($opts{p}) || !defined($opts{s}) || !defined($opts{o}) || defined($opts{help}) ){
	
	Usage();
	
}

my $position   =    defined $opts{p} ? $opts{p} : "";
my $sequence   =    defined $opts{s} ? $opts{s} : "";
my $output  =    defined $opts{o} ? $opts{o} : "";


Head();

my %positionHash;
my %strandHash;
LoadPosition($position,\%positionHash,\%strandHash);

#print Dumper %positionHash;


my $join_tag = "__";

open (CHRO,$sequence) || die "open sequence error [$sequence]\n";
open (OUT,">$output") || die "output error [$output]\n";

my $seq = '';
my $seq_name = '';

while(<CHRO>){
	chomp;
	if(/^>/){
		
		if($seq ne ''){
			#print $seq_name,"\n";
			cut($seq_name,\$seq,\%{$positionHash{$seq_name}},\%strandHash);
		}
		
		delete $positionHash{$seq_name};
		
		$seq = '';
		($seq_name) = $_ =~/^>(\S+)/;
		#print $seq_name,"\n";
	}
	else {
		$seq.=$_;	
	
	}
}
if($seq ne ''){
	#print $seq_name,"\n";
	#print Dumper %positionHash;
	
	#print Dumper %{$positionHash{$seq_name}};
	
	cut($seq_name,\$seq,\%{$positionHash{$seq_name}},\%strandHash);
}

close CHRO; 
close OUT;


	


sub cut {
	my ($seq_name,$r_seq,$r_posi,$r_strand)=@_;
	
	foreach my $cdna (keys %{$r_posi}){
		
		foreach my $start (keys %{$$r_posi{$cdna}}){
			
			print OUT ">".$cdna.$join_tag.$seq_name.$join_tag.$start.$join_tag.$$r_posi{$cdna}->{$start}." ".$$r_strand{$cdna.$seq_name.$start.$$r_posi{$cdna}->{$start}}."\n";
			#print ">$cdna\_$seq_name\_$start\_$$r_posi{$cdna}->{$start}\n";
			
			
			if($start<1){
				$start=1;
			}
						
			my $entry_all=substr($$r_seq,$start-1,($$r_posi{$cdna}->{$start}-$start+1));
			
			
#			if($strandHash{$cdna.$seq_name.$start.$$r_posi{$cdna}->{$start}} eq '-'){
#				if ($cdna eq 'AK072279'){
#					print "ERROR\n";
#					exit;
#				}
#				
#				$entry_all=~tr/atgcATGC/tacgTACG/;
#				$entry_all = reverse $entry_all;
#			}
			
			
			my $multiple=int((length $entry_all)/60*1.0000001);
			my $residual=(length $entry_all)%60;
			
			
			my $temp = '';
			
			for(my $i=0;$i<=$multiple-1;$i++){
				$temp=substr($entry_all,$i*60,60);
				print OUT "$temp\n";
			}
			if($residual==0){
				next;
			}
			$temp=substr($entry_all,$multiple*60,$residual);
			print OUT "$temp\n";
		}
	}
}



sub LoadPosition {
	my ($file,$r_hash,$r_strand)=@_;
	open(I,$file)||die"position table open error [$file]\n";
	while(<I>){
		#0610027H24      chr1    -       91155880        91167035
		chomp;
		my @info = split(/\s+/);
		
		if ($info[3]<=0){
			$info[3]=1;
		}
		
		if($info[4]<=$info[3]){
			if ($info[2] eq '-'){
				warn "Stop position is smaller than start one!\n";
				$$r_hash{$info[1]}->{$info[0]}->{$info[4]}=$info[3];
			}
			else {
				warn "Stop position is smaller than start one!\nProgram Abort!\n";
				exit;
			}
		}
		else {
			$$r_hash{$info[1]}->{$info[0]}->{$info[3]}=$info[4];
		}
		
		$$r_strand{$info[0].$info[1].$info[3].$info[4]}=$info[2];
		
	}
	close I;
}




sub Head {
	print <<"HEAD";
	
$0 Version $Version ($Date) - 

	$Function
	
	Update : $Update
	Author : $Author
	Contact: $Contact

--------------------------------------------------------------------------------
Input file to search  :   $position
Input file to search  :   $sequence
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
	
		$Function!

	Usage: $0 <options>

		-p            Position table

		-s            Sequence file
		
		-o            Output file
		
		-h or -help   Show Help , have a choice

    Usage

	exit(0);
};		

