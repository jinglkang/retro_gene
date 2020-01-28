#!/usr/bin/perl -w

use strict;
open Chr, "$ARGV[0]"||die "can not open $ARGV[0]\n";

open OUT, ">$ARGV[1]"||die "can not open $ARGV[1]\n";

while (<Chr>) {
	chomp;
	system ("more /disk/home/lix/data/Blat/rat/rat.gene.pos.new|awk '{if (\$2==\"$_\")print}' > /disk/home/lix/data/Blat/rat/GC_pos/$_.gene.pos");
last;
}