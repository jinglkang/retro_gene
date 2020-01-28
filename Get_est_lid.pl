#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open Lid, "$ARGV[1]"||die '!';
open OUT,">$ARGV[2]" || die"$!";

#ID=2516
#TITLE=RIKEN full-length enriched, 17 days embryo head
#TISSUE=head_and_neck
#VERBATIM_TISSUE=head
#VERBATIM_DEVELOPMENTAL_STAGE=17 days embryo
#VECTOR=-
my $lid_id;
my $tissue;
my $tag=1;
my %lid_tissue;
while (<Lid>) {
	chomp;
	#my $tmp;
	if (/^ID=(\d+)/) {$lid_id=$1;}
	if (/^TISSUE=(.*)/ or /VERBATIM_TISSUE=(.*)/) {$tissue=$1;$tag=1;}
	if($tag==1){$lid_tissue{$lid_id}=$tissue;$tag=0;$_=<Lid>;}
}


my %est_lid;
my %est_ugid;
my %est_chr;
	my $ugid;
	my $chr;

while (<IN>) {
	chomp;
	my @infor=split;
	if (/^ID/) {$ugid=$infor[1]; }
	if (/^CHROMOSOME/) {$chr="chr".$infor[1];}
	#print ">>>>>>>\n";
	if (/^SEQUENCE.*ACC=(\w+)\..*LID=(\d+);.*SEQTYPE=EST/) {
		my $name=$1;
		$est_lid{$name}=$2;
		#print "$1\t$2\t$chr\t>>>>>>>>>>\n";
		$est_chr{$name}=$chr;
		$est_ugid{$name}=$ugid;
		if (exists $lid_tissue{$est_lid{$name}}) {
		
		print OUT "$name\t$est_lid{$name}\t$lid_tissue{$est_lid{$name}}\t$est_chr{$name}\t$est_ugid{$name}\n";
		#last;
		}
	}
}