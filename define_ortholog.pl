#!/usr/bin/perl -w

use strict;
open MEL, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open SIM, "$ARGV[1]"||die "can not open $ARGV[1]\n";


open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";
open NO, ">no.ortholog"||die "!";

#NM_205881       chr2L   -       396896  15      NM_164364       NM_164367       122614  130791
#NM_164367       chr2L   +       396896  16      NM_205881       NM_164368       132059  134472
#NM_164368       chr2L   -       396896  17      NM_164367       NM_164369       138696  139385
#NM_164369       chr2L   -       396896  18      NM_164368       NM_164370       139470  140933
#NM_164370       chr2L   -       396896  19      NM_164369       NM_134653       141073  142977
#NM_134653       chr2L   +       396896  20      NM_164370       NM_134654       143375  144227
#NM_134654       chr2L   -       396896  21      NM_134653       NM_134655       144232  149208

my %hash_mel_gene;
my %hash_mel_chr;
my %hash_mel_order;
my %hash_mel_left;
my %hash_mel_right;
my %hash_mel_start;
my %hash_mel_end;

while (<MEL>) {
	chomp;
	my @infor=split;
	$hash_mel_gene{$infor[0]}=$infor[0];
	$hash_mel_chr{$infor[0]}=$infor[1];
	$hash_mel_order{$infor[0]}=$infor[4];
	$hash_mel_left{$infor[0]}=$infor[5];
	$hash_mel_right{$infor[0]}=$infor[6];
	$hash_mel_start{$infor[0]}=$infor[7];
	$hash_mel_end{$infor[0]}=$infor[8];
}
close MEL;

my %hash_sim_gene;
my %hash_sim_chr;
my %hash_sim_order;
my %hash_sim_left;
my %hash_sim_right;
my %hash_sim_start;
my %hash_sim_end;
my %hash_size;
my %hash_strand;
while (<SIM>) {
	chomp;
	my @infor=split;
	$hash_sim_gene{$infor[0]}=$infor[0];
	$hash_sim_chr{$infor[0]}=$infor[1];
	$hash_sim_order{$infor[0]}=$infor[4];
	$hash_sim_left{$infor[0]}=$infor[5];
	$hash_sim_right{$infor[0]}=$infor[6];
	$hash_sim_start{$infor[0]}=$infor[7];
	$hash_sim_end{$infor[0]}=$infor[8];
	$hash_strand{$infor[0]}=$infor[2];
	$hash_size{$infor[1]}=$infor[3];
}
close SIM;


open MEL, "$ARGV[0]"||die "can not open $ARGV[0]\n";
my $count_two_side_same;
my $count_two_side_reverse;
my $count_one_side_same;
my $count_one_side_reverse;
my $count_no_ortholog;
my $count1;my $count2;
my @data_count_one_side_same=();

my $cutoff=50000;
my $overlap_cutoff=200000;

while (my $line=<MEL>) {
	my $start=0;my $end=0;
	chomp $line;
	my @infor=split /\t/, $line;
	my $name=$infor[0];

	if (($hash_mel_left{$name} eq $hash_sim_left{$name}) || ($hash_mel_right{$name} eq $hash_sim_right{$name}) || ($hash_mel_left{$name} eq $hash_sim_right{$name}) || ($hash_mel_right{$name} eq $hash_sim_left{$name})) 
	{
		if ($hash_sim_left{$name}=~/start/) {$hash_sim_end{$hash_sim_left{$name}}=1;$hash_sim_start{$hash_sim_left{$name}}=1;}
		if ($hash_sim_right{$name}=~/(.+)_end/) {$hash_sim_start{$hash_sim_right{$name}}=$hash_size{$1};$hash_sim_end{$hash_sim_right{$name}}=$hash_size{$1};}
		
		if ($hash_sim_start{$name} <= $hash_sim_start{$hash_sim_left{$name}}) {$count1++;$start=$hash_sim_start{$name}-$overlap_cutoff;}
		else {$start=$hash_sim_start{$hash_sim_left{$name}}-$cutoff;}
		
		if($start<=0){$start=1;}
		
		if ($hash_sim_end{$name} >= $hash_sim_end{$hash_sim_right{$name}}) {$count2++;$end=$hash_sim_end{$name}+$overlap_cutoff; }
		else {$end=$hash_sim_end{$hash_sim_right{$name}}+$cutoff;}
		if($end>=$hash_size{$hash_sim_chr{$name}}){$end=$hash_size{$hash_sim_chr{$name}};}
		
		print OUT "$hash_mel_gene{$name}\t$hash_sim_chr{$name}\t$hash_strand{$name}\t$hash_sim_start{$name}\t$hash_sim_end{$name}\t$start\t$end\n";
	}
	else {
		$count_no_ortholog++;
		print NO "$hash_mel_gene{$name}\t$hash_sim_chr{$name}\t$hash_strand{$name}\t$hash_sim_start{$name}\t$hash_sim_end{$name}\t$start\t$end\n";
		}
	if (($hash_mel_left{$name} eq $hash_sim_left{$name}) and ($hash_mel_right{$name} eq $hash_sim_right{$name})) 
	{$count_two_side_same++;}
	
	if (($hash_mel_left{$name} eq $hash_sim_right{$name}) and ($hash_mel_right{$name} eq $hash_sim_left{$name})) 
	{$count_two_side_reverse++}
	
	if (($hash_mel_left{$name} eq $hash_sim_left{$name}) and ($hash_mel_right{$name} ne $hash_sim_right{$name})) 
	{$count_one_side_same++;push @data_count_one_side_same, $name."\n";}
	if (($hash_mel_left{$name} ne $hash_sim_left{$name}) and ($hash_mel_right{$name} eq $hash_sim_right{$name})) 
	{$count_one_side_same++;}

	if (($hash_mel_left{$name} eq $hash_sim_right{$name}) and ($hash_mel_right{$name} ne $hash_sim_left{$name})) 
	{$count_one_side_reverse++;}
	if (($hash_mel_left{$name} ne $hash_sim_right{$name}) and ($hash_mel_right{$name} eq $hash_sim_left{$name})) 
	{$count_one_side_reverse++;}


}
close MEL;
print "$count1\t$count2\n";
print "count_two_side_same:$count_two_side_same\n";
print "count_two_side_reverse:$count_two_side_reverse\n";
print "count_one_side_same:$count_one_side_same\n";
print "count_one_side_reverse:$count_one_side_reverse\n";
print "count_no_ortholog:$count_no_ortholog\n";

#print @data_count_one_side_same;
exit