#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
#gnf1m00217_a_at 10      XM_923561 XM_923557 XM_923551 XM_923547 XM_923543 XM_923538 XM_915045 NM_011981 Mm.195092       F8300

my $seq_name;
while (<IN>) {
	chomp;
	if (/^\#/) {next;}
	if (/^\^/) {next;}
	if (/^!/) {next;}
	if (/^ID/) {next;}
	my @infor=split /\t/,$_;
	
	
	if ($infor[2] eq '') {next;}

#	if ($infor[5]=~/\//) {
#		$seq_name=(split/\/\/\//,$infor[5])[0];
#	}
#	else{$seq_name=$infor[5];}

	$seq_name=(split /\s+/,$infor[2])[0];


	print "$infor[0]\t$seq_name\n";
	
}
