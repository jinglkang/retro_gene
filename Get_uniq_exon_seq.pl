#!/usr/bin/perl -w
use strict;
open Exon_List, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Ref_list, "$ARGV[1]"||die "can not open $ARGV[1]\n";
open Seq, "$ARGV[2]"||die "can not open $ARGV[2]\n";
#open HOMO, "$ARGV[3]"||die "can not open $ARGV[3]\n";


open OUT, ">$ARGV[3]"||die "can not open $ARGV[3]\n";



my %hash_ref;
while (my $line=<Exon_List>) {
	chomp $line;
	my @infor=split /\t/, $line;
	$hash_ref{$infor[0]}=$infor[1];
#AY647140,1      NM_001002277    +       7942    8111    170     low     100     1       1
#AY647140,2      NM_001002277    +       8546    8765    220     low     100     1       1
#AY647140,3      NM_001002277    +       10386   10578   193     low     100     1       1
#AY647140,4      NM_001002277    +       10796   10891   96      low     100     1       1
#AY647140,5      NM_001002277    +       14395   14580   186     low     100     1       1
#AY647140,6      NM_001002277    +       15889   16041   153     low     100     2       2



}
close Exon_List;

my %hash_ugid;
while (my $line=<Ref_list>) {
	chomp $line;
	my @infor=split /\t/, $line;
	$hash_ugid{$infor[0]}=$infor[2];
#XM_341314	+	Rn.2	1	1029	
#NM_053575	+	Rn.4	332	6880	
#XM_230589	+	Rn.8	1	5484	
#NM_019386	+	Rn.10	57	2117	

}
close Ref_list;

my %hash_seq;
my %exon_ugid;
	my $name;

while (my $line=<Seq>) {
	#print $line;
	if ($line=~/^>/) {
		my @infor=split /\t/, $line;
		$name=$infor[0];
		$name=~s/>//;
		#$exon_ugid{$name}=$infor[1];
		#print $exon_ugid{$name},"\n";
	}
	else {
		$hash_seq{$name}=$line;

		}
#>CB567298,4     NM_080890       +
#GTGGAAGTGGCTAAGGCCTATCTTGAGTACCACACGGAAAAGTTCGGTTTCCAGACACCCAATGTGACTTTTCTTCACGGCCAAATTGAGATGTTGGCAGAGGCCGGGATCCAGAAGGAGAGCTA
#TGATATCGTTAT

}
close Seq;

#my %hash_homo;
#while (my $line=<HOMO>) {
#	chomp $line;
#	my @infor=split /\t/,$line;
##NM_139201	Hs.434996	NM_019834	Mm.195632	NM_001005553	Rn.77521
##NM_207299	Hs.382683	NM_178756	Mm.299460	NM_201271	Rn.60404
##NM_138687	Hs.260603	NM_054051	Mm.39700	NM_053550	Rn.30025
#$hash_homo{$infor[3]}=$infor[5];
#
#
#
#}


foreach my $key (keys %hash_ref) {
	#if(exists $hash)
	print OUT ">$key\t$hash_ref{$key}\t$key\tstrand\t1\t$hash_ugid{$hash_ref{$key}}\n";
	print OUT "$hash_seq{$key}";
}