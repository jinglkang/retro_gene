#!/usr/bin/perl -w

use strict;
open Exon_est_relation, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open Exon_merge, "$ARGV[1]"||die "can not open $ARGV[1]\n";


#找出哪些est不含某个as的exon

open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";

#>>>	AA171800,2	44	48
#AA171800,2	BC041328,	NM_015954	5010	131108
#AA171800,2	BX403016,	NM_015954	5090	130200
#AA171800,2	CR608188,	NM_015954	5090	131069

#>>>	BX646278,1
#BP193368,1	NM_000014	+	76407767	128
#BX647329,1	NM_000014	+	7640	7789	150
#AB209614,1	NM_000014	+	7640	7823	184
#AL041738,1	NM_000014	+	7640	7823	184

my %hash_exon_est;
my $name;
while (<Exon_est_relation>) {
	if (/^>>>/) {
		my @infor=split;
		$name=$infor[1];
	}
	else {$hash_exon_est{$name}.=$_;}
}
close Exon_est_relation;

my %hash_exon_merge;
while (<Exon_merge>) {
	if (/^>>>/) {
		my @infor=split;
		$name=$infor[1];
	}
	else {$hash_exon_merge{$name}.=$_;}

}
close Exon_merge;

print "Begin search...\n";
my $est_id2;
my $start_2;
my $end_2;
foreach my $key (keys %hash_exon_est) {
	my %hash_tag=();
	my @tmp1=split /\n/,$hash_exon_est{$key};
	#print "$key\n";
	foreach my $item1 (@tmp1) {
	
		my $est_id1=(split /\t/,$item1)[1];
		my $start_1=(split /\t/,$item1)[3]; #est的起始和终止
		my $end_1=(split /\t/,$item1)[4];

						my @tmp2=split /\n/,$hash_exon_merge{$key};
						
							foreach my $item2 (@tmp2) {
											
								 $est_id2=(split /\t/,$item2)[0]; #exon的起始和终止
								 $start_2=(split /\t/,$item2)[3];
								 $end_2=(split /\t/,$item2)[4];
								
								#print $est_id2,"<<<<<<<<<<<<<\n";
								if ($est_id2=~/(.+,).+/) {
								$est_id2=$1;
								}

								#print $est_id2,"\n";
								if ($est_id1 eq $est_id2) 
									{
									$hash_tag{$est_id1}=1;
									}
							}
							#if ($est_id1 eq 'BY732833,') {print $hash_tag{$est_id1};}
							if (!defined $hash_tag{$est_id1}) {print OUT "$key\t$est_id1\t$start_1\t$end_1\t$start_2\t$end_2\n";}
					
	}
}