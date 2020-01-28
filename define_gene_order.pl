#!/usr/bin/perl -w
use strict;
open MEL, "$ARGV[0]"||die "can not open $ARGV[0]\n";
#open SIM, "$ARGV[1]"||die "can not open $ARGV[1]\n";

open OUT, ">$ARGV[1]"||die "can not open $ARGV[1]\n";


#NM_134657    +   chr2L   length  156028  157666
use strict;
my %hash_mel_order=();
my %hash_mel_gene=();
my %hash_mel_start=();
my %hash_mel_end=();
my %hash_mel_left=();
my %hash_mel_right=();
my %hash_mel_chr=();
my %hash_mel_strand=();
my %hash_mel_chr_size=();
my $chr_mel;
my $order_mel=1;
my $name;

while (<MEL>) {#给mel的gene order附值
	chomp;
	my @infor=split /\t/,$_;

	if($order_mel !=1 ){
		if($infor[2] eq $chr_mel){
			my $tmp_name=$name;
			$hash_mel_right{$name}=$infor[0];
			$name=$infor[0];
			$hash_mel_left{$name}=$tmp_name;
			}
	}
	$name=$infor[0];

	if (!defined $chr_mel) {$chr_mel=$infor[2];}#只有第一次执行
	if ($infor[2] ne $chr_mel) {$order_mel =1; $chr_mel= $infor[2];}
	$hash_mel_order{$name}=$order_mel;$order_mel++;
	$hash_mel_start{$name}=$infor[4];
	$hash_mel_end{$name}=$infor[5];
	$hash_mel_chr{$name}=$infor[2];
	$hash_mel_strand{$name}=$infor[1];
	$hash_mel_chr_size{$name}=$infor[3];
	$hash_mel_right{$name}=$chr_mel."_end";
	if($order_mel==2){$hash_mel_left{$name}=$chr_mel."_start";}#只有第一次和每次更换染色体的时候执行
	
}

close MEL;

my @mel_keys_sort_by_order= sort mel_by_chr_and_start keys %hash_mel_order;#得到按chr和start排序的gene的key

foreach my $key (@mel_keys_sort_by_order) {

	print OUT "$key\t$hash_mel_chr{$key}\t$hash_mel_strand{$key}\t$hash_mel_chr_size{$key}\t$hash_mel_order{$key}\t$hash_mel_left{$key}\t$hash_mel_right{$key}\t$hash_mel_start{$key}\t$hash_mel_end{$key}\n";
}


 sub mel_by_chr_and_start {
	$hash_mel_chr{$a} cmp $hash_mel_chr{$b}
	or
	$hash_mel_order{$a} <=> $hash_mel_order{$b}  
	
    }


