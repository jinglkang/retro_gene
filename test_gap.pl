#!/usr/bin/perl -w

use strict;
open IN,"$ARGV[0]" || die"$!";
open Gap,"$ARGV[1]" || die"$!";

open OUT,">$ARGV[2]" || die"$!";

#BC103529,8      NM_011089       314331  320522
#U96686,7        NM_011089       194789  199972
#BY127985,1      NM_008139       186155  191478

#NM_175563       11      195236  195622  387
#NM_175563       12      215864  216518  655
#NM_175563       13      224674  225307  634
my %gap;
while (<Gap>) {
	chomp;
	my @infor=split;
	$gap{$infor[0]}.="$infor[2]\t$infor[3]\n";
}

my %tag;
while (<IN>) {
	chomp;
	my @infor=split;
	my $name=$infor[1];
	my $start=$infor[2];
	my $end=$infor[3];
	if(exists $gap{$name}){
		my @data=split /\n/, $gap{$name};
			foreach my $item (@data) {
				my @tmp=split /\s+/,$item;
				if (!($start> $tmp[1] || $end <$tmp[0])) {
					$tag{$infor[0]}=1;
					}
			}
		if (!exists $tag{$infor[0]}) {
				print OUT $_,"\n";
			}
	}
}
exit