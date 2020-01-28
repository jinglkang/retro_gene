#!/usr/local/bin/perl

my $Version =  "V.3.1";
my $Author  =  "Hongkun Zheng";
my $Date    =  "2003-10-9";
my $Update  =  "2003-10-10 21:33";
my $Function=  "";
my $Contact =  "zhenghk\@genomics.org.cn";
my $modify  =  "";

#-------------------------------------------------------------------

#-------------------------------------------------------------------
#根据target sequence的名字取genewise结果

use strict;
use Getopt::Long;
use Data::Dumper;


my %opts;

GetOptions(\%opts,"i:s","l:s","o:s","help");


if(!defined($opts{i}) || !defined($opts{i}) || defined($opts{help}) ){
	
	Usage();
	
}

my $input   =    defined $opts{i} ? $opts{i} : "";
my $list    =    defined $opts{l} ? $opts{l} : "";
my $output  =    defined $opts{o} ? $opts{o} : "";


Head();

my %list_hash;
LoadList($list,\%list_hash);

#print Dumper %list_hash;

my %out;
$/="genewise \$Name:";

open(I,$input)||die;
open(O,">$output")||die "can't create output file [$output]\n";

while(<I>){
	
	if ($_ eq 'genewise $Name:'){
		next;
	}
	
	my ($name) = $_=~/Target Sequence\s+(\S+)/;
	
		
	#if ($name =~/AK109544/){
	#	print "===[$name]\n";
	#}
	
	#print "[$name]\n";
	#exit;
	
	$_ =~s/genewise \$Name:  $//;
	$_= "genewise \$Name:  $_";
	
	if (exists $out{$name}){
		print $name,"\n";
		print $out{$name};
		print $_,"\n";
		
		$out{$name} = $_;
		
	}
	else {
		$out{$name} = $_;
	}
	

}


foreach my $name (keys %list_hash){
	
	if (exists $out{$name}) {
		print O $out{$name};
		
	}
	else {
		print "[$name]\n";
	}
	
	
}

close I;
close O;




sub LoadList {
	my ($file,$r_hash) = @_;
	
	open(I,$file)||die;
	while(<I>){
		chomp;
		my $name = (split(/\s+/))[0];
		
		$$r_hash{$name} = 1;
	}
	close I;
}



sub Head {
	print <<"HEAD";
	
$0 Version $Version ($Date) - 

	$Function
	Update : $Update
	Author : $Author
	Contact: $Contact

--------------------------------------------------------------------------------
Input file to search  :   $input
Output file written   :   $output
--------------------------------------------------------------------------------

HEAD
}



sub Usage #help subprogram
{
    print << "    Usage";
    
	Version: $Version
	Author : $Author
	Update : $Update
	
	Description :
	
		$Function!

	Usage: $0 <options>

		-i            Input Directory contain sim4z result

		-o            Output file
		
		-h or -help    show help , have a choice

    Usage

	exit(0);
};		

