#!/usr/local/bin/perl

my $Author  =  "Hongkun Zheng";
my $Date    =  "2004-4-22";
my $Function=  "Deal with GeneWise result to get gene paralog families!";
my $Contact =  "zhenghk\@genomics.org.cn";

my $Version =  "V.1.0";

my $Version =  "V.2.0";
my $Update  =  "2004-4-22 11:21";
my $modify  =  "Modify the genomic position when happens frameshift!";
my $Version =  "V.2.2";
my $Update  =  "2004-8-21 13:51";

my $Version =  "V.3.0";
my $Update  =  "2004-10-26 13:32";
my $modify  =  "debug the exon number when frameshift happen.";

my $Version =  "V.4.0";
my $Update  =  "2004-11-5 14:21";
my $modify  =  "use gap instead the codon in different exons, or exons is not start with phase 0!";
my $Version =  "V.4.2";
my $Update  =  "2004-11-12 14:02";
my $modify  =  "add gap instead of intron like indels.";
my $Version =  "V.4.4";

my $Version =  "V.5.0";
my $Update  =  "2004-11-16 14:58";
my $modify  =  "Modify identity calculation to ignore gap.";
my $Version =  "V.5.2";
my $Update  =  "2004-11-17 11:28";
my $modify  =  "Add the true codon in different exons.";

my $Version =  "V.6.0";
my $Update  =  "2004-11-18 0:08:14";
my $modify  =  "debug Multiple sequence generation, correct the InDel position.";
my $Version =  "V.6.2";
my $Update  =  "2004-11-19 21:39";
my $modify  =  "debug split codon count.";
my $Version =  "V.6.4";
my $modify  =  "debug before start indels.";
my $Version =  "V.6.6";
my $Update  =  "2005-3-16";
my $modify  =  "debug, added split codon position.";
my $modify  =  "debug, add unsupport protion region.";
my $Update  =  "2005-3-17";
my $modify  =  "debug, deal with frameshift in sub function CountExon();";
my $modify  =  "add BLAT like output file.";

my $Version = "V.7.0";
my $Update  = "2005-3-21 15:51";
my $modify  = "frameshift porblems;";

my $Version = "V.8.0";
my $Update  = "2005-3-22 18:56";
my $modify  = "change the arithmetic of the exon length;";
my $Version = "V.8.2";
my $Update  = "2005-7-31 11:43";
my $modify  = "add the sort part within the program.";
my $Version = "V.8.4";
my $Update  = "2006-02-14 14:08";
my $modify  = "debug NULL dna_name.";
my $modify  = "revised input and output options.";
my $Version = "V.8.6";
my $Update  = "2006-02-14 15:16";
my $modify  = "change the method to sort genewise input file.";
my $Update  = "2006-05-18 09:18";
my $modify  = "debug, when the space is at the end of the line, the reverse the seq and remove it first.";
my $Update  = "2005-05-22 15:55";
my $modify  = "reverse space string;";

my $Version = "V.8.8";
my $Update  = "2006-9-9 10:58";
my $modify  = "genewise result only for one strand, not both.";

my $Version = "V.9.0";
my $Update  = "2006-11-9 18:16";
my $modify  = "debug rows with no indels, and with split codon.";

my $Version = "V.10.0";
my $Update  = "2006-12-12 17:19";
my $modify  = "debug entries with intron like indels, add int.";

my $Version = "V.10.2";
my $update  = "2007-1-8 01:51";
my $modify  = "debug two split codon in one line, or with small exons.";



#-------------------------------------------------------------------

#-------------------------------------------------------------------

use strict;
use Getopt::Long;
use Data::Dumper;

my %opts;

GetOptions(\%opts,"i:s","q:s","m:s","ot:s","os:s","ob:s","s:s","only","help");


if((!defined($opts{i}) || !defined($opts{q})) || defined($opts{help}) ){
	
	Usage();
	
}

my $input         =    defined $opts{i} ? $opts{i} : "";
my $query_file    =    defined $opts{q} ? $opts{q} : "";
my $step          =    defined $opts{s} ? $opts{s} : "1";
my $middle_file   =    defined $opts{m} ? $opts{m} : "middle.out";
my $blat_format   =    defined $opts{ob} ? $opts{ob} : "genewise2blat.psl";
my $output_seq    =    defined $opts{os} ? $opts{os} : "multiple_sequence.out";
my $output_table  =    defined $opts{ot} ? $opts{ot} : "$middle_file.tab";


###############################
#

my $score_cutoff = 35;

#
###############################


if (($step != 0) && ($step != 1)) {
	
	print "ERROR:\n-s only can be 0 or 1\n\n";
	
	Usage();
	
}


Head();


my %query_len;
my $protein_name = '';
my $dna_name = '';
my $input_filename = (split(/\//,$input))[-1];	#added 2006-02-14 zhenghk
my $input_sort = "sort_$input_filename";	#modified 2006-02-14 zhenghk

if ($step == 1){
	
	print "Step 1: Process for output_table and output_blat_format...\n";

	LoadQueryLen($query_file,\%query_len);
	
	SortGeneWise($input,$input_sort);
	
	$/="genewise \$Name: ";
	
	open(I,$input_sort)||die"open genewise output error [$input]!\n";
	open(O,">$output_table")||die"output error [$output_table]\n";
	open(M,">$middle_file")||die"output error [$middle_file]\n";
	open(BLAT,">$blat_format") || die "output blat format error [$blat_format]\n";
	while(<I>){
				
		if ($_ eq 'genewise $Name: '){
			next;
		}
		
		#print $_,"\n";
		my $i=0;
		
		my @temp = split(/genewise output\n/);
		#print scalar @temp,"\n";
		my @data;
		my $output_tag = 0;
		my $global_strand;
		
		for(my $block_count=0;$block_count<@temp;$block_count++){

			$output_tag = 0;

			if($block_count == 0){
				my @block = split(/\n/,$temp[$block_count]);
				($protein_name) = $block[4]=~/Query protein\:\s+(\S+)/;
				($dna_name) = $block[9]=~/Target Sequence\s+(\S+)/;
				my ($temp_strand) = $block[10]=~/Strand\:\s+(\S+)/;
				
				if ($temp_strand eq 'reverse'){
					$global_strand = '-';
				}
				else {
					$global_strand = '+';
				}
				
					
				#print $protein_name,"\t",$dna_name,"\n";
			}
			else {
				analysis_block(\@temp,$block_count,\@{$data[$block_count]});
				
				print M Dumper @{$data[1]};
						
				if ($data[1]->[0] ne '') {
						$output_tag = 1;
				}
						
				#print Dumper @{$data[1]};

				if($data[1][0] ne ''){
					print O "$data[1][0]\t$data[1][1]\t$data[1][9]\t$data[1][10]\t$data[1][5]\t$data[1][16]\t$data[1][11]\t$data[1][3]\t$data[1][4]\t$data[1][12]\t$data[1][13]\n";
					print BLAT "$query_len{$data[1][0]}\t0\t0\t0\t0\t0\t0\t0\t$global_strand\t$data[1][0]\t$query_len{$data[1][0]}\t$data[1][9]\t$data[1][10]\t$data[1][1]\t10000000\t$data[1][12]\t$data[1][13]\t$data[1][11]\t",join("\t",@{$data[1][17]}),"\n";
				}
				
				if ($block_count == 2){
					
					warn "genewise format error\n";
					exit;
					
				}
			}
		}

		if ($output_tag == 1) {
			print M "//\n";
		}
		else {
			warn "Warnning: GeneWise Score between $protein_name and $dna_name is lower than $score_cutoff!\n";
		}
	}
	close M;
	close O;
	close BLAT;
	
	if (!defined $opts{only}){
		$step++;
	}
	
	
}


if ($step == 2) {
	
	print "\nStep 2: Process for output of multiple sequence alignment format...\n\n";
	MultipleSeq($middle_file,$output_seq);

}






##### sub functions:

sub SortGeneWise {
	my ($input,$output) = @_;
	
	my %out;
	my %relation;
	$/="genewise \$Name:";
	
	open(I,$input)||die "Can't open genewise input file[$input]!\n";
	open(O,">$output")||die "Can't output sort-genewise file[$output]!\n";
	
	while(<I>){
		
		if ($_ eq 'genewise $Name:'){
			next;
		}
		
		my ($name) = $_=~/Target Sequence\s+(\S+)/; #modify 2006-02-14
		my ($pro_name) = $_=~/Query protein\:\s+(\S+)/;	#added 2006-02-14
		$relation{$name} = $pro_name;
		
		#print $name,"\n";
		
		$_ =~s/genewise \$Name:$//;
		$_= "genewise \$Name:".$_;
		
		if (exists $out{$name}){
			print $name,"\n";
			print $out{$name};
			print $_,"\n";
			
			$out{$name} = $_;
			
		}
		else {
			$out{$name} = $_;
		}
		
	
	}
	
	#print Dumper %relation;
	
	foreach (sort {$relation{$a} cmp $relation{$b}} keys %relation){
		#print $_,"\n";
		print O $out{$_};
	}
	
	close I;
	close O;
}



sub analysis_block {
	my ($r_temp,$block_count,$r_return) = @_;
	my $i = 0;
	my @block = split(/\n/,$$r_temp[$block_count]);
	my ($score) = $block[0]=~/Score (\S+) bits over entire alignment/;
	my %space;
	my @lost_codon_info;
	my $protein_seq       = LoadProSeq(\@block,\%space);

	#print Dumper %space;

	my $exact_match_seq   = LoadMatchSeq(\@block);
	my $aligned_dna_seq   = LoadDNAnuclicSeq(\@block,\%space);
	my $dna_translate_seq = LoadDNAtranslateSeq(\@block,\$i,\%space,\@lost_codon_info); # 2004-11-17 11:46 add an array @lost_codon_info;
	
	#print Dumper @lost_codon_info;
	
	##### Judge stop codon and frame shift
	my $stop_codon = 0;
	my $frame_shift = 0;
	my $shift_join = '';
	my $stop_join = '';
	
	if ($dna_translate_seq=~/X/){
		my $tmp_dna = $dna_translate_seq;
		my @stop_position;
		subseq_positions($dna_translate_seq,"X",\@stop_position);
		$stop_join = join("\:",@stop_position);
		$stop_codon=1;
	}
	if ($dna_translate_seq=~/\!/){
		my $tmp_dna = $dna_translate_seq;
		my @shift_position;
		subseq_positions($dna_translate_seq,"!",\@shift_position);
		$shift_join = join("\:",@shift_position);
		$frame_shift=1;
	}
	
	#print $dna_translate_seq,"\n";
	
	###### identity calculation
	if ((length $protein_seq) == 0){
		print "Something Error:",$protein_name,"\t",$dna_name,"!!!\n";
		exit;
	}
	
	my $no_gap_protein_seq = $protein_seq;
	$no_gap_protein_seq =~s/-//g;
		
	#my $identity = int (length($exact_match_seq)/length($protein_seq) * 10000 + 0.5) / 100;
	my $identity = int (length($exact_match_seq)/length($no_gap_protein_seq) * 10000 + 0.5) / 100;
	
	##### output
	if($score > $score_cutoff){
		#print Dumper %space;
		
		#print "$protein_name\t$dna_name\t$score\t$frame_shift\t$stop_codon\t$identity\n";
		#print $protein_seq,"\n";
		#print $dna_translate_seq,"\n";
		
		#my %FrameShiftInfo;
		#GetFrameShiftInfo(\$aligned_dna_seq,\%FrameShiftInfo);
		#print Dumper %FrameShiftInfo;
		
		
		my @position;
		my @dna_posi;
		
		my @exon_len;
		my %phase_exon;
		
		my @blat_data;
		
		my $exon_num = CountExon(\@block,$i,$block_count,\@position,\@dna_posi,\@exon_len,\%phase_exon,\@blat_data);
		
		#print Dumper @blat_data;
		
		#print Dumper @position;
		#print Dumper @dna_posi;
		#print Dumper @exon_len;
		
		
		#RemoveFrameShiftLen(\%FrameShiftInfo,\@exon_len);
		
		#print Dumper @exon_len;
		#print Dumper @lost_codon_info;
		
		#print $protein_seq,"\n";
		#print $dna_translate_seq,"\n";
		#print $aligned_dna_seq,"\n";
		#print "=============\n";

		DealSplitCodon(\$protein_seq,\$dna_translate_seq,\$aligned_dna_seq,\@exon_len,\%phase_exon,\@lost_codon_info);
		
		#print $protein_seq,"\n";
		#print $dna_translate_seq,"\n";
		#print $aligned_dna_seq,"\n";
		#print "=============\n";
		
		# modify zhenghk 2004-7-2 13:45
		# modify zhenghk 2004-10-26 14:47 modify "!" deletion bug!
		
		# modify zhenghk 2005-3-17 10:45, deal with the frameshift in the sub function CountExon();
		#my $copy_dna_translate_seq = $dna_translate_seq;
		#my ($disruption_frame) = $copy_dna_translate_seq =~s/\!//g;
		#$exon_num -= $disruption_frame;
		
		$$r_return[0]=$protein_name;
		$$r_return[1]=$dna_name;
		$$r_return[2]=$score;
		$$r_return[3]=$frame_shift;
		$$r_return[4]=$stop_codon;
		$$r_return[5]=$identity;
		$$r_return[6]=$protein_seq;
		$$r_return[7]=$dna_translate_seq;
		$$r_return[8]=$aligned_dna_seq;
		$$r_return[9]=$position[0];
		$$r_return[10]=$position[-1];
		$$r_return[11]=$exon_num;
		$$r_return[12]=$dna_posi[0];
		$$r_return[13]=$dna_posi[-1];
		$$r_return[14]=$stop_join;
		$$r_return[15]=$shift_join;
		$$r_return[16]=int(($position[-1]-$position[0])/$query_len{$protein_name}*10000+0.5)/100;
		$$r_return[17][0]=$blat_data[0];
		$$r_return[17][1]=$blat_data[1];
		$$r_return[17][2]=$blat_data[2];
		$$r_return[17][3]=$blat_data[3];
		
		
		
	}
}

sub GetFrameShiftInfo {
	my ($r_seq,$r_info) = @_;
	
	my $seq_copy = $$r_seq;
	
	my (@frame_len) = $seq_copy =~/(\d+)/g;
	
	my @sub_seq = split(/\d+/,$$r_seq);
	my $position = '';
	
	for(my $i=0;$i<@frame_len;$i++) {
		if ($i>0){
			$position += (length $sub_seq[$i]) + (length $frame_len[$i-1]);	
		}
		else {
			$position += (length $sub_seq[$i]);	
		}
		
		$$r_info{$position} = $frame_len[$i];
	}	
}

		
	
sub RemoveFrameShiftLen {
	my ($r_frame_info,$r_exon_len) = @_;
	
	
	foreach my $position (keys %$r_frame_info) {
		if ($$r_frame_info{$position} < 3){
			next;
		}
		else {
			my $exon_start = 1;
			for(my $i=0;$i<@$r_exon_len;$i++){
				
				if (($position/3) > $exon_start && ($position/3) < $$r_exon_len[$i]) {
					$$r_exon_len[$i] -= int($$r_frame_info{$position}/3);
				}
				$exon_start = $$r_exon_len[$i] + 1;
			}
		}
	}
}

			
sub subseq_positions {
	my ($seq,$sub_seq,$r_posi) = @_;
	
	if ($sub_seq eq '@'){
		print "Sub seq can not be \@\n";
		exit;
	}
	
	my (@space) = $seq=~/$sub_seq/g;
	my $i = 0;
	foreach (@space){
		#print $_,"\n";
		my $target = '@' x (length $_);
		$$r_posi[$i++] = index($seq,$_);
		$seq =~ s/$_/$target/;
		#print $seq,"\n";
	}
}


sub LoadProSeq {
	my ($r_block,$r_space)=@_;
	
	##### protein sequence
	my $protein_seq = '';
	
	for(my $i=6,my $j=0;$i<@$r_block;$i+=8,$j++){
		
		if($$r_block[$i]=~/\/\//){
			last;
		}
		my $sub_seq = substr($$r_block[$i],21,49);
		#print $sub_seq,"<<<===\n";
		my (@space) = $sub_seq=~/(\s+)/g;
		
		foreach (@space){
			my $target = 'B' x (length $_);
			$$r_space{$j}->{index($sub_seq,$_)} = (length $_);
			$sub_seq =~ s/$_/$target/;
		}
		
		$protein_seq .= $sub_seq;
	}
	$protein_seq =~s/B//g;
	
	return $protein_seq;
}


sub LoadMatchSeq {
	my ($r_block) = @_;
	##### Match seqeunce
	my $match_seq = '';
	
	for(my $i=7;$i<@$r_block;$i+=8){
		if($$r_block[$i]=~/^Gene/){
			last;
		}
		$match_seq .= substr($$r_block[$i],21,49);
	}
	$match_seq =~s/\s//g;
	my $exact_match_seq = $match_seq;
	$exact_match_seq =~s/\+//g;
	
	return $exact_match_seq;
	
}

sub LoadDNAtranslateSeq {
	my ($r_block,$r_i,$r_space,$r_lost_codon) = @_;
	
	##### DNA translate sequences
	my $i = 0;
	my $dna_translate_seq = '';
	my $lost_count = 0;
	my $save_last_lost_codon;

	#print Dumper %$r_space;
	
	for($i=8,my $j=0;$i<@$r_block;$i+=8,$j++){
		if($$r_block[$i]=~/^Gene/){
			last;
		}
		my $sub_seq = substr($$r_block[$i],21,49);

		#print "1:[$sub_seq]\n";
		
		
		#print "[$j]\n";
		
		if(exists $$r_space{$j}){
				#print "Line num: [$j]\n";
				#print Dumper %{$$r_space{$j}};
								
				foreach my $start (sort {$$r_space{$j}->{$b} <=> $$r_space{$j}->{$a}} keys %{$$r_space{$j}}){
						my $space = substr($sub_seq,$start,$$r_space{$j}->{$start});
						
						#print "[$space]\n";
		
						my $target = 'B' x (length $space);
						#print $target,"==>>>\n";
						#print $sub_seq,"<<<\n";
						
						$space = quotemeta($space);
						$sub_seq=~tr/ /B/;
						
						#print $sub_seq,">>>\n";
		
				}
	
				#print "2:[$sub_seq]\n";
	
				foreach my $start (sort {$a <=> $b} keys %{$$r_space{$j}}){
					my $space = substr($sub_seq,$start,$$r_space{$j}->{$start});
					my @lost_codon_array;
					my $lost_codon;
					
					#print $space,"\n";
					my $space_back = $space;
					(@lost_codon_array) = $space_back =~/([^B]\:[^B]\[[^B]+\])/g;
					
					if (@lost_codon_array > 1) {		# added by zhenghk 2007-1-8 01:51; Version 10.2;
							warn "\nWARNING!!! Small exon exists in the genewise alignment, please check it carefully!\n";
							warn "$sub_seq\n";
					}
					
					$lost_codon = $lost_codon_array[0];
					
					#print "Lost codon: [$lost_codon]\n";
	
					#print "Exon num: [$lost_count]\n";
	
					if ($$r_space{$j}->{$start} + $start == 49){ # modify skip end space, 2004-11-19 21:39;
						
						############### added by zhenghk Version 10.2
						if (@lost_codon_array > 1) {
								$$r_lost_codon[$lost_count] = $lost_codon_array[0];
								$lost_count++;
								$$r_lost_codon[$lost_count] = $lost_codon_array[1];
						}
						else {
								$$r_lost_codon[$lost_count] = $lost_codon;
						}
						
						my $next_gap_start;
						
						if (exists $$r_space{$j+1}) {
								$next_gap_start = (sort {$a <=> $b} keys %{$$r_space{$j+1}})[0];
						}
						
						
						#print "End is 49: next start is [$next_gap_start]\n";
						
						if ($next_gap_start != 0){
							$lost_count++;
						}
						
					}
					elsif($start == 0) {
						
						my $last_gap_start = (sort {$a <=> $b} keys %{$$r_space{$j-1}})[-1];
						
						my $last_gap_end;
						
						if (exists $$r_space{$j-1}) {
								$last_gap_end = $last_gap_start + $$r_space{$j-1}->{$last_gap_start};
						}
						
						
						#print "Start is 0: last end is [$last_gap_end]\n";
						
						if ($last_gap_end == 49){
							if ($$r_lost_codon[$lost_count] eq '') {
									#print "in\n";
									#$$r_lost_codon[$lost_count] = $lost_codon;
									
									############### added by zhenghk Version 10.2
									if (@lost_codon_array > 1) {
											$$r_lost_codon[$lost_count] = $lost_codon_array[0];
											$lost_count++;
											$$r_lost_codon[$lost_count] = $lost_codon_array[1];
									}
									else {
											$$r_lost_codon[$lost_count] = $lost_codon;
									}

							}
						}
						else {
								#$$r_lost_codon[$lost_count] = $lost_codon;
								
								############### added by zhenghk Version 10.2
								if (@lost_codon_array > 1) {
										$$r_lost_codon[$lost_count] = $lost_codon_array[0];
										$lost_count++;
										$$r_lost_codon[$lost_count] = $lost_codon_array[1];
								}
								else {
										$$r_lost_codon[$lost_count] = $lost_codon;
								}
						}
								
						$lost_count++;
					}
					else {
							#$$r_lost_codon[$lost_count] = $lost_codon;
							############### added by zhenghk Version 10.2
							if (@lost_codon_array > 1) {
									$$r_lost_codon[$lost_count] = $lost_codon_array[0];
									$lost_count++;
									$$r_lost_codon[$lost_count] = $lost_codon_array[1];
							}
							else {
									$$r_lost_codon[$lost_count] = $lost_codon;
							}
						
							$lost_count++;
						
					}
					
					$save_last_lost_codon=$lost_codon;
					
					if ($lost_codon ne '') {
						my $target = 'B' x 8;
						#print "[$lost_codon] [$target]============================\n";
						$lost_codon = quotemeta($lost_codon);
						$sub_seq=~s/$lost_codon/$target/;
						#print "[$sub_seq]\n";
						
						if (@lost_codon_array > 1) {
								$lost_codon_array[1] = quotemeta($lost_codon_array[1]);
								$sub_seq=~s/$lost_codon_array[1]/$target/;
						}
					}
				}
				#print "3:[$sub_seq]\n";
		}
		else {			#added zhenghk 2006-11-9 18:15; version 9.0; dealwith rows with no indels;

			#print "$j&&&&&&&&&&&&&&&\n";
			
			if (exists $$r_space{$j-1}) {		
					#print "###########################\n";
					#print Dumper %{$$r_space{$j-1}};
					
					my $last_gap_start = (sort {$a <=> $b} keys %{$$r_space{$j-1}})[-1];
					#print $last_gap_start,"++++++++++++++++++++++++\n";
					if ($$r_space{$j-1}->{$last_gap_start} + $last_gap_start == 49){
							#print "$save_last_lost_codon,===============\n";
							$$r_lost_codon[$lost_count] = $save_last_lost_codon;
							$lost_count++;
					}
			}
		}
			
		#print "[==$lost_count==]\n";
		#print "[==$lost_codon==]\n";

		
		$dna_translate_seq .= $sub_seq;
	}
	$dna_translate_seq =~s/B//g;
	#print "[$dna_translate_seq]\n";
	$$r_i = $i;
	return $dna_translate_seq;
}

sub LoadDNAnuclicSeq {
	my ($r_block,$r_space) = @_;
	
	##### DNA nuclic sequences
	my $i = 0;
	my $dna_na_seq = '';
	
	#print Dumper %{$r_space};
	
	for($i=9,my $j=0;$i<@$r_block;$i+=8,$j++){
		
		my @phase;
		
		if($$r_block[$i]=~/^\s+Exon/){
			last;
		}
		for(my $k=$i;$k-$i<3;$k++){
			my $sub_seq = substr($$r_block[$k],21,49);
			#print $sub_seq,">>>>>>>>\n";
			if(exists $$r_space{$j}){
				foreach my $start (sort {$$r_space{$j}->{$b} <=> $$r_space{$j}->{$a}} keys %{$$r_space{$j}}){
					my $space = substr($sub_seq,$start,$$r_space{$j}->{$start});
					#print $space,"<<<==\n";
					
					my $target = 'B' x (length $space);
					#print $target,"==>>>\n";
					#print $sub_seq,"<<<\n";

					# modify 2006-05-18 zhenghk, if the space is at the end of the sequences, reverse the subseq then substitute it;
					if ($start + $$r_space{$j}->{$start} == 49) {
						$sub_seq = reverse($sub_seq);
						#print $sub_seq,"########reverse seq\n";
						$space = reverse($space);		#modify 2005-05-22 zhenghk;
						$space = quotemeta($space);
						$sub_seq=~s/$space/$target/;
						$sub_seq = reverse($sub_seq);
					}
					else {
						$space = quotemeta($space);
						$sub_seq=~s/$space/$target/;
					}

					#print $sub_seq,">>>\n";
				}
			}
			$sub_seq =~ s/B//g;
			$sub_seq =~ s/ /-/g;
			
			#print $sub_seq,"<<<===\n";
			
			@{$phase[$k-$i]}=split(//,$sub_seq);
			
		}
		
		my $sub_dna_na_seq = '';
		for(my $n=0;$n<@{$phase[0]};$n++){
			for(my $k=0;$k<3;$k++){
				$sub_dna_na_seq .= $phase[$k]->[$n];
			}
		}
		
		#print $sub_dna_na_seq,"\n";
		$dna_na_seq .= $sub_dna_na_seq;		
		
	}
	
	$dna_na_seq =~s/B//g;
	
	return $dna_na_seq;
}




sub CountExon {
	#my ($r_block,$i,$block_count,$r_posi,$r_dna,$r_exon_len,$r_phase_exon,$r_QS,$r_QL,$r_SStart,$r_SStop) = @_;
	my ($r_block,$i,$block_count,$r_posi,$r_dna,$r_exon_len,$r_phase_exon,$r_blat) = @_;
	
	
	my $strand = '';
	my $exon_num = 0;
	my $start;
	my $stop;
	my $phase;
	
	my @posi;
	my %support_pro;
	my %support_dna;
	my %intron_like_insert;
	
	my $exon_support_end = 0;	# added 2005-3-16 15:06
	my %unsupport_pro;		# added 2005-3-16 15:06
	my $gene_count = 0;		# added 2005-3-17 10:19
	
	my @pro_array;			# added 2005-3-21 16:36 to deal with frameshift problem
	my @dna_array;			# added 2005-3-21 16:36 to deal with frameshift problem
	
	##### count exon number
	for($i-=1;$i<@$r_block;$i++){
		if($$r_block[$i]=~/\/\//){
			
			if (@pro_array > 0){
				
				#print Dumper @pro_array;
				#print Dumper @dna_array;
					
				# added 2005-3-21 16:33 deal with frameshift problems
				for(my $k=0;$k<@pro_array - 1;$k+=2){
					$support_pro{$pro_array[$k]} = $pro_array[$k+1];
					if ($dna_array[0] < $dna_array[-1]){
						$support_dna{$dna_array[$k]} = $dna_array[$k+1];
					}
					else {
						$support_dna{$dna_array[$k+1]} = $dna_array[$k];
					}
				}
				
				
				#print $start,"\t",$stop,"\n";
				#print Dumper %support_pro;
				#print Dumper %support_dna;
				
				my @sort_pro_start = sort {$a<=>$b} keys %support_pro;
				
				my $blat_query_start = $sort_pro_start[0];
				my $blat_query_len = $support_pro{$sort_pro_start[-1]} - $blat_query_start + 1;
				
				if ($$r_blat[0] eq '') {
					$$r_blat[0] = $blat_query_len.",";
					$$r_blat[1] = $blat_query_start.",";
					$$r_blat[2] = $start.",";
					$$r_blat[3] = $stop.",";
				}
				else {
					$$r_blat[0] .= $blat_query_len.",";
					$$r_blat[1] .= $blat_query_start.",";
					$$r_blat[2] .= $start.",";
					$$r_blat[3] .= $stop.",";
				}
				
					
					
				#push(@$r_QS,$blat_query_start);
				#push(@$r_QL,$blat_query_len);
				
				#push(@$r_SStart,$start);
				#push(@$r_SStop,$stop);
				
				#print Dumper @$r_SStart;
				
				
				GetIntronLikeGap(\%support_dna,$start,$stop,$phase,\%intron_like_insert);
				#print Dumper %intron_like_insert;
				
				print Dumper %unsupport_pro;
				
				
				
				$$r_exon_len[$exon_num-1] = CountExonLen(\%support_pro,\%support_dna,\%intron_like_insert,\%unsupport_pro);
				
				@pro_array = ();
				@dna_array = ();
					
				%support_pro = ();
				%support_dna = ();
				%intron_like_insert = ();
			}
			last;
		}
		if($$r_block[$i]=~/^\s+Exon/){
			
			if ($gene_count > 1){
				($stop) = $$r_block[$i]=~/\s+Exon\s+\d+\s+(\d+)\s+phase\s+\d+/;
				#$gene_count = 1;
			}
			else {
				
			
				if (@pro_array > 0){
					
					#print "in================\n";
					#print Dumper @pro_array;
					#print Dumper @dna_array;
					
					for(my $k=0;$k<@pro_array - 1;$k+=2){
						$support_pro{$pro_array[$k]} = $pro_array[$k+1];
						if ($dna_array[0] < $dna_array[-1]){
							$support_dna{$dna_array[$k]} = $dna_array[$k+1];
						}
						else {
							$support_dna{$dna_array[$k+1]} = $dna_array[$k];
						}
					}
					
					#print "$$r_block[$i]\n";
					
					#print $start,"\t",$stop,"\n";
					#print Dumper %support_pro;
					#print Dumper %support_dna;
					
					my @sort_pro_start = sort {$a<=>$b} keys %support_pro;
				
					my $blat_query_start = $sort_pro_start[0];
					my $blat_query_len = $support_pro{$sort_pro_start[-1]} - $blat_query_start + 1;
					
					if ($$r_blat[0] eq '') {
						$$r_blat[0] = $blat_query_len.",";
						$$r_blat[1] = $blat_query_start.",";
						$$r_blat[2] = $start.",";
						$$r_blat[3] = $stop.",";
					}
					else {
						$$r_blat[0] .= $blat_query_len.",";
						$$r_blat[1] .= $blat_query_start.",";
						$$r_blat[2] .= $start.",";
						$$r_blat[3] .= $stop.",";
					}
				
				
					#push(@$r_QS,$blat_query_start);
					#push(@$r_QL,$blat_query_len);
					
					#push(@$r_SStart,$start);
					#push(@$r_SStop,$stop);
				
					GetIntronLikeGap(\%support_dna,$start,$stop,$phase,\%intron_like_insert);
					
					#print Dumper %intron_like_insert;
					print Dumper %unsupport_pro;
					
					$$r_exon_len[$exon_num-1] = CountExonLen(\%support_pro,\%support_dna,\%intron_like_insert,\%unsupport_pro);
					
					@pro_array = ();
					@dna_array = ();
					
					%support_pro = ();
					%support_dna = ();
					%intron_like_insert = ();
				}
				
				($start,$stop,$phase)=$$r_block[$i]=~/\s+Exon\s+(\d+)\s+(\d+)\s+phase\s+(\d+)/; #add $phase by zhenghk 2004-11-5 14:53			
				
				#print $start,"\t",$stop,"\t++",$phase,"===============\n";
				### save lost split codon dna position, zhenghk 2004-11-5 15:03
				if ($phase > 0){
					$$r_phase_exon{$exon_num}=1;
					#print "====================\n";
				}
				###
				
				$exon_num++;
				if($block_count == 1){
					$strand = '+';
				}
				if($block_count ==2){
					$strand = '-';
				}
				#print "$protein_name\t$dna_name\t$strand\t$start\t$stop\n";
			}
		}
		if($$r_block[$i]=~/^\s+Supporting\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/){
			
			push(@posi,$3);
			push(@posi,$4);
			
			# added 2005-3-21 16:21 deal with frameshift problem;
			#print $gene_count,"\n";
			
			
			
			if ($gene_count > 1) {
				
				if (@dna_array == 0){
					print "=============\n";
					
					push(@dna_array,$1);
					push(@dna_array,$2);
					
					push(@pro_array,$3);
					push(@pro_array,$4);
				}
				else {
					$dna_array[-1] = $2;
					$pro_array[-1] = $4;
				}
				
				$gene_count = 1;
			}
			else {
				push(@dna_array,$1);
				push(@dna_array,$2);
				
				push(@pro_array,$3);
				push(@pro_array,$4);
			}
			
			#print Dumper @dna_array;
			
			#if ($1<$2){
			#	$support_dna{$1}=$2;
			#}
			#else {
			#	$support_dna{$2}=$1;
			#}
			
			if (@pro_array == 0 && $exon_support_end != 0){
				
				if ($3 - $exon_support_end > 2){
					
					if ($phase > 0){
						
						$unsupport_pro{$exon_support_end + 2} = $3 - 1;
					}
					else {
						$unsupport_pro{$exon_support_end + 1} = $3 - 1;
					}
					
				}
			}
			
			#$support_pro{$3}=$4;
			
			$exon_support_end = $4;
			
		}
		if($$r_block[$i]=~/^Gene\s+(\d+)\s+(\d+)/){
			
			$gene_count++;
			
			push(@{$r_dna},$1);
			push(@{$r_dna},$2);
		}
			
	}
	#print Dumper @posi;
	@{$r_posi} = sort {$a<=>$b} @posi;
	
	#print Dumper @$r_exon_len;
	#print Dumper %$r_phase_exon;
	
	return $exon_num;
}


sub CountExonLen {
	my ($r_pro,$r_dna,$r_intron_like,$r_unsupport_pro) = @_;
		
	
	###### get protein gaps;
	my $exon_no_gap_len = 0;
	my %protein_posi;
	my %protein_overlap;
	
	ProjectHash(\%$r_pro,\%protein_posi,\%protein_overlap);
	
	#print Dumper %protein_posi;
	
	my @pro_start = sort {$a<=>$b} keys %protein_posi;
	
	#print Dumper @pro_start;
	
	my $pro_gap = 0;
	
	for (my $i=0;$i<@pro_start;$i++){
		#print "$protein_posi{$pro_start[$i]} - $pro_start[$i] + 1\n";
		$exon_no_gap_len += $protein_posi{$pro_start[$i]} - $pro_start[$i] + 1;
		
		if ($pro_start[$i+1] eq ''){
			last;
		}
		
		#print "($pro_start[$i+1] - $protein_posi{$pro_start[$i]} - 1)\n";
		
		#$pro_gap =+ ($pro_start[$i+1] - $protein_posi{$pro_start[$i]} - 1);	# debug 2005-3-16 13:37, change "=+" to "+=";
		$pro_gap += ($pro_start[$i+1] - $protein_posi{$pro_start[$i]} - 1);
		
	}
	#print $pro_gap,"\n";
	
	#added 2005-3-16 15:17;
	if (keys %$r_unsupport_pro > 0){
		foreach my $lost_start (keys %$r_unsupport_pro){
			#print "[$lost_start\t$$r_unsupport_pro{$lost_start}\n";
			$pro_gap += $$r_unsupport_pro{$lost_start} - $lost_start + 1;
		}
	}
	
	
	###### get dna gaps;
	my %dna_posi;
	my %dna_overlap;
	
	ProjectHash(\%$r_dna,\%dna_posi,\%dna_overlap);
	
	#print Dumper %dna_posi;
	
	my @dna_start = sort {$a<=>$b} keys %dna_posi;
	
	my $dna_gap = 0;
	
	for(my $i=0;$i<@dna_start;$i++){
		
		# debug 2005-3-16 14:41 change "$i<@dna_start -1" to "$i<@dna_start";
		if ($dna_start[$i+1] eq ''){
			last;
		}
		
		#print "$dna_gap += ($dna_start[$i+1] - $dna_posi{$dna_start[$i]} - 1)/3;\n";
		$dna_gap += ($dna_start[$i+1] - $dna_posi{$dna_start[$i]} - 1)/3;
	}
	
	$dna_gap = int $dna_gap;
	
	#print $dna_gap,"\n";
	
	#print Dumper %$r_intron_like;
	
	if (keys %$r_intron_like > 0){
		foreach my $key (keys %$r_intron_like){
			#$dna_gap += ($$r_intron_like{$key} - $key + 1)/3;
			$dna_gap += int (($$r_intron_like{$key} - $key + 1)/3); # modify zhenghk 2006-12-12 17:16, add int;	V.10.0;
		}
	}
	
	
	
	#print $exon_no_gap_len,"\t",$pro_gap,"\t",$dna_gap,"\n";
	
	my $exon_total_len = $exon_no_gap_len + $pro_gap + $dna_gap;

	if (($exon_total_len - int($exon_total_len)) > 0.1) {
		print "ERROR: ",$exon_total_len,"\n";
	}
	
	return $exon_total_len;
	
		
	
}

sub GetIntronLikeGap {
	my ($r_support_dna,$start,$stop,$phase,$r_intron_like_insert) = @_;
	
	my @key_sort = (sort {$a<=>$b} keys %$r_support_dna);
	
	
	my $support_min = $key_sort[0];
	my $support_max = $$r_support_dna{$key_sort[-1]};
	
	#print $start,"\t",$stop,"=\n";
	#print $support_min,"\t",$support_max,"==\n";
		
	if ($start < $stop) {
		#print "-=-==-=-=-=-=-=-=-==-===-=-\n";
		#print "[$stop] - [$support_max] > 3\n";
		
		if ($support_min - $start > 3){
			
			if ($phase > 0){
				$$r_intron_like_insert{$start + (3 - $phase)} = $support_min - 1;
				#print $start + (3 - $phase),"\t",$support_min - 1,"\n";
				#exit;
			}
			else {
				$$r_intron_like_insert{$start} = $support_min - 1;
				#print $start,"\t",$support_min - 1,"\n";
				#exit;
			}
		}
		
		
		if ($stop - $support_max > 3){
			
			$$r_intron_like_insert{$support_max + 1} = $stop - ($stop-$support_max)%3;
			
#			print "(($stop -$start + 1) - (3 - $phase)) % 3;\n";
#			my $next_exon_phase = (($stop -$start + 1) - (3 - $phase)) % 3;
#			$$r_intron_like_insert{$support_max + 1} = $stop - $next_exon_phase;
#			print "$support_max + 1\t$stop - $next_exon_phase\n";
#			#exit;
		}
	}
	else {
		if ($start - $support_max > 3){
			if ($phase > 0){
				$$r_intron_like_insert{$support_max + 1} = $start - (3 - $phase);
				#print $support_max + 1,"\t",$start - (3 - $phase),"\n";
				#exit;
			}
			else {
				$$r_intron_like_insert{$support_max + 1} = $start;
				#print $support_max + 1,"\t",$start,"\n";
				#exit;
			}
		}
		if ($support_min - $stop > 3){
			my $next_exon_phase = (($start -$stop + 1) - (3 - $phase)) % 3;			
			$$r_intron_like_insert{$stop + $next_exon_phase} = $support_min - 1;
			#print $stop + $next_exon_phase,"\t",$support_min -1,"\n";
			#exit;
		}
	}
	
	#print Dumper %$r_intron_like_insert;
	
}
			


sub ProjectHash {
	my ($r_hash,$r_return,$r_overlap)=@_;
	my @key=sort {$a<=>$b} keys %$r_hash;
	
	for(my $j=0;$j<@key;$j++){
		for (my $i=$j+1;$i<@key;$i++){
			if ($$r_hash{$key[$j]}>=($key[$i])-1){	#modify add '=';
				if ($$r_hash{$key[$i]}>$$r_hash{$key[$j]}){
					$$r_overlap{$key[$i]}=$$r_hash{$key[$j]};	#modify zhenghk 2003-10-24 add overlap return;
					$$r_hash{$key[$j]}=$$r_hash{$key[$i]};
					$$r_hash{$key[$i]}=0;
				}
				else {
					$$r_overlap{$key[$i]}=$$r_hash{$key[$i]};	#modify zhenghk 2003-10-24 add overlap return;
					$$r_hash{$key[$i]}=0;
				}
			}
		}
	}
	
	foreach (keys %$r_hash){
		if ($$r_hash{$_} ne 0){
			$$r_return{$_}=$$r_hash{$_};
		}
	}
}

sub DealSplitCodon {
	my ($r_protein,$r_translate,$r_dna,$r_exon_len,$r_phase_exon,$r_lost_info) = @_;
	
	my @split_pro_posi;
	my @split_dna_posi;
	
	#print Dumper @$r_exon_len;
	
	for(my $i=0;$i<@$r_exon_len -1;$i++){
		$split_pro_posi[$i] = $split_pro_posi[$i-1] + $$r_exon_len[$i];
		$split_dna_posi[$i] = $split_pro_posi[$i]*3;
	}
	
	#print Dumper @split_pro_posi;
	#print Dumper @split_dna_posi;
	
	my @protein_split;
	my @translate_split;
	my @dna_split;
	
	SplitSeq($$r_protein,\@split_pro_posi,\@protein_split);
	SplitSeq($$r_translate,\@split_pro_posi,\@translate_split);
	SplitSeq($$r_dna,\@split_dna_posi,\@dna_split);
	
	#print Dumper @protein_split;
	#print Dumper @translate_split;
	#print Dumper @dna_split;	
	
	my $protein_revised;
	my $translate_revised;
	my $dna_revised;
	
	#print Dumper %$r_phase_exon;
	
	for(my $i=0;$i<@protein_split;$i++){
		$protein_revised .= $protein_split[$i];
		#print $protein_split[$i],"\n";	
		#$protein_revised .= '-';
		#print $$r_lost_info[$i],"\n";
		# 2004-11-17 13:06 use true aa instead of the gap;
		my ($protein_aa) = $$r_lost_info[$i]=~/([A-Z\-])\:\S+\[\S+\]/;
		#print "[$protein_aa]\n";
		#print $protein_revised,"\n";
		$protein_revised .= $protein_aa;
		#print $protein_revised,"\n";
			
	}
	
	for(my $i=0;$i<@protein_split;$i++){
		$translate_revised .= $translate_split[$i];
		#print $translate_split[$i],"\n";
		my ($translate_aa) = $$r_lost_info[$i]=~/\S+\:([A-Z\-])\[\S+\]/;
		#print "[$translate_aa]\n";
		#print $translate_revised,"\n";
		$translate_revised .= $translate_aa;
		#print $translate_revised,"\n";
	}
	
	#print $translate_revised,"\n";

	for(my $i=0;$i<@protein_split;$i++){
		$dna_revised .= $dna_split[$i];
	
		my ($dna_codon) = $$r_lost_info[$i]=~/\S+\:\S+\[(\S+)\]/;
		#print "[$dna_codon]\n";
		$dna_revised .= $dna_codon;
		

	}
	
	$$r_protein = $protein_revised;
	$$r_translate = $translate_revised;
	$$r_dna = $dna_revised;
	
}


sub MultipleSeq {
	my ($file,$output)=@_;
	my $pro_name='';
	my $dna_name='';
	my $pro_seq='';
	my %dna_seq;
	my %pro_start;
	my %muti_seq;
	
	#add cutoff and identity filter 2004-7-2 15:02
	#my $cutoff = 70;
	#my $identity = 0;
	
	$/="\n";
	my %indelPos;
	
	open(I,$file)||die"input error [$file]\n";
	open(O,">$output")||die "Multiple sequence output error [$output]\n";
	while(<I>){
		chomp;
		if (/^\$VAR1 = '(\S+)';/){
			if ($pro_name ne $1 && $pro_name ne ''){
				#print $pro_name,"\n";				
				#print Dumper %indelPos;
				#print Dumper %pro_start;
				#print Dumper %dna_seq;
				
				trimDNAseq(\%indelPos,\%dna_seq,\%pro_start,\%muti_seq);
				
				######## OUTPUT ###################
				
				# modify NULL keys of hash, 2004-11-18 9:54;
				if (exists $muti_seq{''}){
					warn "Error: with NULL key of \%muti_seq!\n";
					next;
					#exit;
				}
				
				#delete $muti_seq{''};
				
				my $seq_num = scalar keys %muti_seq;
				my $len = length $muti_seq{(sort {length $muti_seq{$b}<=> length $muti_seq{$a}} keys %muti_seq)[0]};
				
				print O " $seq_num $len\n\n";
				
				foreach my $name (keys %muti_seq){
					my $tail = '-' x ($len - (length $muti_seq{$name}));
					$muti_seq{$name}=~s/\d+/-/g;
					print O $name,"\t",$muti_seq{$name},$tail,"\n";
				}
				
				print O "//\n";
				
				######## OUTPUT ###################	
				
				%indelPos = ();
				%dna_seq = ();
				%pro_start = ();
				%muti_seq = ();
			}
			$pro_name = $1;
		}
		if (/^\$VAR2 = '(\S+)';/){
			$dna_name = $1;
		}
		if (/^\$VAR7 = '(\S+)';/){
			$pro_seq = $1;
		}
		if (/^\$VAR9 = '(\S+)';/){
			$dna_seq{$dna_name} = $1;
		}
		if (/^\$VAR10 = '(\S+)';/){
			$pro_start{$dna_name} = $1;
		}
		if(/^\/\//){
			if ($dna_name eq '') {
				print "error dna_name eq NULL!\n";
			}

			InDel($pro_seq,\%{$indelPos{$dna_name}},$pro_start{$dna_name});
			$dna_name = '';
		}
	}
	#print $pro_name,"\n";
	#print Dumper %indelPos;
	#print Dumper %pro_start;
	#print Dumper %dna_seq;
	
	trimDNAseq(\%indelPos,\%dna_seq,\%pro_start,\%muti_seq);
	
	######## OUTPUT ###################
	
	# modify NULL keys of hash, 2004-11-18 9:54;
	if (exists $muti_seq{''}){
		warn "Error: with NULL key of \%muti_seq!\n";
		next;
		#exit;
	}
			
	#delete $muti_seq{''};
				
	my $seq_num = scalar keys %muti_seq;
	my $len = length $muti_seq{(sort {length $muti_seq{$b}<=> length $muti_seq{$a}} keys %muti_seq)[0]};
	
	print O " $seq_num $len\n\n";
		
	foreach my $name (keys %muti_seq){
		my $tail = '-' x ($len - (length $muti_seq{$name}));
		print O $name,"\t",$muti_seq{$name},$tail,"\n";
	}
	
	print O "//\n";		
	######## OUTPUT ###################
	
	close O;
	
}

sub InDel {
	my ($seq,$r_indel,$start) = @_;
	
	#NGLAKCHFVA---------KDIVHSSHNCDVPHNHTNYQLIDISEDGLFVSLLTESGNTKDDLGLPTE-TIS------WGRSRLDLV----KARKEEEIYALKDIGTK
	
	my (@space) = $seq=~/(\-+)/g;
	
	foreach (@space){
		#print $_,"\n";
		#my $target = 'B' x (length $_);
		#$$r_indel{index($seq,$_)} = (length $_);
		#$seq =~ s/$_/$target/;
		
		# modify change to no gap position, 2004-11-17 22:14;
		$$r_indel{index($seq,$_)} = (length $_);
		$seq =~ s/$_//;
	}
}

sub trimDNAseq {
	my ($r_indel,$r_seq,$r_start,$r_return)=@_;
	
	my %all;
	
	foreach my $dna (keys %{$r_indel}){
		if($dna eq ''){
			warn "Error: with NULL dna name!\n";
			#print Dumper $$r_indel{$dna};
			next;
			#exit;
		}
		
		
		foreach my $sub_start (keys %{$$r_indel{$dna}}){
			if ($$r_indel{$dna}->{$sub_start} > $all{$sub_start + $$r_start{$dna} - 1}){
				$all{$sub_start + $$r_start{$dna} - 1} = $$r_indel{$dna}->{$sub_start};
			}
		}

	}
	
	#print Dumper %all;
	
	foreach my $dna(keys %{$r_seq}){
		
		#print $dna,"\n";
		
		my @split_posi;
		my @add_block;
		my @before_start_add_block;
		
		GetSplitSeqPosi($dna,\%all,$r_start,$r_indel,\@split_posi,\@add_block,\@before_start_add_block);
		
		#print Dumper @split_posi;
		#print "=================================\n";
		#print Dumper @add_block;
		#print "=================================\n";
		#print Dumper @before_start_add_block;
		#print "=================================\n";
		
		my $trimed_seq = ('-' x (($$r_start{$dna}-1) * 3));
		
		foreach my $before_start_added (@before_start_add_block){
			$trimed_seq .= $before_start_added;
		}
		
		my @split_seq;
		
		SplitSeq($$r_seq{$dna} ,\@split_posi,\@split_seq);
		
		#print Dumper @split_seq;
		
		for(my $i=0;$i<@split_seq;$i++){
			$trimed_seq .= $split_seq[$i];
			$trimed_seq .= $add_block[$i];
		}
		$$r_return{$dna}=$trimed_seq;
	}
	
		
}

sub GetSplitSeqPosi {
	my ($dna,$r_all,$r_start,$r_indel,$r_split_posi,$r_add_block,$r_before_add_block) = @_;
		
	my $i = 0;
	my $j = 0;
	my $tag = 0;
	
	my $before_sum_gap = 0;
	
	#print $dna,"\n";
	
	foreach my $gap_start (sort {$a<=>$b} keys %$r_all){
		
		my $gap = 0;
		my $diff_len = 0;
		my $same_start_tag = 1;
		
		if (exists $$r_indel{$dna}->{$gap_start - $$r_start{$dna} + 1}){
			
			$gap = $$r_indel{$dna}->{$gap_start - $$r_start{$dna} + 1};
						
			if ($$r_indel{$dna}->{$gap_start - $$r_start{$dna} + 1} == $$r_all{$gap_start}){
				$tag = 1;
				$same_start_tag = 1;
			}
			else {
				$tag = 0;
				$same_start_tag = 0;
				$diff_len = $$r_all{$gap_start} - $$r_indel{$dna}->{$gap_start - $$r_start{$dna} + 1};
				#print $diff_len,"\n";
				#exit;
				
			}
		}
		else {
			$tag = 0;
		}
		
		
		#print $gap_start,"\t";
		#print $$r_start{$dna},"\t";
		#print $before_sum_gap,"\t";
		
		my $with_gap_posi = $gap_start + $before_sum_gap;
		
		#print "[$with_gap_posi]\n";
			
		my $split_posi_on_dna = (($with_gap_posi -$$r_start{$dna} + 1) * 3);	#modify 2004-10-26 14:12 zhenghk add "+1"; remove "+1";
		
		#print "<$split_posi_on_dna>\n";
		
		$before_sum_gap += $gap;
		
		if ($tag == 1){
			next;
		}
		else {
			#print $split_posi_on_dna,"\t",$$r_start{$dna}*3,"\n";
			
			if ($split_posi_on_dna > 0){ #modify change '$$r_start{$dna}*3' to 0; V.6.4
				push(@$r_split_posi,$split_posi_on_dna);
				
				if ($same_start_tag == 0){
					$$r_add_block[$i++] = ('-' x ($diff_len*3));
				}
				else {
					$$r_add_block[$i++] = ('-' x ($$r_all{$gap_start}*3));
				}
			}
			else {
				#print "================\n";
				$$r_before_add_block[$j++] = ('-' x ($$r_all{$gap_start}*3));
			}
		}
	}
}




sub SplitSeq {
	my ($seq,$r_posi,$r_subseq) = @_;
	#print $seq,"\n";
	#print length $seq,"\n";
	my @posi = sort {$a<=>$b} @{$r_posi};
	
	#print Dumper @posi;
	my $start = 0;
	my $i = 0;
	
	for($i=0;$i<@posi;$i++){
		
		#print $start,"\t",$posi[$i]-$start,"\n";
		
		if (($posi[$i] - $start) % 3 != 0){
			#print "!!!!!!!!!!!",$start,"\t",$posi[$i]-$start,"\n";
		}
		
		$$r_subseq[$i] = substr($seq,$start,$posi[$i]-$start);
		$start = $posi[$i];
	}
	
	if (((length $seq) -$start) % 3 != 0){
		#print "!!!!!!!!======",$start,"\t",(length $seq)-$start,"\n";
	}
	
	$$r_subseq[$i] = substr($seq,$start,(length $seq) -$start);
	
		
}


	
sub LoadQueryLen {
	my ($file,$r_hash)=@_;
	my $seq='';
	my $name='';
	
	#print "Load Query Protein length!\n";
	open(IN,$file)||die"can't open the Fasta file [$file]\n";
	while(<IN>){
		chomp;
		if(/^>/){
			if ($seq ne ''){
				$$r_hash{$name}=length $seq;
				$seq='';
			}
			($name)=$_=~/^>(\S+)/;
		}
		else {
			$seq.=$_;
		}
	}
	if ($seq ne ''){
		$$r_hash{$name}=length $seq;
		$seq='';
	}
}


		
		

sub Head {
	print <<"HEAD";
	
$0 Version $Version ($Update) - 

	$Function
	Update : $Update
	Author : $Author
	Contact: $Contact

--------------------------------------------------------------------------------
Input GeneWise to search   :   $input
Input Query Protein fasta  :   $query_file
Output Middle file         :   $middle_file
Output Table written       :   $output_table
Output blat psl format     :   $blat_format
Output Multiple Seq        :   $output_seq
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

		-i            Input GeneWise Result
		
		-q            Query protein sequences used to run GeneWise

		-m            Output or Input Middle file (default middle.out)

		-ot           Output Table file with homolog info (default \$middle_file.tab)
		
		-ob           Output Blat format psl mapping position (default genewise2blat.psl)
		
		-os           Output Multiple sequences file (default multiple_sequence.out)
		
		-s            Step, 1 for Midd and Multiple, 2 for Multiple
		
		-only         Only generate Midd and table files
		
		-h or -help   Show help , have a choice

    Usage

	exit(0);
};		

my $middle_file   =    defined $opts{m} ? $opts{m} : "middle.out";
my $blat_format   =    defined $opts{ob} ? $opts{ob} : "genewise2blat.psl";
my $output_seq    =    defined $opts{os} ? $opts{os} : "multiple_sequence.out";
my $output_table  =    defined $opts{ot} ? $opts{ot} : "$middle_file.tab";


=head1 INPUT_FORMAT
genewise $Name: wise2-2-0 $ (unreleased release)
This program is freely distributed under a GPL. See source directory
Copyright (c) GRL limited: portions of the code are from separate copyright

Query protein:       AK058206
Comp Matrix:         blosum62.bla
Gap open:            12
Gap extension:       2
Start/End            default
Target Sequence      AK058206_Chr03_35585125_35590358
Strand:              both
Start/End (protein)  default
Gene Paras:          human.gf
Codon Table:         codon.table
Subs error:          1e-05
Indel error:         1e-05
Model splice?        model
Model codon bias?    flat
Model intron bias?   tied
Null model           syn
Algorithm            623

genewise output
Score 254.38 bits over entire alignment
Scores as bits over a synchronous coding model

Warning: The bits scores is not probablistically correct for single seqs
See WWW help for more info

AK058206           1 MSDSEEHHFESKADAGASKTYPQQAGTIRKNGYIVIKNRPCK
                     MSDSEEHHFESKADAGASKTYPQQAGTIRKNG+IVIKNRPCK
                     MSDSEEHHFESKADAGASKTYPQQAGTIRKNGHIVIKNRPCK
AK058206_Chr03_ 2001 atgtggcctgtagggggtaatcccggaacaagcagaaaccta
                     tcacaaaatacacacgccacacaacgctgaagatttaagcga
                     ggccggcccgggccccgcgccgggttttcgctttccgccacg


AK058206          43                        VVEVSTSKTGKHGHAKCHFVGIDIFN
                                            VVEVSTSKTGKHGHAKCHFV IDIFN
                                            VVEVSTSKTGKHGHAKCHFVAIDIFN
AK058206_Chr03_ 2127 GTCTGGA  Intron 1   TAGggggtataagacgcgatctggagata
                     <0-----[2127 : 3108]-0>ttatcccacgaagacagattctatta
                                            ttgccccgtggtataacctgctccct


AK058206          69 GKKLEDIVPSSHNCD                       VPHVDRTDYQL
                     GKKLEDIVPSSHNCD                       VPHV+RTDYQL
                     GKKLEDIVPSSHNCD                       VPHVNRTDYQL
AK058206_Chr03_ 3187 gaacggagcttcatgGTAAGTA  Intron 2   CAGgccgacagtcc
                     gaataattcccaaga<0-----[3232 : 3316]-0>tcatagcaaat
                     gggtattgccccctc                       cccgcttttgg


AK058206          95 IDISEDGF                       VSLLTESGNTKDDLRLPT
                     IDISEDGF                       VSLLTESG TKDDLRLP+
                     IDISEDGF                       VSLLTESGGTKDDLRLPS
AK058206_Chr03_ 3350 agatgggtGTATGTT  Intron 3   CAGgaccagaggaaggcacca
                     tatcaagt<0-----[3374 : 3657]-0>tgttcagggcaaatgtcg
                     tcttatat                       cccgtatactgtcggctt


AK058206         121 DDTLTNQ                       IKNGFGEEGKDMILTVMSA
                     D+ L  Q                       IK+GF E GKD+I+TVMSA
                     DEALLTQ                       IKDGFAE-GKDLIVTVMSA
AK058206_Chr03_ 3712 gggccacGTTAGTG  Intron 4   AAGaaggtgg gagcagagatg
                     aacttca<0-----[3733 : 3823]-0>taagtca gaatttcttcc
                     tgtgttg                       cgtaccg ggtgttcggtc


AK058206         147 MGEEQICAVKEIGAKN
                     MGEEQICA+K+IG KN
                     MGEEQICALKDIGPKN
AK058206_Chr03_ 3878 agggcatgcagagcaa
                     tgaaatgctaatgcaa
                     gtgggcctggttccgc


//
Gene 1
Gene 2001 3925
  Exon 2001 2126 phase 0
     Supporting 2001 2126 1 42
  Exon 3109 3231 phase 0
     Supporting 3109 3231 43 83
  Exon 3317 3373 phase 0
     Supporting 3317 3373 84 102
  Exon 3658 3732 phase 0
     Supporting 3658 3732 103 127
  Exon 3824 3925 phase 0
     Supporting 3824 3844 128 134
     Supporting 3845 3925 136 162
//

genewise output
Score 13.17 bits over entire alignment
Scores as bits over a synchronous coding model

Warning: The bits scores is not probablistically correct for single seqs
See WWW help for more info

AK058206         130 NGFGEEGKDMIL
                     N + +EG+D IL
                     NNLQKEGEDKIL
AK058206_Chr03_-3058 aaccaggggaac
                     aataaagaaatt
                     ccaagaaatgat


//
Gene 1
Gene 3058 3023
  Exon 3058 3023 phase 0
     Supporting 3058 3023 130 141
//
=cut
