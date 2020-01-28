#!/usr/bin/perl -w

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
	my @infor=split;
	if (exists $hash{$infor[1]}) {next;}
	else {print OUT "$_\n";}
}