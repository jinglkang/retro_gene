#!/usr/bin/perl -w

use strict;
use Getopt::Long;

open Child_chain,"$ARGV[0]" || die"$!";
open Gap_list,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";

#134857  135771  917     8       0       134857_136304   NA      0       nonSyn
#135774  136133  362     8       0       134857_136304   NA      7       nonSyn
#136136  136169  36      8       0       134857_136304   1268    36      syn

#292035  293236  1202    1       chain 17408357451 chr1 229974691 + 243304 229800167 chr1 247249719 + 96118 246871250 1
#709076  712089  3014    1       chain 17408357451 chr1 229974691 + 243304 229800167 chr1 247249719 + 96118 246871250 1
my %gap_len;
while (<Gap_list>) {
	chomp;
	my @infor=split;
	my $gap_name="$infor[0]_$infor[1]";
	$gap_len{$gap_name}=$infor[2];
	#print "$gap_name\n";
}
close Gap_list;

my %fill_gap_len;
my %fill_gap_type;
my %fill_gap_distance;
my %fill_gap_duplicate;
my %score;

while (<Child_chain>) {
	chomp;
	my @infor=split;
	my $name=$infor[5];
	#print "$infor[5]\n";
	$fill_gap_len{$name}+=$infor[2];
	$fill_gap_duplicate{$name}+=$infor[-2];
	if (!exists $fill_gap_type{$name}) {$fill_gap_type{$name}=$infor[-1];$score{$name}=$infor[2];$fill_gap_distance{$name}=$infor[-3];}
	else {if($infor[2]>$score{$name}){$fill_gap_type{$name}=$infor[-1];$fill_gap_distance{$name}=$infor[-3];$score{$name}=$infor[2];}}
}

foreach my $key (keys %fill_gap_type) {
	if (!exists $gap_len{$key}) {next;}
	if (($fill_gap_len{$key}/$gap_len{$key}*100)>50) {
		my $local_type;
		my $duplication_type;
		if ($fill_gap_distance{$key} eq 'NA') {$local_type="far";}else{if($fill_gap_distance{$key}<3000) {$local_type="tandom";}else{$local_type="far";}}
		if (($fill_gap_duplicate{$key}/$fill_gap_len{$key}*100)>50) {$duplication_type="duplication";}else{$duplication_type="rearrangement";}
		print OUT "$key\t$fill_gap_type{$key}\t",$fill_gap_len{$key}/$gap_len{$key}*100,"\t$local_type\t$duplication_type\n";
	}
	else{#print ">>>>>>>>>>>>>\n";
	}
}
close Child_chain;