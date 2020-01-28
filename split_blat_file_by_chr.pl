#!/usr/bin/perl -w

#按染色体分割文件
use strict;
#blat 格式
while (<>){
	chomp;
	my @infor=split;
	my $chr=$infor[13];
	print "$chr\n";
	open TMP, ">>$chr.blat.by.chr"||die '!';
	print TMP $_,"\n";
	close TMP;
}