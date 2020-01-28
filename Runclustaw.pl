#!/usr/bin/perl -w

open EST, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open REF, "$ARGV[1]"||die "can not open $ARGV[1]\n";
open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";
 #perl ./soft/Runclustaw.pl ./result/fly/chr2L/exon.chr2L.format ./result/fly/ref.seq ./result/fly/chr2L/clust.out
my $dir=(split /all\.exon\.seq/, $ARGV[0])[0];
my $name =(split /\//,$ARGV[0])[-1];
#./result/fly/chr2L/
chop $dir;
print "$dir\n";
print "$name\n";

unless(-e "$dir/$name.phase"){mkdir "$dir/$name.phase", 0755;}
#>NM_000015 "NM_000015",,,,108,980,""
#ATGGATCCCTTACTATTTAGAATAAGGAACAAAATAAACCCTTGTGTATGTATCACCCAA
#CTCACTAATTATCAACTTATGTGCTATCAGATATCCTCTCTACCCTCACGTTATTTTGAA
#GAAAATCCTAAACATCAAATACTTTCATCCATAAAAATGTCAGCATTTATTAAAAAACAA
#TAACTTTTTAAAGAAACATAAGGACACATTTTCAAATTAATAAAAATAAAGGCATTTTAA
#GGATGGCCTGTGATTATCTTGGGAAGCAGAGTGATTCATGCTAGAAAACATTTAATATTG

#>BC065205	NM_000015	exon_1	-	1	exon_2	-	110	exon_3	-	160	exon_4	-	156	exon_5	-	170	exon_6	-	106	exon_7	-	136	exon_8	-	160	exon_9	-	152	exon_10	-	294	exon_11	-	142	exon_12	-	125	exon_13	-	48	exon_14	-	165	exon_15	-	128	exon_16	-	232	exon_17	-	130	exon_18	-	123	exon_19	-	120	exon_20	-	141	exon_21	-	77
#AAAAAAAAAAAAAA

my $est_name;
my %hash_est=();
my %hash_ref=();
while (my $est_line=<EST>) {#est¶ÁÈëhash
	chomp $est_line;
	if ($est_line=~/^>/) {
	my @infor=split /\t/, $est_line;
	$est_name=$infor[0];
	$est_name=~s/>//;
	$hash_est{$est_name}.="$est_line\n";
	}
	else{
	$hash_est{$est_name}.=$est_line;}
}
close EST;
my $ref_name;
while (my $ref_line=<REF>) {#ref¶ÁÈëhash
	chomp $ref_line;
	if ($ref_line=~/^>/) {
	my @infor=split /\s+/, $ref_line;
	$ref_name=$infor[0];
	$ref_name=~s/>//;
	$hash_ref{$ref_name}.="$ref_line\n";
	}
	else{
	$hash_ref{$ref_name}.=$ref_line;}
}

close REF;
open EST, "$ARGV[0]"||die "can not open $ARGV[0]\n";

open TMP3, ">$dir/align.$name.out"||die "!";

while (my $est_line=<EST>) {
	if ($est_line=~/^>/) {
	my @infor=split /\t/, $est_line;
	$est_name=$infor[0];
	$est_name=~s/>//;
	$ref_name=$infor[1];
	

open TMP1,">$dir/$name.phase/clust.$name.seq"||die"!";print TMP1 $hash_est{$est_name},"\n",$hash_ref{$ref_name};close TMP1;
system("clustalw-1.8 -infile=$dir/$name.phase/clust.$name.seq -outfile=$dir/$name.phase/clust.$name.aln -GAPEXT=t");

open Align, "$dir/$name.phase/clust.$name.aln"||die "!";
my @align=<Align>;print TMP3 @align;close Align;

#unlink ("$dir/$name.phase/clust.$name.dnd");
system ("perl /disk/home/lix/soft/120/soft/clustawParse.pl $dir/$name.phase phase.$name.tmp");

chdir '/disk/home/lix';
open TMP2,"$dir/$name.phase/phase.$name.tmp"||die "!!!!!!!!!!!!!!!!!!!";my @data=<TMP2>;
print OUT @data;close TMP2;

	}
}

close TMP3;
close OUT;
exit