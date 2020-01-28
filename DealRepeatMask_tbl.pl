#!/usr/bin/perl -w

use strict;

open IN, $ARGV[0]||die '!';

my %retro;
my $name;
my %len;
my %inter;
my %mask;
my %line;
my %sine;
my %penelope;
my %ltr;
my %dna;
while (<IN>) {
	chomp;
	my @infor=split;
	if (/^file name/) {
		$name=$infor[2];
	}
	if (/^total lengt/) {
		$name.=$infor[2];
		$len{$name}=$infor[2];
		
	}
	if (/^Retroelements/) {
		$retro{$name}=$infor[2];
	}
	if (/^\s\s\sLINEs/){$line{$name}=$infor[2];}
	if (/^\s\s\sSINEs/){$sine{$name}=$infor[2];}
	if (/^\s\s\sPenelope/){$penelope{$name}=$infor[2];}
	if (/^\s\s\sLTR elements/){$ltr{$name}=$infor[3];}
	if (/^DNA transposons/){$dna{$name}=$infor[3];}
	
	if (/^Total interspersed repeats/)
	{$inter{$name}=$infor[3];}
	if (/^bases masked/){$mask{$name}=$infor[2];}
}

my $total_len;
my $total_retro;
my $total_inter;
my $total_mask;
my $total_line;
my $total_sine;
my $total_pene;
my $total_ltr;
my $total_dna;

foreach my $key (sort keys %retro) {
	
	$total_len+=$len{$key};
	$total_retro+=$retro{$key};
	$total_inter+=$inter{$key};
	$total_mask+=$mask{$key};
	$total_line+=$line{$key};
	$total_sine+=$sine{$key};
	$total_pene+=$penelope{$key};
	$total_ltr+=$ltr{$key};
	$total_dna+=$dna{$key};
}

print "total_line:",$total_line/$total_len,"\t","total_sine:",$total_sine/$total_len,"\t";
print "total_pene:",$total_pene/$total_len,"\t","total_ltr:",$total_ltr/$total_len,"\t";
print "total_dna:",$total_dna/$total_len,"\n";



#=====================================================
#file name: Danio_rerio.ZFISH6.42.dna.nonchromosomal.f
#sequences:          2966
#total length:   79143812 bp  (75548422 bp excl N/X-ru
#GC level:         37.07 %
#bases masked:   28788369 bp ( 36.37 %)
#=====================================================
#                   number of      length   percentage
#                   elements     occupied  of sequence
#-----------------------------------------------------
#Retroelements        19393      6277728 bp     7.93 %
#   SINEs:            12912      3125317 bp     3.95 %
#   Penelope              0            0 bp     0.00 %
#   LINEs:             4059      1580045 bp     2.00 %
#    CRE/SLACS            0            0 bp     0.00 %
#     L2/CR1/Rex       3358      1241620 bp     1.57 %
#     R1/LOA/Jockey      77        30002 bp     0.04 %
#     R2/R4/NeSL          0            0 bp     0.00 %
#     RTE/Bov-B         349       139700 bp     0.18 %
#     L1/CIN4           275       168723 bp     0.21 %
#   LTR elements:      2422      1572366 bp     1.99 %
#     BEL/Pao            77        57650 bp     0.07 %
#     Ty1/Copia           0            0 bp     0.00 %
#     Gypsy/DIRS1       737       413477 bp     0.52 %
#       Retroviral       87        48490 bp     0.06 %
#
#DNA transposons      52889     17022348 bp    21.51 %
#   hobo-Activator    15475      3263272 bp     4.12 %
#   Tc1-IS630-Pogo     7245      3177867 bp     4.02 %
#   En-Spm              150        65987 bp     0.08 %
#   MuDR-IS905            0            0 bp     0.00 %
#   PiggyBac           3654      1585038 bp     2.00 %
#   Tourist/Harbinger  3873      1516198 bp     1.92 %
#   Other (Mirage,      103        29674 bp     0.04 %
#    P-element, Transib)
#
#Rolling-circles          0            0 bp     0.00 %
#
#Unclassified:            0            0 bp     0.00 %
#
#Total interspersed repeats:    23300076 bp    29.44 %
#
#
#Small RNA:               0            0 bp     0.00 %
#
#Satellites:           1833       418880 bp     0.53 %
#Simple repeats:      41203      3770303 bp     4.76 %
#Low complexity:      26860      1312720 bp     1.66 %
#==================================================
#
#* most repeats fragmented by insertions or deletions
#  have been counted as one element
#
#
#The query species was assumed to be "Danio".
#RepeatMasker version open-3.1.6 , default mode
#run with cross_match version 0.990329
#RepBase Update 20061006, RM database version 20061006
