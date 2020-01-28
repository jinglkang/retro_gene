#!/usr/bin/perl -w

use strict;
use Getopt::Long;

my $Function='按group1的list把含group1的group2取出来';

my %opts;

GetOptions(\%opts,"g1:s","g2:s","o:s","help");


if(!defined($opts{g1}) || !defined($opts{g2}) || !defined($opts{o}) || defined($opts{help}) ){
	
	Usage();
	
}
open Group1, "$opts{g1}"||die "can not open $opts{g1}\n";
open Group2, "$opts{g2}"||die "can not open $opts{g2}\n";

open OUT, ">$opts{o}"||die "can not open $opts{o}\n";



#NM_134664       chr2L   263781  266688
#NM_134665       chr2L   269087  271626
#NM_134667       chr2L   271900  274096
#NM_134668       chr2L   274947  277142
#NM_078719       chr2L   277587  282167

my %Group2_ref;
while (<Group2>) {
	chomp;
	my $name=(split /\t/,$_)[0];
	$Group2_ref{$name}=$_;
}
close Group2;

while (<Group1>) {
	chomp;
	my $name=(split /\t/,$_)[0];
	if (exists $Group2_ref{$name}) {print OUT $Group2_ref{$name},"\n";}
}
close Group1;



sub Usage #help subprogram
{
    print << "    Usage";
    
	Description :
	
		$Function

	Usage: $0 <options>

		-g1            group1 file

		-g2             group2 file
		
		-o             output file
		
		-h or -help   Show Help , have a choice

    Usage

	exit;
}	





exit

