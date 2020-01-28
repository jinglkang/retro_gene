#!/usr/bin/perl -w

use strict;
open Total, "$ARGV[0]"||die '!';
open Family,"$ARGV[1]"||die '!';
open Multi,">$ARGV[2]"||die '!';
open Single,">$ARGV[3]"||die '!';


#GSTENP00001748001_15_random_2600598_2601595     15_random       +       2599598 2602595
#GSTENP00003411001_15_random_1233476_1234181     15_random       +       1232476 1235181

#GSTENP00000909001       GSTENP00000923001       GSTENP00008670001       GSTENP00028984001
#GSTENP00008453001       GSTENP00012437001       GSTENP00012446001
#GSTENP00018483001       GSTENP00022427001
my %gene;

while (<Total>) {
	chomp;
	my @infor=split;
	my @tmp=split /_/,$infor[0];
	$gene{$infor[0]}=$tmp[0];
}
close Total;


my %final_list;
my $count;
while (my $line=<Family>) {
	chomp $line;
	$count++;
	print "$count\n";
	my @infor=split /\s+/, $line;
	for (my $i=0;$i<@infor ;$i++) {
	
		foreach my $key (keys %gene) {
			if ($infor[$i] eq $gene{$key}) {
				#print ">>>>>>>>>>>>>>$infor[0]\t$gene{$key}\n";
				$final_list{$line}.="$key\t";
				delete $gene{$key};#已归类的gene删除，减少下一次的循环量
				}

		}
	}
}

foreach my $key (keys %final_list) {
	my @infor=split /\s+/,$final_list{$key};
	print Multi "$final_list{$key}",scalar @infor,"\n";
}

my %new;
foreach my $key (keys %gene) {
	my @infor=split /\s+/,$key;
	my @tmp=split /_/,$infor[0];
	$new{$tmp[0]}.="$infor[0]\t";
}

foreach my $key (keys %new)
{
	my @infor=split /\s+/,$new{$key};
	if (@infor>1){print Multi "$new{$key}",scalar @infor,"\n";}
	else{print Single "$new{$key}",scalar @infor,"\n";}


}