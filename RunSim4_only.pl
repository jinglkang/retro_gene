#!/usr/bin/perl -w

#>BC1:NM_3:Hs.2:68:5100
#GGGGGGGGGGGGGGGGG

#>NM_001779_chr1_116769198_116825703
#GTAGGCGGTGCTTGAACTTAGGGCTGCTTGTGGCTGGGCACTCGCGCAGAGGCCGGCCCG
#ACGAGCCATGGTTGCTGGGAGCGACGCGGGGCGGGCCCTGGGGGTCCTCAGCGTGGTCTG
#CCTGCTGCACTGCTTTGGTGAGTGAAGCCTGCCCCAggggccccgcgccggccggcgggT
#只跑sim4，不加only的同时提取结果
open EST, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open GC, "$ARGV[1]"||die "can not open $ARGV[1]\n";
open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";
#open OUT2, ">$ARGV[3]"||die "can not open $ARGV[3]\n";



my %hash_est=();
my %hash_gc=();
my $est_name;
my $name;
while (my $est_line=<EST>) {#读入est序列
$est_line=~tr/atcg/ATCG/;
#print $est_line;
if($est_line=~/^>/){
	my @infor=split /:/, $est_line;
	$est_name=$infor[0];
	$est_name=~s/>//;}
$hash_est{$est_name}.=$est_line;
}
close EST;

while (my $gc_line=<GC>) {#读入GC序列
$gc_line=~tr/atcg/ATCG/;
	#print $gc_line;
	if ($gc_line=~/^>(\w+)/) {
		$name=$1;
		$name=~s/>//;
	}
$hash_gc{$name}.=$gc_line;
}

open EST, "$ARGV[0]";

while (my $est_line=<EST>) {
if ($est_line=~/^>/) {
chomp $est_line;
my @infor=split /:/, $est_line;
$est_name=$infor[0];
$est_name=~s/>//;
$gc_name=$infor[1];

open TMP1, ">$ARGV[2].$est_name.est"||die "!!!!!!!";print TMP1 $hash_est{$est_name};close TMP1;
open TMP2, ">$ARGV[2].$gc_name.gc"||die "!!!!!!!!";print TMP2 $hash_gc{$gc_name};close TMP2;
system ("sim4 $ARGV[2].$est_name.est $ARGV[2].$gc_name.gc P=1 > $ARGV[2].sim4.tmp"); 
#system ("perl ./soft/extract_exon_pos_sim4.pl -i $ARGV[2].sim4.tmp -e $ARGV[2].sim4.pos -p $ARGV[2].sim4.cover");



#unlink ("$ARGV[2].$est_name");
#unlink ("$ARGV[2].$gc_name");

open TMP,"$ARGV[2].sim4.tmp"||die '!'; my @data=<TMP>;close TMP;print OUT @data;


#open POS, "$ARGV[2].sim4.pos"||die "!";my @data1=<POS>;close POS;print OUT @data1;
#open COV, "$ARGV[2].sim4.cover"||die "!";my @data2=<COV>;close COV;print OUT2 @data2;
#unlink ("sim4.pos");unlink ("sim4.cover");
}

}

close EST;
close GC;
close OUT;
#close OUT2;
exit