#!/usr/bin/perl -w

#ENSP00000273550_14_65437406_65437867_gene_435

if (@ARGV<2) {
	print  "programm file_in file_out \n";
	exit;
}
open List1,"$ARGV[0]" || die"$!";
open List2,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";

#´Ólist1ÀïÈ¥³ýlist2
my %hash;
while (<List2>) {
	chomp;
	my @infor=split;
	$hash{$infor[0]}=$infor[0];
}

while (<List1>) {
	chomp;
	my $name=(split /_gene/,$_)[0];
	if (exists $hash{$name}) {next;}
	else {print OUT "$_\n";}
}