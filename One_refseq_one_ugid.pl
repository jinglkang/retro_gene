#!/usr/bin/perl -w

open REF, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open OUT, ">$ARGV[1]"||die "can not open $ARGV[1]\n";
open OUT1, ">findbest.tmp1"||die "!";
open OUT2, ">findbest.tmp2"||die "can not open \n";
open Extra, ">one_ref_one_ugid.tmp"||die "!";

#close REF;
#
#
#open REF, "$ARGV[0]"||die "can not open $ARGV[0]\n";


my @data=();
my %hash_tag=();
my %tmp=(); #保存第一次出现的记录

while (my $map_line=<REF>) {
	my @infor=split /\s+/, $map_line;
	my $name=$infor[10];
	
	if(!exists $hash_tag{$name}){$hash_tag{$name}=1; $tmp{$name}=$map_line;}
	else{$hash_tag{$name}++;print OUT2 $map_line;}

}

foreach my $key (keys %hash_tag) {
	if ($hash_tag{$key}==1) {
		push @data, $tmp{$key};      #将有冗余的放入数组@data，无冗余的输出到文件1
	}
	else {print OUT2 $tmp{$key};}
}

print OUT1 @data;
close OUT1;
close OUT2;
close REF;


open OUT2, "findbest.tmp2"||die "can not open \n";

my %hash_ref=();
my %best_size=();

while (<OUT2>) {#一个NM里只取一个最长的refseq
	my @infor=split;
	my $name=$infor[10];
	my $size=$infor[11];
	if (!exists $hash_ref{$name}) {
		$hash_ref{$name}=$_;$best_size{$name}=$size;}
	else{
		if ($size>$best_size{$name}) {$best_size{$name}=$size;$hash_ref{$name}=$_;}
		}
}


foreach my $key (keys %hash_ref) {
	push @data, $hash_ref{$key}; #获得非冗余的NM list
}
#print scalar @data;

my %hash_ref2=();
my %best_size2=();
foreach my $item(@data) {#一个ugid里只取一个最长的refseq
	my @infor=split /\t/, $item;
	my $ugid=$infor[22];
	my $size=$infor[11];
	if (!exists $hash_ref2{$ugid}) {
		$hash_ref2{$ugid}=$item;$best_size2{$ugid}=$size;}
	else{
		if ($size>$best_size2{$ugid}) {print Extra $hash_ref2{$ugid};$best_size2{$ugid}=$size;$hash_ref2{$ugid}=$item;}
		else {print Extra $item;}
	}
}

foreach my $key (keys %hash_ref2) {
	print OUT $hash_ref2{$key};
}
close OUT;
close Extra;
exit

