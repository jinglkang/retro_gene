#!/usr/bin/perl -w
#author luzhk
#BGI 
use strict;
if (@ARGV <2) {
	print "usage:\tclustalwParse.pl input_dir output\n";
	exit;
}

my $indir = shift;
if(!chdir "$indir"){print "the dir no found!\n";exit;} 
$indir = shift;
open OUT,">",$indir;
my @infile = `ls *.aln`;
foreach my $inaln (@infile) {
	chomp $inaln;
	my $inseq = $inaln;
	$inseq =~ s/aln$/seq/;
	#print "$inaln\t$inseq\n";
	open INaln,$inaln||die '!';
	open INseq,$inseq||die '!!';

#	处理特殊格式*.seq文件,提相关信息
#	>AA089212	NM_007376_GC	exon_00000021	-	1	exon_00000022	-	151	
#	TGAAAGGAGTCTTTTCCCTCCCAATTCAAGTGGAGCCAGGCATGGCTCCCGAGGCTCAGCTGCTCATTTATGCTATTTTACCTAATGAAGAACTTGTCGCTGATGCTCAGAATTTTGAAATCGAGAAGTGTTTTGCCAACAAGGTAAATTTGAGTTTCCCATCAGCACAGAGCCTGCCAGCCTCTGACACCCACCTGAAGGTCAAAGCCGCGCCTCTGTCCCTCTGTGCCCTCACTGCAGTAGACCAGAGTGTGCTGCTACTGAAGCCCGAAGCCAAGCTCTCACCTCAGTCA
#	>NM_007376 "NM_007376",4674,"","",50,4537,""
#	cagagttcgggggctgagggctcagacgttcttctctgccctctccaccatgaggagaaa

	my $Lineseq1 = <INseq>;chomp $Lineseq1;$Lineseq1 = substr($Lineseq1,1,length($Lineseq1)-1);
	my $Lineseq2 = <INseq>;chomp $Lineseq2;
	my $Lineseq3 = <INseq>;chomp $Lineseq3;
	my @tmp = split /,/,$Lineseq3;
	#print "$Lineseq1\n";
	my $cdsstart = $tmp[-3];
	my $cdsend = $tmp[-2];
	#print "$cdsstart\t$cdsend\n";
	close INseq;

#	处理特殊格式*.aln文件,提序列
#	CLUSTAL W (1.8) multiple sequence alignment
#
#
#	AA089212	NM_007376_GC	exon_000      --------------------------------------------------
#	NM_007376                           CAGAGTTCGGGGGCTGAGGGCTCAGACGTTCTTCTCTGCCCTCTCCACCA
#																						  
#
#	AA089212	NM_007376_GC	exon_000      --------------------------------------------------
#	NM_007376                           TGAGGAGAAACCAGCTGCCCACACCAGCTTTTCTTTTACTGTTCCTGCTT
#																					

	my $Linealn = <INaln>;
	$Linealn = <INaln>;
	$Linealn = <INaln>;
	my $seq1;
	my $seq2;
	while ($Linealn = <INaln>) {
		chomp ($Linealn);
		@tmp = split/ +/,$Linealn;
		$seq1 .= $tmp[1];
		$Linealn = <INaln>;
		chomp ($Linealn);
		@tmp = split/ +/,$Linealn;
		$seq2 .= $tmp[1];
		chomp $seq1;
		chomp $seq2;
		$Linealn = <INaln>;
		$Linealn = <INaln>;
		
	}
	#print OUT "$seq2\n";
	#print OUT "$seq1\n";
	#exit;
	#去多余字符
	$seq1 =~ s/[^\w|-]/-/;
	$seq2 =~ s/[^\w|-]/-/;
	if(length($seq1) != length($seq2)) {die "the length is not equal!error!";}
	#提exon编号,start,end 位置
	my @exons;
	my @exonstart;
	my @exonend;
	my @info = split /\t/,$Lineseq1;
	#print "$Lineseq1\n";
	
	while ($Lineseq1 =~ m/\b(\w+,\w+)\b/g) {
			@exons = (@exons,$1);
		}


	for(my $i = 0;$i<@exons-1;$i++) {
		$exonstart[$i] = $info[3*$i+4];
		$exonend[$i] = $info[3*$i+7]-1;
	}
	$exonstart[@exons-1] = $info[-1];
	$exonend[@exons-1] = length($Lineseq2);
	#print "$exonstart[@exons-1]\t$exonend[@exons-1]\n";
	
	if ($info[3] eq "-") {
		for(my $i = @exons-1;$i>=0;$i--) {
			my $size = $exonend[$i]-$exonstart[$i];
			if ($i == @exons-1) {
				$exonstart[$i] = 1;
			}else {
				$exonstart[$i] = $exonend[$i+1] +1;
			}
			$exonend[$i] = $size + $exonstart[$i];
		}
	}
	#print "$Lineseq2\n";
	#print length($Lineseq2);
	#print "\n";
	
	#print "$seq2\n";
	#print "$seq1\n";
	#print OUT "$seq2\n";
	#print OUT "$seq1\n";
	my @ref = split //,$seq2;
	my @est = split //,$seq1;
	#print "$seq1";
	my $refcount = 0;
	my $refphase = 0;
	my $estcount = 0;
	my $estphase = 0;
	my $framshift =0;
	my $eststart = 0;#起始
	my $estend = 0;
	my $eststartphase = 0;
	my $eststartp = 0;
	#print "seqlength:".length($seq2)."\n";
	#print "cdsstart:$cdsstart\tcdsend:$cdsend\n";
	#print length($seq2);
	for (my $i=1;$i<=length($seq2);$i++) {
		my$charref = shift @ref;
		my$charest = shift @est;
		#print "est:$charest\n";
		#print "ref:$charref\n";
		#print "i:$i\n";
		if($charref ne "-") {$refcount++;}#else {print "i:$i\n";}
		if($charest ne "-") {$estcount++;}
		if ($refcount>=$cdsstart&&$refcount<=$cdsend) {
			if($estphase >0&&$charest ne "-"){
					$estphase++;
			}
			if($charref ne "-"){
				$refphase++;
				if($estphase ==0&&$charest ne "-"){
					$estphase = $refphase;
					$eststartphase = $refphase;
					$eststartp = $estcount;
					#print "eststartp:$eststartp\trefpahse:$refpahse\ti:$i\n";
				}
			}#else {print "i:$i\n";}

			
			if($charref ne "-" && $charest ne "-"){
				if(($refphase - $estphase)%3 != 0){
					$framshift = 1;
					#print "refphase:$refphase\testphase:$estphase\n";
					last;
				}
			}
			if($refcount==$cdsstart){
				$eststart = $estcount;
				#print "eststart:$eststart\trefcount:$refcount\ti:$i\n";
				
				#print "cdsstart:\trefpahse:$refpahse\ti:$i\n";
				if($charest eq "-") {$eststart++;}
			}
			if($refcount==$cdsend){
				$estend = $estcount;
			}
		}
		if($refcount>$cdsend){ last;}
	}
	for (my $i=0;$i<@exons;$i++) {
		#print "$exons[$i]\t$exonstart[$i]\t$exonend[$i]\n";
	}
	#print "eststart:$eststart\testend:$estend\teststartp:$eststartp\teststartphase:$eststartphase\n";
	if($framshift){
		foreach my $exon (@exons) {
			print OUT "$exon\t$info[0]\t$info[1]\t$info[3]\t-1\tFrameShift\n";
		}
		#close(OUT);
		next;
	}
	my $e;
	my $s;
	#print ">>>@exons<<<";
	for (my $i=0;$i<@exons;$i++) {
		if($exonend[$i]<=$eststart){
			print OUT "$exons[$i]\t$info[0]\t$info[1]\t$info[3]\t-1\tbeforeCDS\n";
		}
		elsif($exonstart[$i]>=$estend){
			#print OUT"estend:$estend\texonstart:$exonstart[$i]\texonend:$exonend[$i]\n";
			print OUT "$exons[$i]\t$info[0]\t$info[1]\t$info[3]\t-1\tafterCDS\n";
		}
		else{
			if ($exonstart[$i]<$eststart) {
				$s = ($eststartphase+$eststart-$eststartp)%3;#eststart点相位012
				$s = $eststart+($s+1)%3 - $exonstart[$i]+1;
				if($s == 0) {$s = 2+$eststart- $exonstart[$i];}
				elsif($s == 2){$s = 3+$eststart- $exonstart[$i];}
				else{$s = 1+$eststart- $exonstart[$i]}
			}
			else{
				$s = ($exonstart[$i]-$eststartp+$eststartphase)%3;#exonstart[$i]点相位012
				if($s == 0) {$s = 2;}
				elsif($s == 2){$s = 3;}

			}
			if ($exonend[$i]>$estend) {
				$e = ($eststartphase+$estend-$eststartp)%3;
				$e = $estend - $exonstart[$i]+1-$e;
			}
			else{
				$e = $exonend[$i]-$exonstart[$i]+1 - ($exonend[$i]-$eststartp+$eststartphase)%3;
			}
			#print "$s\t$e\n";
			print OUT "$exons[$i]\t$info[0]\t$info[1]\t$info[3]\t$s\t$e\n";
		}
	}
}
