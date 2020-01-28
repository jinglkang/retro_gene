#!/usr/bin/perl -w

use strict;
system ("ls *.fa > tmp");
open CHR,"tmp"||die "!";
while (<CHR>) {
	chomp;
	
	#my $name=(split /\./,$_)[0];
	#unless(-e "$name"){mkdir "$name", 0755;}
	system ("perl ../../../../soft/divide_fasta.pl -i $_ -od split_chr/ -f3 -N 20000000 -L 1000000");
}