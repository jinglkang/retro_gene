#!/usr/bin/perl -w

use strict;
system ("more chimp.GC.pos|cut -f2|sort -u > chimp.chr.tmp");

open TMP, "chimp.chr.tmp";
my $seqfile;
while (<TMP>) {
	chomp;
	my $item=$_;
	system ("more chimp.GC.pos|awk '{if (\$2==\"$item\")print \$0}' > $item.pos");
	if ($item=~"random") {$seqfile="all_random.fa";}
	else {$seqfile=$item.".fa";}
	system ("perl /disk/home/lix/soft/120/soft/get_fa_from_genome.lixin.pl -p $item.pos -s /disk/home/lix/data/Genome/chimp/chr_seq/$seqfile -o $item.GC.seq");
#last;
}
unlink ("rat.chr.tmp");

