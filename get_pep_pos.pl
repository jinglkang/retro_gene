#!usr/bin/perl -w
open List1,"$ARGV[0]" || die"$!";
open List2,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";
my %hash;

while (<List2>) {
	chomp;
	s/>//;
	my @infor=split;
	$hash{$infor[0]}=$_;
}
while (<List1>) {
	chomp;
	
    print  OUT ">$hash{$_}\n" ;
}
