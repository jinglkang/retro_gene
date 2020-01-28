#!/usr/bin/perl -w

open Map, "$ARGV[0]"||die "!";
open Infor, "$ARGV[1]"||die "!";
open Seq, "$ARGV[2]"||die "!";
open OUT, ">$ARGV[3]"||die "!";
open TMP, ">$ARGV[3].no.seq"||die "!";

#CB161860        Noinfor Hs.2    Noinfor Noinfor
#AJ581145        +       Hs.2    68      510
#AJ581144        +       Hs.2    39      481
#>BC234506
#AAAAAAAAAAAA

my %hash_start=();
my %hash_end=();
my %hash_ugid=();
my %hash_seq=();
my %hash_list=();
my %hash_chr=();
my %hash_GC=();
#1720	494	1	0	1	1	2	5	2781	-	BE545575	498	0	498	chr1	245522847	148768469	148771746	6	44,7,222,125,4,94,	0,44,53,275,400,404,	148768469,148768514,148768525,148768748,148771647,148771652,	Hs.143873	Noinfor	Noinfor	NM_002966

while (my $map_line=<Map>) {
	chomp $map_line;
	my @tmp1=split /\n/, $map_line;
	my @tmp=split /\s+/, $tmp1[0];
	$hash_list{$tmp[10]}=$tmp[10];
	$hash_chr{$tmp[10]}=$tmp[14];
	$hash_GC{$tmp[10]}=$tmp[25];
}
close Map;

while (my $infor_line=<Infor>) {#读入编码位置信息
chomp $infor_line;
my @tmp=split /\t/, $infor_line;
$hash_ugid{$tmp[0]}=$tmp[2];
$hash_start{$tmp[0]}=$tmp[3];
$hash_end{$tmp[0]}=$tmp[4];
}
close Infor;


my $name;
while (my $seq_line=<Seq>) {#读入序列信息
	if ($seq_line=~/^>(\w+)/) {
		$name=$1;
	}
	elsif ($seq_line=~/^[a-z]/i) {
		$hash_seq{$name}.=$seq_line;
	}
}

foreach  my $key (keys %hash_list) {
	if (exists $hash_seq{$key}) {
		print OUT ">$key:$hash_GC{$key}:$hash_ugid{$key}:$hash_start{$key}:$hash_end{$key}\n";print OUT $hash_seq{$key};}
	else {print TMP ">$key:$hash_GC{$key}:$hash_ugid{$key}:$hash_start{$key}:$hash_end{$key}\n";}
}
close OUT;
close TMP;
exit
