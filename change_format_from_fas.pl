#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";


#×ª¸ñÊ½
#>rat
#atg ggc tta ggcagtagccagcctagtacaaaggaagccgagccctgcacacttcaagagaaagaggaacatcctgttgatgac---accagacagcaaaataatgcggttcctgcaacagtctcagatcccgatcaagtgtcccctgcagttcaagacgcggagactcag
#>mouse
#atg ggc ata ggcaatagccagcctaattcacaggaagcccagctctgcacacttccagagaaagctgaacaacctactgatgataacacctgccagcaaaataatgtggttcctgcaacagtctcagaacccgatcaagcgtcccctgcaattcaagacgcggagactcag


my $num_of_per_line=60;
my $num_of_block=3;

my $name;
my %seq;
while (<IN>) {
	chomp;
	my $line=uc($_);
	if (/^>(\w+)/) {$name=$1;}
	else{$seq{$name}.=$line;}
}
close IN;

my $tag=0;
for (my $i=0;$i<length($seq{"human"}) ;$i++) {
$tag++;
my $tmp1=substr($seq{"human"},$i,1);
print "$tmp1";
if ($tag==$num_of_block) {print " ";$tag=0;}

}
print "\n";

$tag=0;

for (my $i=0;$i<length($seq{"chimp"}) ;$i++) {
$tag++;
my $tmp2=substr($seq{"chimp"},$i,1);
my $tmp1=substr($seq{"human"},$i,1);
if ($tmp2 eq $tmp1) {print ".";}
else{print "$tmp2";}
if ($tag==$num_of_block) {print " ";$tag=0;}
}
print "\n";
